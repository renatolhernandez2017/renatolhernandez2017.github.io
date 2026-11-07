-- Execute uma vez no SQL Editor. RLS permanece habilitado.
grant usage on schema public to anon, authenticated;
grant select on public.projects, public.site_settings to anon;
grant select, insert, update, delete on public.projects, public.contacts, public.clients, public.quotes, public.site_settings to authenticated;
-- Contatos públicos são recebidos exclusivamente pela função RPC existente.
-- Não conceder acesso anon diretamente a contacts, clients ou quotes.
select schemaname, tablename, rowsecurity from pg_tables where schemaname='public' and tablename in ('projects','contacts','clients','quotes','site_settings');
