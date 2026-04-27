# 4_EXEC_Execucao - Mod_Gestao_Unidade_Agricola

Esta pasta contém a primeira camada executável do módulo Gestão da Unidade Agrícola.

## Conteúdo

- `supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql`: migration principal com schema, tabelas dos fractais, catálogo e log de eventos.
- `supabase/seed/seed_unidade_agricola.sql`: seed mínimo para testar uma unidade agrícola e um fractal.
- `supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql`: consultas de validação pós-implantação.
- `supabase/functions/unidade-agricola-api/index.ts`: Edge Function inicial para unidades e eventos relacionados.
- `supabase/functions/fractal-eventos/index.ts`: Edge Function inicial para publicação de eventos.
- `GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola.md`: passo a passo de implantação.

## Estado atual

Este pacote ainda não foi aplicado em um projeto Supabase real. Ele está pronto para revisão, teste em ambiente de desenvolvimento e posterior implantação.
