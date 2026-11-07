# Workspace administrativo — visual clean

Esta versão usa o mesmo Supabase e as mesmas tabelas existentes. Não exige migração SQL adicional.

## Como testar

1. Na pasta raiz, execute `python3 -m http.server 8000`.
2. Abra `http://localhost:8000/admin.html` e faça login.
3. Teste a navegação lateral, os indicadores, a listagem e edição de projetos, o botão Publicar/Despublicar, imagens e currículo.
4. Verifique `index.html` e `projeto.html` para confirmar que somente os projetos publicados aparecem.

## Observações

- O painel usa `public.is_portfolio_admin()` e depende das permissões/RLS já configuradas no Supabase.
- Os indicadores são contagens do banco e podem exibir traço quando não houver permissão.
- A remoção de imagens da galeria desvincula a URL do projeto; não exclui o objeto do Storage.
- Uploads de imagens são feitos antes do salvamento do registro. Se cancelar, o arquivo pode permanecer no Storage.
- O currículo é público; não envie dados que não queira divulgar.
- Não publique segredos, senhas ou chaves `service_role`/`sb_secret_` no GitHub Pages.
