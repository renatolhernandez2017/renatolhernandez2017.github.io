# Privacidade e LGPD — implantação

- `privacidade.html`: política de privacidade detalhada; revisar com profissional jurídico conforme operação real.
- `js/privacy.js` e `css/privacy.css`: banner de escolha, recusa por padrão, preferência armazenada localmente, link para reabrir escolhas.
- Google Analytics 4 só carrega após aceitar. A revogação bloqueia novos envios na página atual; para remover cookies antigos, o visitante pode limpar dados do navegador.
- A política menciona Supabase, GitHub Pages e Google Analytics. Confirme contratos, subprocessadores, transferências internacionais, prazos de retenção, medidas de segurança e atendimento a direitos.
- A aceitação da leitura da política no formulário não substitui nem obriga consentimento para analytics.
- Verifique o Google Analytics em tempo real após aceitar. Em aba anônima, recuse e confira na aba Network que `googletagmanager.com/gtag/js` não é solicitado.
- A rotina `scripts/build_projects.py` passa a incluir a política no sitemap e a usar o controle nas novas páginas de projetos.
- O pacote NÃO contém `.git` nem arquivos internos do repositório. Mantenha a pasta `.github/workflows` para preservar automação SEO.
- **Limites**: isto é uma implementação técnica e um texto informativo, não certificação de conformidade integral à LGPD. Requer procedimentos organizacionais e avaliação jurídica.
