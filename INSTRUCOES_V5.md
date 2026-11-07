# Portfólio V5

1. Execute `supabase/corrigir_permissoes_v5.sql` no SQL Editor do Supabase.
2. Confira em Authentication > Users se o UUID da conta logada consta em `public.admin_users`.
3. Publique todos os arquivos do ZIP, mantendo `js/config.js` com sua URL e chave **pública**. Nunca coloque chave service_role no frontend.
4. Abra o site e o admin, teste projetos, currículo e upload da foto.
5. A foto é salva no bucket público `project-images`, já existente, e o endereço fica em `site_settings.photo_url`.
6. As políticas de upload existentes devem permitir somente `is_portfolio_admin()`.
7. A área de contato agora é clara, com contraste corrigido.

**Atenção:** não testado com credenciais reais do Supabase; valide antes de publicar em produção.
