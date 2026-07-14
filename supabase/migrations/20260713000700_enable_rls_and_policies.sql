-- MedStudy Buddy V2 - Fase 3
-- Enables Row-Level Security, explicit policies, and grants.
-- No permissive USING (true) policies are used for private data.

alter table public.profiles enable row level security;
alter table public.user_preferences enable row level security;
alter table public.subscription_plans enable row level security;
alter table public.plan_entitlements enable row level security;
alter table public.subscriptions enable row level security;

drop policy if exists profiles_select_own on public.profiles;
create policy profiles_select_own
on public.profiles
for select
to authenticated
using (id = auth.uid());

drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own
on public.profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

drop policy if exists user_preferences_select_own on public.user_preferences;
create policy user_preferences_select_own
on public.user_preferences
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists user_preferences_update_own on public.user_preferences;
create policy user_preferences_update_own
on public.user_preferences
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists subscription_plans_select_visible on public.subscription_plans;
create policy subscription_plans_select_visible
on public.subscription_plans
for select
to authenticated
using (is_active = true and is_public = true);

drop policy if exists plan_entitlements_select_visible_plans on public.plan_entitlements;
create policy plan_entitlements_select_visible_plans
on public.plan_entitlements
for select
to authenticated
using (
  exists (
    select 1
    from public.subscription_plans sp
    where sp.code = plan_entitlements.plan_code
      and sp.is_active = true
      and sp.is_public = true
  )
);

drop policy if exists subscriptions_select_own on public.subscriptions;
create policy subscriptions_select_own
on public.subscriptions
for select
to authenticated
using (user_id = auth.uid());

revoke all on table public.profiles from public, anon, authenticated;
revoke all on table public.user_preferences from public, anon, authenticated;
revoke all on table public.subscription_plans from public, anon, authenticated;
revoke all on table public.plan_entitlements from public, anon, authenticated;
revoke all on table public.subscriptions from public, anon, authenticated;

grant select on table public.profiles to authenticated;
grant update (full_name, username, avatar_path, onboarding_completed)
  on table public.profiles to authenticated;

grant select on table public.user_preferences to authenticated;
grant update (
  language_code,
  theme_mode,
  theme_preset,
  timezone,
  week_starts_on,
  date_format,
  time_format
) on table public.user_preferences to authenticated;

grant select on table public.subscription_plans to authenticated;
grant select on table public.plan_entitlements to authenticated;
grant select on table public.subscriptions to authenticated;

revoke all on function public.ensure_trial_started() from public, anon;
revoke all on function public.get_access_state() from public, anon;
revoke all on function public.has_active_access() from public, anon;
revoke all on function public.has_feature(text) from public, anon;

grant execute on function public.ensure_trial_started() to authenticated;
grant execute on function public.get_access_state() to authenticated;
grant execute on function public.has_active_access() to authenticated;
grant execute on function public.has_feature(text) to authenticated;

comment on policy profiles_select_own on public.profiles is
  'Authenticated users can read only their own private profile.';
comment on policy profiles_update_own on public.profiles is
  'Authenticated users can update allowed columns only on their own profile.';
comment on policy user_preferences_select_own on public.user_preferences is
  'Authenticated users can read only their own preferences.';
comment on policy user_preferences_update_own on public.user_preferences is
  'Authenticated users can update only their own preference row.';
comment on policy subscription_plans_select_visible on public.subscription_plans is
  'Authenticated users can read active public plans only; pro_ai remains hidden while inactive/private.';
comment on policy plan_entitlements_select_visible_plans on public.plan_entitlements is
  'Authenticated users can read entitlements only for visible plans.';
comment on policy subscriptions_select_own on public.subscriptions is
  'Authenticated users can read only their own subscription records and cannot write directly.';
