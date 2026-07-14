-- MedStudy Buddy V2 - Fase 3
-- Creates user identity and preference tables.
-- No authentication screens or application features are implemented here.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text null,
  username extensions.citext null,
  avatar_path text null,
  onboarding_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_full_name_reasonable_check check (
    full_name is null
    or (
      length(btrim(full_name)) between 2 and 120
      and full_name !~ '[[:cntrl:]]'
    )
  ),
  constraint profiles_username_normalized_check check (
    username is null
    or username::text = lower(username::text)
  ),
  constraint profiles_username_format_check check (
    username is null
    or username::text ~ '^[a-z0-9_]{3,30}$'
  ),
  constraint profiles_avatar_path_check check (
    avatar_path is null
    or (
      length(btrim(avatar_path)) between 3 and 500
      and avatar_path !~ '^[a-z][a-z0-9+.-]*://'
      and avatar_path !~ '[[:cntrl:]]'
    )
  )
);

comment on table public.profiles is
  'Private user profile. Public social profile and user search are intentionally out of scope for Fase 3.';
comment on column public.profiles.id is
  'Matches auth.users.id and cascades when the auth user is deleted.';
comment on column public.profiles.username is
  'Optional until onboarding. When present, it must be 3-30 lowercase letters, digits, or underscore.';
comment on column public.profiles.avatar_path is
  'Storage path, not a required public URL.';

create unique index if not exists profiles_username_key
  on public.profiles (username)
  where username is not null;

create or replace function public.normalize_profile_fields()
returns trigger
language plpgsql
security invoker
set search_path = public, extensions, pg_temp
as $$
begin
  if new.full_name is not null then
    new.full_name = nullif(btrim(new.full_name), '');
  end if;

  if new.username is not null then
    new.username = public.normalize_username(new.username::text);
  end if;

  if new.avatar_path is not null then
    new.avatar_path = nullif(btrim(new.avatar_path), '');
  end if;

  return new;
end;
$$;

comment on function public.normalize_profile_fields() is
  'Normalizes mutable profile text before constraints are evaluated.';

drop trigger if exists normalize_profile_fields on public.profiles;
create trigger normalize_profile_fields
before insert or update on public.profiles
for each row execute function public.normalize_profile_fields();

drop trigger if exists set_profiles_updated_at on public.profiles;
create trigger set_profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create table if not exists public.user_preferences (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  language_code text not null default 'pt-BR',
  theme_mode text not null default 'system',
  theme_preset text not null default 'medstudy_default',
  timezone text not null default 'UTC',
  week_starts_on smallint not null default 1,
  date_format text null,
  time_format text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint user_preferences_language_code_check check (
    language_code in ('pt-BR', 'es', 'en')
  ),
  constraint user_preferences_theme_mode_check check (
    theme_mode in ('light', 'dark', 'system')
  ),
  constraint user_preferences_theme_preset_check check (
    theme_preset ~ '^[a-z][a-z0-9_]{1,63}$'
  ),
  constraint user_preferences_timezone_check check (
    length(btrim(timezone)) between 1 and 128
    and timezone !~ '[[:cntrl:]]'
    and timezone !~ '^\s'
    and timezone !~ '\s$'
  ),
  constraint user_preferences_week_starts_on_check check (
    week_starts_on between 0 and 6
  ),
  constraint user_preferences_date_format_check check (
    date_format is null or date_format in ('dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd')
  ),
  constraint user_preferences_time_format_check check (
    time_format is null or time_format in ('24h', '12h')
  )
);

comment on table public.user_preferences is
  'One synchronized preference row per user. Advanced custom palette editing is out of scope for Fase 3.';
comment on column public.user_preferences.week_starts_on is
  '0 = Sunday, 1 = Monday, ... 6 = Saturday.';
comment on column public.user_preferences.timezone is
  'Expected to store an IANA timezone identifier when possible.';

drop trigger if exists set_user_preferences_updated_at on public.user_preferences;
create trigger set_user_preferences_updated_at
before update on public.user_preferences
for each row execute function public.set_updated_at();
