-- Execute no SQL Editor do Supabase. Revise antes de aplicar em projetos existentes.
create extension if not exists pgcrypto;
create table if not exists public.admin_users (user_id uuid primary key references auth.users(id) on delete cascade);
create or replace function public.is_portfolio_admin() returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.admin_users where user_id = (select auth.uid()));
$$;
revoke all on function public.is_portfolio_admin() from public;
grant execute on function public.is_portfolio_admin() to authenticated;

create table if not exists public.projects (
 id uuid primary key default gen_random_uuid(), title text not null check(length(title) between 2 and 150),
 description text not null default '', technologies text not null default '', url text not null default '',
 published boolean not null default false, sort_order integer not null default 0,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.contacts (
 id uuid primary key default gen_random_uuid(), name text not null check(length(name) between 2 and 120),
 email text not null check(length(email) between 5 and 254), phone text not null default '',
 service text not null default '', message text not null check(length(message) between 10 and 3000),
 status text not null default 'novo' check(status in ('novo','em_contato','qualificado','encerrado')),
 created_at timestamptz not null default now()
);
create table if not exists public.clients (
 id uuid primary key default gen_random_uuid(), name text not null check(length(name) between 2 and 150),
 email text not null default '', phone text not null default '', company text not null default '',
 notes text not null default '', created_at timestamptz not null default now()
);
create table if not exists public.quotes (
 id uuid primary key default gen_random_uuid(), client_id uuid references public.clients(id) on delete set null,
 title text not null check(length(title) between 2 and 150), description text not null default '',
 amount numeric(12,2) not null default 0 check(amount >= 0),
 status text not null default 'rascunho' check(status in ('rascunho','enviado','aprovado','recusado')),
 created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
alter table public.projects enable row level security;
alter table public.contacts enable row level security;
alter table public.clients enable row level security;
alter table public.quotes enable row level security;

create policy "Admin read projects" on public.projects for select to authenticated using (public.is_portfolio_admin());
create policy "Public read published projects" on public.projects for select to anon using (published = true);
create policy "Admin insert projects" on public.projects for insert to authenticated with check (public.is_portfolio_admin());
create policy "Admin update projects" on public.projects for update to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "Admin delete projects" on public.projects for delete to authenticated using (public.is_portfolio_admin());

create policy "Admin read contacts" on public.contacts for select to authenticated using (public.is_portfolio_admin());
create policy "Admin insert contacts" on public.contacts for insert to authenticated with check (public.is_portfolio_admin());
create policy "Admin update contacts" on public.contacts for update to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "Admin delete contacts" on public.contacts for delete to authenticated using (public.is_portfolio_admin());

create policy "Admin manage clients" on public.clients for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());
create policy "Admin manage quotes" on public.quotes for all to authenticated using (public.is_portfolio_admin()) with check (public.is_portfolio_admin());

-- Entrada pública exclusivamente por RPC: valida e não permite escolher status.
create or replace function public.submit_portfolio_contact(p_name text, p_email text, p_phone text, p_service text, p_message text, p_website text default '')
returns void language plpgsql security definer set search_path = '' as $$
begin
  if coalesce(trim(p_website),'') <> '' then return; end if; -- honeypot
  if length(trim(coalesce(p_name,''))) not between 2 and 120 or
     length(trim(coalesce(p_email,''))) not between 5 and 254 or
     trim(coalesce(p_email,'')) !~* '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$' or
     length(trim(coalesce(p_message,''))) not between 10 and 3000 or
     length(coalesce(p_phone,'')) > 40 or length(coalesce(p_service,'')) > 100 then
    raise exception 'Dados inválidos';
  end if;
  insert into public.contacts(name,email,phone,service,message)
  values (trim(p_name),lower(trim(p_email)),trim(coalesce(p_phone,'')),trim(coalesce(p_service,'')),trim(p_message));
end; $$;
revoke all on function public.submit_portfolio_contact(text,text,text,text,text,text) from public;
grant execute on function public.submit_portfolio_contact(text,text,text,text,text,text) to anon, authenticated;
-- IMPORTANTE: Para produção, adicionar CAPTCHA/Turnstile e rate limiting em Edge Function.
-- Crie usuário em Authentication > Users e habilite admin manualmente:
-- insert into public.admin_users(user_id) values ('UUID-DO-USUARIO-AUTH');
