# SEO do portfólio — V6

## O que foi alterado
- Título e descrição da página inicial com foco em desenvolvimento Ruby on Rails e sistemas web sob medida.
- Metadados Open Graph e Twitter para compartilhamento.
- Favicon SVG.
- Sitemap com a página inicial, única página com conteúdo estático e indexável com segurança.
- Página dinâmica `projeto.html?id=...` marcada `noindex,follow` temporariamente. Cada projeto é carregado pelo JavaScript a partir do Supabase; não é recomendável indexar páginas sem conteúdo inicial único.
- `admin.html` já tinha `noindex,nofollow`; robots agora também desautoriza rastreamento do caminho administrativo. Isto NÃO é mecanismo de segurança.

## Para publicar
1. Faça backup e substitua os arquivos do repositório GitHub Pages pelos desta versão.
2. Confira se a URL canônica `https://renatolhernandez2017.github.io/` corresponde à URL pública definitiva. Se usar domínio próprio, altere canonical, og:url, sitemap e robots.
3. No Google Search Console, adicione a propriedade do site e envie `https://renatolhernandez2017.github.io/sitemap.xml`.
4. Inspecione a URL inicial e solicite indexação. A indexação não é garantida e pode levar tempo.
5. Confira o resultado em celular, imagens, links, acessibilidade e velocidade (PageSpeed Insights).

## Próxima etapa importante
Para ranquear cada case de projeto, gerar uma página HTML estática/pré-renderizada por projeto publicado (título, resumo, tecnologias, imagens, descrição única, canonical, JSON-LD apropriado), e então adicioná-la ao sitemap. Não publique rascunhos. GitHub Pages não executa servidor para renderização dinâmica; um build no GitHub Actions ou gerador estático pode fazer isso.

## Observações
- Este pacote não altera o banco de dados, políticas RLS nem credenciais.
- Não foi feita auditoria de produção no Google Search Console ou medição real de Core Web Vitals.
- `robots.txt` não substitui autenticação nem bloqueia indexação de URLs já conhecidas; o `noindex` no HTML é a instrução principal.
