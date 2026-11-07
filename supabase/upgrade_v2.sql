-- Execute DEPOIS de schema.sql, no SQL Editor do Supabase.
alter table public.projects add column if not exists slug text;
alter table public.projects add column if not exists details text not null default '';
alter table public.projects add column if not exists cover_image text not null default '';
alter table public.projects add column if not exists gallery jsonb not null default '[]'::jsonb;
create unique index if not exists projects_slug_unique on public.projects(slug) where slug is not null;
create table if not exists public.site_settings(id integer primary key check(id=1),resume_url text not null default '');
alter table public.site_settings enable row level security;
create policy "Public read settings" on public.site_settings for select to anon,authenticated using (true);
create policy "Admin insert settings" on public.site_settings for insert to authenticated with check(public.is_portfolio_admin());
create policy "Admin update settings" on public.site_settings for update to authenticated using(public.is_portfolio_admin()) with check(public.is_portfolio_admin());
insert into public.site_settings(id,resume_url) values(1,'') on conflict(id) do nothing;
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values
 ('project-images','project-images',true,8388608,array['image/jpeg','image/png','image/webp']),
 ('resumes','resumes',true,8388608,array['application/pdf'])
on conflict(id) do update set public=excluded.public,file_size_limit=excluded.file_size_limit,allowed_mime_types=excluded.allowed_mime_types;
create policy "Admin upload project images" on storage.objects for insert to authenticated with check(bucket_id='project-images' and public.is_portfolio_admin());
create policy "Admin upload resumes" on storage.objects for insert to authenticated with check(bucket_id='resumes' and public.is_portfolio_admin());
-- Nomes e resumos iniciais. Complete detalhes e imagens no painel. Evita duplicar pela correspondência de título.
insert into public.projects(title,description,technologies,url,published,sort_order) select v.title,v.description,v.technologies,v.url,false,v.ord from (values
('VendiFly','Marketplace multiloja com gestão de vendedores, pedidos, pagamentos e fretes.','Ruby on Rails,PostgreSQL,Integrações','https://vendifly.com.br/',1),
('Unipharmus','Projeto Unipharmus — descrição detalhada a cadastrar.','', '',2),
('OmniTax','Projeto OmniTax — descrição detalhada a cadastrar.','', '',3),
('Date Reserve (NossoSim)','Projeto de reservas Date Reserve, também chamado NossoSim — detalhes a cadastrar.','', '',4),
('Costura','Sistema Costura — detalhes e funcionalidades a cadastrar.','', '',5),
('Extrator de PDF','Ferramenta de extração de informações de arquivos PDF — detalhes a cadastrar.','', '',6),
('Site Matéria','Projeto Site Matéria — detalhes a cadastrar.','', '',7)
) as v(title,description,technologies,url,ord) where not exists(select 1 from public.projects p where lower(p.title)=lower(v.title));
-- Revisar os textos genéricos antes de divulgar. Remover Bora Nessa se existir:
delete from public.projects where lower(title)='bora nessa';
