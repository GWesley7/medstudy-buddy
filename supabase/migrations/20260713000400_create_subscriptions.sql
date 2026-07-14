-- MedStudy Buddy V2 - Fase 3
-- Creates audit-friendly subscription records.
-- Strategy: multiple rows per user, with a partial unique index for one current subscription.

create table if not exists public.subscriptions (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  plan_code text not null references public.subscription_plans(code) on update cascade,
  status public.app_subscription_status not null,
  trial_started_at timestamptz null,
  trial_ends_at timestamptz null,
  trial_consumed_at timestamptz null,
  current_period_started_at timestamptz null,
  current_period_ends_at timestamptz null,
  cancel_at_period_end boolean not null default false,
  canceled_at timestamptz null,
  provider text null,
  provider_customer_id text null,
  provider_subscription_id text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint subscriptions_trial_dates_check check (
    (trial_started_at is null and trial_ends_at is null)
    or (
      trial_started_at is not null
      and trial_ends_at is not null
      and trial_ends_at > trial_started_at
    )
  ),
  constraint subscriptions_trial_consumed_check check (
    trial_consumed_at is null or trial_started_at is not null
  ),
  constraint subscriptions_current_period_dates_check check (
    current_period_started_at is null
    or current_period_ends_at is null
    or current_period_ends_at > current_period_started_at
  ),
  constraint subscriptions_canceled_at_status_check check (
    canceled_at is null or status in ('canceled', 'expired')
  ),
  constraint subscriptions_provider_check check (
    provider is null or provider ~ '^[a-z][a-z0-9_]{1,63}$'
  ),
  constraint subscriptions_provider_customer_id_check check (
    provider_customer_id is null
    or (
      length(btrim(provider_customer_id)) between 3 and 255
      and provider_customer_id !~ '[[:cntrl:]]'
    )
  ),
  constraint subscriptions_provider_subscription_id_check check (
    provider_subscription_id is null
    or (
      length(btrim(provider_subscription_id)) between 3 and 255
      and provider_subscription_id !~ '[[:cntrl:]]'
    )
  )
);

comment on table public.subscriptions is
  'Audit-friendly subscription and trial records. Clients may read their own row but cannot write directly.';
comment on column public.subscriptions.trial_consumed_at is
  'Set when the one-time trial benefit is consumed. It prevents restarting trial after status changes.';

create index if not exists subscriptions_user_id_idx
  on public.subscriptions (user_id);

create index if not exists subscriptions_status_idx
  on public.subscriptions (status);

create index if not exists subscriptions_trial_ends_at_idx
  on public.subscriptions (trial_ends_at)
  where trial_ends_at is not null;

create unique index if not exists subscriptions_one_current_per_user_idx
  on public.subscriptions (user_id)
  where status in ('trialing', 'active', 'past_due', 'paused', 'incomplete');

create unique index if not exists subscriptions_one_trial_consumed_per_user_idx
  on public.subscriptions (user_id)
  where trial_consumed_at is not null;

create unique index if not exists subscriptions_provider_customer_id_key
  on public.subscriptions (provider, provider_customer_id)
  where provider is not null and provider_customer_id is not null;

create unique index if not exists subscriptions_provider_subscription_id_key
  on public.subscriptions (provider, provider_subscription_id)
  where provider is not null and provider_subscription_id is not null;

drop trigger if exists set_subscriptions_updated_at on public.subscriptions;
create trigger set_subscriptions_updated_at
before update on public.subscriptions
for each row execute function public.set_updated_at();
