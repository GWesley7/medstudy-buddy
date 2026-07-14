-- MedStudy Buddy V2 - Fase 3
-- Creates the plan catalog and centralized feature entitlements.
-- Plans are mutable catalog rows; plan names are not business rules.

create table if not exists public.subscription_plans (
  code text primary key,
  display_name text not null,
  description text null,
  is_active boolean not null default false,
  is_public boolean not null default false,
  sort_order integer not null default 0,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint subscription_plans_code_check check (
    code ~ '^[a-z][a-z0-9_]{1,63}$'
  ),
  constraint subscription_plans_display_name_check check (
    length(btrim(display_name)) between 2 and 80
    and display_name !~ '[[:cntrl:]]'
  ),
  constraint subscription_plans_metadata_object_check check (
    jsonb_typeof(metadata) = 'object'
  )
);

comment on table public.subscription_plans is
  'Internal plan catalog. No prices, checkout, provider binding, or payment metadata are stored in Fase 3.';
comment on column public.subscription_plans.code is
  'Stable internal code such as essential, pro, or pro_ai.';

drop trigger if exists set_subscription_plans_updated_at on public.subscription_plans;
create trigger set_subscription_plans_updated_at
before update on public.subscription_plans
for each row execute function public.set_updated_at();

create table if not exists public.plan_entitlements (
  id uuid primary key default extensions.gen_random_uuid(),
  plan_code text not null references public.subscription_plans(code) on update cascade on delete cascade,
  feature_code text not null,
  enabled boolean not null default true,
  limit_value jsonb null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint plan_entitlements_feature_code_check check (
    feature_code ~ '^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$'
  ),
  constraint plan_entitlements_limit_value_check check (
    limit_value is null
    or jsonb_typeof(limit_value) in ('object', 'number', 'boolean', 'string')
  ),
  constraint plan_entitlements_unique_feature unique (plan_code, feature_code)
);

comment on table public.plan_entitlements is
  'Centralized capability catalog by plan. UI must not hardcode plan checks.';
comment on column public.plan_entitlements.limit_value is
  'Optional future limit payload. Prefer JSON object for named limits, for example {"max_active_exams": 3}.';

create index if not exists plan_entitlements_plan_code_idx
  on public.plan_entitlements (plan_code);

create index if not exists plan_entitlements_feature_code_idx
  on public.plan_entitlements (feature_code);

drop trigger if exists set_plan_entitlements_updated_at on public.plan_entitlements;
create trigger set_plan_entitlements_updated_at
before update on public.plan_entitlements
for each row execute function public.set_updated_at();
