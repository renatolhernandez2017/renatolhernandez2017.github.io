-- Executar no SQL Editor como administrador do projeto.
-- Privilégios SQL (RLS continua restringindo operações ao administrador).
grant usage on schema public to anon, authenticated;
grant select on public.projects, public.site_settings to anon;
grant select, insert, update, delete on public.projects, public.contacts, public.clients, public.quotes, public.site_settings to authenticated;
-- Foto profissional editável pelo painel.
alter table public.site_settings add column if not exists photo_url text not null default '';
-- Garantir RLS habilitado.
alter table public.projects enable row level security;
alter table public.site_settings enable row level security;
-- Diagnóstico: verificar se usuário logado consta em admin_users pelo UUID em Authentication > Users.
select (select count(*) from public.admin_users) as total_administradores;
