-- MedStudy Buddy V2 - Fase 3 database tests.
-- Intended for Supabase local test execution with pgTAP.
-- Do not run against the remote project.

begin;

create extension if not exists pgtap with schema extensions;
set search_path = public, extensions, auth, pg_temp;

select plan(21);

insert into auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_user_meta_data,
  created_at,
  updated_at
)
values
  (
    '00000000-0000-4000-8000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'phase3-user-a@example.test',
    extensions.crypt('password-a', extensions.gen_salt('bf')),
    now(),
    '{"full_name": "User A", "username": "User_A", "language_code": "pt-BR"}'::jsonb,
    now(),
    now()
  ),
  (
    '00000000-0000-4000-8000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'phase3-user-b@example.test',
    extensions.crypt('password-b', extensions.gen_salt('bf')),
    now(),
    '{"full_name": "User B", "username": "user_b", "language_code": "en"}'::jsonb,
    now(),
    now()
  );

select ok(
  exists (
    select 1
    from public.profiles
    where id = '00000000-0000-4000-8000-000000000001'
  ),
  'automatic profile is created after auth user insert'
);

select ok(
  exists (
    select 1
    from public.user_preferences
    where user_id = '00000000-0000-4000-8000-000000000001'
      and language_code = 'pt-BR'
  ),
  'automatic user_preferences is created after auth user insert'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000001', true);

select is(
  (select count(*)::integer from public.profiles where id = '00000000-0000-4000-8000-000000000002'),
  0,
  'user A cannot read user B private profile'
);

update public.user_preferences
set language_code = 'es'
where user_id = '00000000-0000-4000-8000-000000000002';

reset role;

select is(
  (select language_code from public.user_preferences where user_id = '00000000-0000-4000-8000-000000000002'),
  'en',
  'user A cannot update user B preferences'
);

set local role authenticated;
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000001', true);

select throws_ok(
  $$
    insert into public.subscriptions (user_id, plan_code, status)
    values ('00000000-0000-4000-8000-000000000001', 'pro', 'active')
  $$,
  'authenticated user cannot insert subscription directly'
);

select throws_ok(
  $$
    update public.subscriptions
    set status = 'active'
    where user_id = '00000000-0000-4000-8000-000000000001'
  $$,
  'authenticated user cannot update subscription directly'
);

reset role;
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000001', true);
select * into temporary table first_trial from public.ensure_trial_started();
select * into temporary table second_trial from public.ensure_trial_started();

select is(
  (select count(*)::integer from public.subscriptions where user_id = '00000000-0000-4000-8000-000000000001'),
  1,
  'ensure_trial_started creates exactly one trial subscription'
);

select is(
  (select trial_started_at from first_trial),
  (select trial_started_at from second_trial),
  'second ensure_trial_started call does not change trial start'
);

select is(
  (select count(*)::integer from public.subscriptions where user_id = '00000000-0000-4000-8000-000000000001' and status = 'trialing'),
  1,
  'repeated calls do not create two valid trials'
);

select is(
  (select trial_ends_at from first_trial),
  (select trial_started_at + interval '3 days' from first_trial),
  'trial ends exactly three days after database start timestamp'
);

select ok(
  (select trial_started_at <= now() and trial_started_at > now() - interval '1 minute' from first_trial),
  'trial start uses database clock'
);

select is(
  (select plan_code from first_trial),
  'pro',
  'trial grants the pro plan'
);

select isnt(
  (select plan_code from first_trial),
  'essential',
  'user does not choose the trial plan'
);

update public.subscriptions
set trial_started_at = now() - interval '4 days',
    trial_ends_at = now() - interval '1 day'
where user_id = '00000000-0000-4000-8000-000000000001';

select is(
  public.has_active_access(),
  false,
  'has_active_access returns false after trial_ends_at'
);

update public.subscriptions
set trial_started_at = now(),
    trial_ends_at = now() + interval '3 days'
where user_id = '00000000-0000-4000-8000-000000000001';

select is(
  public.has_feature('schedule.monthly'),
  true,
  'has_feature respects the active pro trial plan'
);

select is(
  (
    select count(*)::integer
    from public.plan_entitlements essential
    where essential.plan_code = 'essential'
      and not exists (
        select 1
        from public.plan_entitlements pro
        where pro.plan_code = 'pro'
          and pro.feature_code = essential.feature_code
          and pro.enabled = essential.enabled
      )
  ),
  0,
  'pro has every enabled essential entitlement'
);

select is(
  (select is_active from public.subscription_plans where code = 'pro_ai'),
  false,
  'pro_ai is inactive'
);

select throws_ok(
  $$
    insert into public.subscriptions (
      user_id,
      plan_code,
      status,
      trial_started_at,
      trial_ends_at
    )
    values (
      '00000000-0000-4000-8000-000000000002',
      'pro',
      'trialing',
      now(),
      now() - interval '1 day'
    )
  $$,
  'invalid subscription trial date range is rejected'
);

select throws_ok(
  $$
    update public.profiles
    set username = 'user_b'
    where id = '00000000-0000-4000-8000-000000000001'
  $$,
  'duplicate username is rejected case-insensitively'
);

set local role anon;
select set_config('request.jwt.claim.sub', '', true);

select throws_ok(
  $$ select count(*) from public.profiles $$,
  'anonymous users cannot access private profile data'
);

reset role;

select * from finish();

rollback;
