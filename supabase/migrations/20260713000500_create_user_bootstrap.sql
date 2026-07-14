-- MedStudy Buddy V2 - Fase 3
-- Creates idempotent profile and preferences bootstrap after auth.users insert.
-- Trial is intentionally not started here.

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public, extensions, pg_temp
as $$
declare
  requested_full_name text;
  requested_username text;
  safe_username extensions.citext;
  requested_language text;
begin
  requested_full_name = nullif(btrim(coalesce(new.raw_user_meta_data ->> 'full_name', '')), '');
  requested_username = nullif(btrim(coalesce(new.raw_user_meta_data ->> 'username', '')), '');
  requested_language = coalesce(new.raw_user_meta_data ->> 'language_code', 'pt-BR');

  if requested_full_name is not null
    and (
      length(requested_full_name) < 2
      or length(requested_full_name) > 120
      or requested_full_name ~ '[[:cntrl:]]'
    )
  then
    requested_full_name = null;
  end if;

  if requested_username is not null then
    requested_username = public.normalize_username(requested_username)::text;

    if requested_username ~ '^[a-z0-9_]{3,30}$'
      and not exists (
        select 1
        from public.profiles p
        where p.username = requested_username::extensions.citext
      )
    then
      safe_username = requested_username::extensions.citext;
    else
      safe_username = null;
    end if;
  end if;

  if requested_language not in ('pt-BR', 'es', 'en') then
    requested_language = 'pt-BR';
  end if;

  insert into public.profiles (id, full_name, username)
  values (new.id, requested_full_name, safe_username)
  on conflict (id) do nothing;

  insert into public.user_preferences (user_id, language_code)
  values (new.id, requested_language)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

comment on function public.handle_new_auth_user() is
  'Creates profile and preferences after signup. Invalid or duplicated metadata username falls back to NULL for onboarding.';

drop trigger if exists on_auth_user_created_create_foundation_records on auth.users;
create trigger on_auth_user_created_create_foundation_records
after insert on auth.users
for each row execute function public.handle_new_auth_user();
