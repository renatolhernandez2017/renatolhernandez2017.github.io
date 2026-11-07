# Ajustes realizados

- Currículo padrão atualizado para PDF 2026 (se `site_settings.resume_url` estiver definido, ele continua tendo prioridade).
- Adicionado gerador `scripts/build_projects.py` para criar páginas HTML indexáveis de projetos publicados, com títulos, descriptions, canonical, Open Graph, conteúdo real do Supabase e sitemap atualizado.
- Workflow GitHub Actions executa diariamente ou manualmente (Actions → Atualizar paginas SEO dos projetos → Run workflow).
- `projeto.html?id=...` permanece com noindex, preservando links antigos. Os novos links estáticos são incluídos na home pelo gerador.

## Para ativar

1. Publique os arquivos no repositório GitHub Pages (sem substituir as configurações atuais do Supabase).
2. No GitHub, vá em Actions → Atualizar paginas SEO dos projetos → Run workflow. O repositório precisa permitir que GitHub Actions grave commits (`Settings → Actions → General → Workflow permissions → Read and write permissions`).
3. Confirme que os projetos publicados têm `slug` preenchido no Supabase. O gerador ignora slugs ausentes ou inválidos.
4. Verifique se `projetos/<slug>.html` e `sitemap.xml` aparecem publicados. Depois envie novamente o sitemap ao Search Console.
5. Quando alterar projetos no painel, o workflow diário atualizará as páginas; também pode executá-lo manualmente.

## Pendências que exigem ambiente de produção

- O ZIP não inclui credenciais de administração do Supabase nem acesso ao deploy. Não foi possível executar o gerador contra o banco real aqui. Portanto, páginas individuais só serão criadas quando o workflow rodar com acesso à API pública.
- Testar políticas RLS, formulário e RPC `submit_portfolio_contact` em produção.
- Implementar CAPTCHA/Turnstile com validação no servidor e limitação de requisições: não é seguro adicionar apenas um widget visual sem validação real na função/RPC.
- Medir Core Web Vitals em navegador e conferir `site_settings.resume_url` (pode sobrescrever o PDF 2026).
- Google Analytics não foi inserido por falta do ID de medição e definição de consentimento.
