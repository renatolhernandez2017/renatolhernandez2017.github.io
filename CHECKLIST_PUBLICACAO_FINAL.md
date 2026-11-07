# Publicação final — portfólio

## Incluído no pacote
- Links dos cards de projetos publicados apontam para páginas SEO estáticas quando o slug é válido.
- Analytics 4 com eventos para WhatsApp, e-mail, currículo, projetos e formulário; **desativado até configurar ID**.
- Ajustes de acessibilidade, aviso de privacidade no formulário e scripts de análise nas páginas geradas.
- SQL opcional para limitar a 3 solicitações por e-mail/hora no Supabase.
- Workflow diário de geração SEO preservado.

## Ativação (duas ações manuais)
1. No Google Analytics 4 crie o fluxo Web e copie o ID `G-...`. Coloque em `js/analytics-config.js` na variável `window.PORTFOLIO_GA4_ID`. Até fazer isso, não há coleta. Verifique no relatório Tempo real e DebugView. Avalie aviso/política de privacidade e consentimento conforme o seu caso antes de ativar analytics.
2. No Supabase SQL Editor, **revise e execute** `supabase/antispam_rate_limit.sql` se quiser habilitar o limite por e-mail. Faça backup/valide em ambiente de testes antes; altera a função pública de contato. Não depende de mudanças no front-end.

## Testes após publicação
- Teste em celular: navegação, projeto, WhatsApp, e-mail, currículo, formulário (sem enviar dados fictícios repetidamente).
- Verifique se o contato aparece no painel admin. Sem acesso ao Supabase de produção, não foi possível confirmar.
- Rode https://pagespeed.web.dev/ para homepage e uma página de projeto (mobile e desktop). Otimize com base nas métricas reais.
- Confira Open Graph no LinkedIn Post Inspector e compartilhamento do WhatsApp (cache externo pode demorar).
- No GitHub Actions execute o workflow SEO após publicar e confirme que o sitemap contém todas as páginas publicadas.
- No Search Console acompanhe indexação; solicitação não garante indexação.

## Limitações transparentes
- CAPTCHA Cloudflare Turnstile **não foi ativado**: validação somente no navegador seria insegura. Exige função de servidor/Edge Function e segredo privado, além de criar chaves no Cloudflare.
- Limite por e-mail reduz abuso simples, mas pode ser contornado com outros e-mails; limite por IP precisa de backend/Edge Function.
- Testes reais de envio, Analytics, Core Web Vitals e preview em plataformas externas precisam ser feitos após publicar.
- Nenhum segredo de serviço foi incluído; chave publishable Supabase existente permanece pública como esperado.
