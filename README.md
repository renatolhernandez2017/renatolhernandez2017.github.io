# Portfólio + CRM — versão 2

## Publicação
1. Faça backup do repositório atual. Extraia o ZIP e envie o CONTEÚDO da pasta `portfolio_com_crm` para a raiz do GitHub Pages.
2. No Supabase, execute `supabase/schema.sql` (somente se o banco ainda não foi criado) e depois `supabase/upgrade_v2.sql`.
3. Em Authentication > Users, crie seu usuário. No SQL Editor, execute `insert into public.admin_users(user_id) values ('UUID_DO_USUARIO');`.
4. Em `js/config.js`, configure URL do projeto e chave **publishable/anon**. **NUNCA** coloque `service_role` ou chave secreta no frontend.
5. Acesse `/admin.html`, faça login, edite descrições e publique imagens e currículo. Os novos projetos são inseridos como **rascunho** com descrições provisórias. Revise e marque Publicado no painel.
6. Teste RLS, upload, exibição pública, links, formulário e login antes de divulgar.

## Recursos
- Projetos editáveis com capa, galeria, detalhes, tecnologias, URL opcional e página `projeto.html?id=UUID`.
- Upload de imagens JPG/PNG/WebP até 8 MB cada. Galeria é editável no painel. A primeira imagem vira capa automaticamente quando a capa estiver vazia.
- Currículo PDF atualizável via painel (bucket público, URL exibida no site).
- Contatos, clientes e orçamentos no painel anterior.

## Segurança e limitações
- Buckets são públicos: não armazene arquivos privados ou confidenciais. Remover imagens da galeria não exclui o arquivo antigo do Storage.
- Uploads exigem login de administrador e políticas de Storage. Formulário público precisa de CAPTCHA e limitação de requisições antes do uso intenso.
- Site depende do Supabase configurado; não é um backend Rails. Não foi possível validar contra sua conta Supabase.
- Atualização de currículo muda os links encontrados que apontam para o PDF original; confira os links na página após publicar.
- Não publique descrições provisórias sem revisar informações reais de cada projeto.
