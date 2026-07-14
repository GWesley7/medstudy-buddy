-- MedStudy Buddy V2 - Fase 3
-- Idempotent baseline catalog seed.
-- Kept as a migration because trial/access functions depend on the Pro plan existing.

insert into public.subscription_plans (
  code,
  display_name,
  description,
  is_active,
  is_public,
  sort_order,
  metadata
)
values
  (
    'essential',
    'Essential',
    'Baseline paid plan prepared for future commercial packaging.',
    true,
    true,
    10,
    '{"commercial": false}'::jsonb
  ),
  (
    'pro',
    'Pro',
    'Plan used by the initial three-day trial and future paid access.',
    true,
    true,
    20,
    '{"commercial": false, "trial_equivalent": true}'::jsonb
  ),
  (
    'pro_ai',
    'Pro AI',
    'Future AI plan. Inactive and hidden in the MVP.',
    false,
    false,
    30,
    '{"commercial": false, "future": true}'::jsonb
  )
on conflict (code) do update
set
  display_name = excluded.display_name,
  description = excluded.description,
  is_active = excluded.is_active,
  is_public = excluded.is_public,
  sort_order = excluded.sort_order,
  metadata = excluded.metadata;

with entitlement_seed(plan_code, feature_code, enabled, limit_value) as (
  values
    ('essential', 'schedule.daily', true, null::jsonb),
    ('essential', 'schedule.weekly', true, null::jsonb),
    ('essential', 'schedule.basic_rescheduling', true, null::jsonb),
    ('essential', 'flashcards.basic', true, null::jsonb),
    ('essential', 'analytics.basic', true, null::jsonb),
    ('essential', 'themes.presets', true, null::jsonb),
    ('pro', 'schedule.daily', true, null::jsonb),
    ('pro', 'schedule.weekly', true, null::jsonb),
    ('pro', 'schedule.basic_rescheduling', true, null::jsonb),
    ('pro', 'flashcards.basic', true, null::jsonb),
    ('pro', 'analytics.basic', true, null::jsonb),
    ('pro', 'themes.presets', true, null::jsonb),
    ('pro', 'schedule.monthly', true, null::jsonb),
    ('pro', 'schedule.timeline', true, null::jsonb),
    ('pro', 'schedule.advanced_rescheduling', true, null::jsonb),
    ('pro', 'flashcards.attachments', true, null::jsonb),
    ('pro', 'analytics.advanced', true, null::jsonb),
    ('pro', 'themes.custom', true, null::jsonb),
    ('pro', 'exports.enabled', true, null::jsonb)
)
insert into public.plan_entitlements (
  plan_code,
  feature_code,
  enabled,
  limit_value
)
select plan_code, feature_code, enabled, limit_value
from entitlement_seed
on conflict (plan_code, feature_code) do update
set
  enabled = excluded.enabled,
  limit_value = excluded.limit_value;
