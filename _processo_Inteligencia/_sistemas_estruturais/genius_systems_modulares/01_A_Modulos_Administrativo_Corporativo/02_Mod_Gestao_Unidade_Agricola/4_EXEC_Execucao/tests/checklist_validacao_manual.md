# Checklist de Validação Manual - Mod_Gestao_Unidade_Agricola

Use este checklist antes de aplicar o pacote em Supabase real.

## Estrutura local

- [ ] A pasta `4_EXEC_Execucao` existe dentro do módulo.
- [ ] A migration principal existe em `supabase/migrations`.
- [ ] O seed existe em `supabase/seed`.
- [ ] As consultas de teste existem em `supabase/tests`.
- [ ] As Edge Functions existem em `supabase/functions`.
- [ ] O relatório automático foi gerado em `tests/RELATORIO_VALIDACAO_EXECUCAO.md`.

## Migration

- [ ] O schema `unidade_agricola` será criado.
- [ ] A tabela raiz `unidades_agricolas` será criada.
- [ ] O catálogo de eventos será criado.
- [ ] O log de eventos será criado.
- [ ] As tabelas dos 68 fractais serão criadas.
- [ ] Os nomes técnicos não começam por número.
- [ ] Os índices básicos foram gerados.

## Seed

- [ ] A unidade `PA-SEED-0001` será criada.
- [ ] O fractal de identidade será preenchido.
- [ ] Um evento de validação inicial será publicado.

## Edge Functions

- [ ] `unidade-agricola-api` possui rota para listar unidades.
- [ ] `unidade-agricola-api` possui rota para criar unidade.
- [ ] `unidade-agricola-api` possui rota para consultar eventos/fractais da unidade.
- [ ] `fractal-eventos` possui rota para publicar evento.
- [ ] Ambas usam o schema `unidade_agricola`.

## Segurança

- [ ] RLS ainda não deve ser ativado em produção sem revisar vínculos reais de usuário/unidade.
- [ ] `SUPABASE_SERVICE_ROLE_KEY` deve ser usada somente em ambiente seguro.
- [ ] Tokens e chaves não devem ser gravados nos arquivos do módulo.

## Próxima liberação

- [ ] Aplicar em Supabase local ou projeto de desenvolvimento.
- [ ] Executar migration.
- [ ] Executar seed.
- [ ] Executar SQL de testes.
- [ ] Testar Edge Functions.
- [ ] Conectar primeiro formulário ou planilha de cadastro.
