-- MedStudy Buddy V2 - Fase 3
-- Foundation extensions, stable types, and reusable database helpers.
-- This migration is deterministic and safe for a new Supabase project.

create extension if not exists pgcrypto with schema extensions;
comment on extension pgcrypto is
  'Provides gen_random_uuid() for UUID primary keys in MedStudy Buddy V2.';

create extension if not exists citext with schema extensions;
comment on extension citext is
  'Provides case-insensitive usernames without relying only on frontend validation.';

do $$
begin
  if not exists (
    select 1
    from pg_type t
    join pg_namespace n on n.oid = t.typnamespace
    where t.typname = 'app_subscription_status'
      and n.nspname = 'public'
  ) then
    create type public.app_subscription_status as enum (
      'trialing',
      'active',
      'past_due',
      'canceled',
      'expired',
      'paused',
      'incomplete'
    );
  end if;
end
$$;

comment on type public.app_subscription_status is
  'Stable subscription lifecycle statuses. Plans are catalog rows, not an enum.';

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

comment on function public.set_updated_at() is
  'Reusable trigger function that maintains updated_at timestamps.';

create or replace function public.normalize_username(value text)
returns extensions.citext
language sql
immutable
strict
set search_path = public, extensions, pg_temp
as $$
  select lower(btrim(value))::extensions.citext;
$$;

comment on function public.normalize_username(text) is
  'Normalizes usernames to lowercase trimmed citext before validation and storage.';
