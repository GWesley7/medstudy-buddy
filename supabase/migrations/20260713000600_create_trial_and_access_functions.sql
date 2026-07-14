-- MedStudy Buddy V2 - Fase 3
-- Creates authenticated RPCs for idempotent trial start and access checks.
-- These functions do not accept user_id, dates, status, or plan_code from the client.

create or replace function public.get_access_state()
returns table (
  subscription_id uuid,
  plan_code text,
  status public.app_subscription_status,
  access_status text,
  trial_started_at timestamptz,
  trial_ends_at timestamptz,
  current_period_ends_at timestamptz,
  has_active_access boolean
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_user_id uuid;
begin
  v_user_id = auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required.'
      using errcode = '28000';
  end if;

  return query
  with current_subscription as (
    select s.*
    from public.subscriptions s
    where s.user_id = v_user_id
    order by
      case
        when s.status = 'active' then 1
        when s.status = 'trialing' then 2
        when s.status in ('past_due', 'paused', 'incomplete') then 3
        else 4
      end,
      s.created_at desc
    limit 1
  )
  select
    cs.id,
    cs.plan_code,
    cs.status,
    case
      when cs.id is null then 'none'
      when cs.status = 'trialing' and cs.trial_ends_at > now() then 'trialing'
      when cs.status = 'trialing' and cs.trial_ends_at <= now() then 'trial_expired'
      when cs.status = 'active'
        and (cs.current_period_ends_at is null or cs.current_period_ends_at > now())
      then 'active'
      when cs.status = 'active' then 'active_expired'
      else cs.status::text
    end,
    cs.trial_started_at,
    cs.trial_ends_at,
    cs.current_period_ends_at,
    coalesce(
      (
        (cs.status = 'trialing' and cs.trial_ends_at > now())
        or (
          cs.status = 'active'
          and (cs.current_period_ends_at is null or cs.current_period_ends_at > now())
        )
      ),
      false
    )
  from (select 1) anchor
  left join current_subscription cs on true;
end;
$$;

comment on function public.get_access_state() is
  'Returns the authenticated user access state. Expired trials are treated as inactive even if status still says trialing.';

create or replace function public.has_active_access()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select coalesce((select gas.has_active_access from public.get_access_state() gas limit 1), false);
$$;

comment on function public.has_active_access() is
  'Returns true only for active trial or valid active subscription of the authenticated user.';

create or replace function public.has_feature(requested_feature_code text)
returns boolean
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_feature_code text;
  v_plan_code text;
  v_has_access boolean;
begin
  if auth.uid() is null then
    raise exception 'Authentication required.'
      using errcode = '28000';
  end if;

  v_feature_code = lower(btrim(coalesce(requested_feature_code, '')));

  if v_feature_code !~ '^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$' then
    return false;
  end if;

  select gas.plan_code, gas.has_active_access
  into v_plan_code, v_has_access
  from public.get_access_state() gas
  limit 1;

  if not coalesce(v_has_access, false) then
    return false;
  end if;

  return exists (
    select 1
    from public.plan_entitlements pe
    join public.subscription_plans sp on sp.code = pe.plan_code
    where pe.plan_code = v_plan_code
      and pe.feature_code = v_feature_code
      and pe.enabled = true
      and sp.is_active = true
  );
end;
$$;

comment on function public.has_feature(text) is
  'Checks if the authenticated user has an enabled entitlement through the current active access state.';

create or replace function public.ensure_trial_started()
returns table (
  subscription_id uuid,
  plan_code text,
  status public.app_subscription_status,
  trial_started_at timestamptz,
  trial_ends_at timestamptz,
  has_active_access boolean
)
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user_id uuid;
  v_now timestamptz;
  v_subscription public.subscriptions%rowtype;
begin
  v_user_id = auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required.'
      using errcode = '28000';
  end if;

  v_now = statement_timestamp();

  perform pg_advisory_xact_lock(hashtext(v_user_id::text));

  insert into public.profiles (id)
  values (v_user_id)
  on conflict (id) do nothing;

  insert into public.user_preferences (user_id)
  values (v_user_id)
  on conflict (user_id) do nothing;

  select s.*
  into v_subscription
  from public.subscriptions s
  where s.user_id = v_user_id
    and (
      s.trial_consumed_at is not null
      or s.trial_started_at is not null
      or s.status in ('trialing', 'active', 'expired')
    )
  order by s.created_at desc
  limit 1;

  if not found then
    insert into public.subscriptions (
      user_id,
      plan_code,
      status,
      trial_started_at,
      trial_ends_at,
      trial_consumed_at
    )
    values (
      v_user_id,
      'pro',
      'trialing',
      v_now,
      v_now + interval '3 days',
      v_now
    )
    returning * into v_subscription;
  end if;

  return query
  select
    v_subscription.id,
    v_subscription.plan_code,
    v_subscription.status,
    v_subscription.trial_started_at,
    v_subscription.trial_ends_at,
    (
      v_subscription.status = 'trialing'
      and v_subscription.trial_ends_at > now()
    )
    or (
      v_subscription.status = 'active'
      and (
        v_subscription.current_period_ends_at is null
        or v_subscription.current_period_ends_at > now()
      )
    );
end;
$$;

comment on function public.ensure_trial_started() is
  'Idempotently starts the one-time 3-day Pro trial for the authenticated user, using database time and an advisory lock.';
