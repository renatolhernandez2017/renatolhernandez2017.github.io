-- Executar uma vez no SQL Editor do Supabase (projeto correto).
-- Limite de 3 envios por e-mail em 60 minutos, com trava transacional.
-- Proteção básica: NÃO substitui limite por IP nem CAPTCHA validado no servidor.
create table if not exists public.portfolio_contact_limits (
  email_hash text primary key, window_started_at timestamptz not null default now(), attempts integer not null default 0
);
revoke all on public.portfolio_contact_limits from public, anon, authenticated;
alter table public.portfolio_contact_limits enable row level security;

create or replace function public.submit_portfolio_contact(
 p_name text, p_email text, p_phone text, p_service text, p_message text, p_website text default ''
) returns void language plpgsql security definer set search_path = '' as $$
declare normalized_email text; attempts_now integer;
begin
 if coalesce(trim(p_website),'') <> '' then return; end if;
 if length(trim(coalesce(p_name,''))) not between 2 and 120
    or length(trim(coalesce(p_email,''))) not between 5 and 254
    or trim(coalesce(p_email,'')) !~* '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'
    or length(trim(coalesce(p_message,''))) not between 10 and 3000
    or length(coalesce(p_phone,'')) > 40 or length(coalesce(p_service,'')) > 100 then
   raise exception 'Dados inválidos';
 end if;
 normalized_email := lower(trim(p_email));
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtext(normalized_email)::bigint);
 insert into public.portfolio_contact_limits(email_hash, window_started_at, attempts)
 values (pg_catalog.md5(normalized_email), now(), 1)
 on conflict (email_hash) do update set
  attempts = case when public.portfolio_contact_limits.window_started_at < now() - interval '1 hour' then 1 else public.portfolio_contact_limits.attempts + 1 end,
  window_started_at = case when public.portfolio_contact_limits.window_started_at < now() - interval '1 hour' then now() else public.portfolio_contact_limits.window_started_at end
 returning attempts into attempts_now;
 if attempts_now > 3 then raise exception 'Limite de envios atingido. Tente novamente mais tarde.'; end if;
 insert into public.contacts(name,email,phone,service,message)
 values (trim(p_name),normalized_email,trim(coalesce(p_phone,'')),trim(coalesce(p_service,'')),trim(p_message));
end; $$;
revoke all on function public.submit_portfolio_contact(text,text,text,text,text,text) from public;
grant execute on function public.submit_portfolio_contact(text,text,text,text,text,text) to anon, authenticated;
-- Manutenção opcional: delete from public.portfolio_contact_limits where window_started_at < now() - interval '2 days';
