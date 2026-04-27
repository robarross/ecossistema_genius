# RELATORIO_VALIDACAO_EXECUCAO

## Módulo
Mod_Gestao_Unidade_Agricola

## Data
2026-04-26T12:32:08.261Z

## Resumo

- Checks executados: 27
- Sucessos: 27
- Falhas: 0
- Status geral: APROVADO

## Resultados

| item | status | detalhe |
| --- | --- | --- |
| arquivo_execucao:README.md | OK | encontrado |
| arquivo_execucao:GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola.md | OK | encontrado |
| arquivo_execucao:supabase/config.toml | OK | encontrado |
| arquivo_execucao:supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql | OK | encontrado |
| arquivo_execucao:supabase/seed/seed_unidade_agricola.sql | OK | encontrado |
| arquivo_execucao:supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql | OK | encontrado |
| arquivo_execucao:supabase/functions/unidade-agricola-api/index.ts | OK | encontrado |
| arquivo_execucao:supabase/functions/fractal-eventos/index.ts | OK | encontrado |
| arquivo_modulo:SUPABASE_SCHEMA_Mod_Gestao_Unidade_Agricola.sql | OK | encontrado |
| arquivo_modulo:OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | OK | encontrado |
| arquivo_modulo:CATALOGO_EVENTOS_FRACTAIS_Mod_Gestao_Unidade_Agricola.md | OK | encontrado |
| arquivo_modulo:CATALOGO_SCHEMAS_FRACTAIS_Mod_Gestao_Unidade_Agricola.md | OK | encontrado |
| arquivo_modulo:DASHBOARDS_Mod_Gestao_Unidade_Agricola.md | OK | encontrado |
| arquivo_modulo:AGENTES_Mod_Gestao_Unidade_Agricola.md | OK | encontrado |
| arquivo_modulo:AUTOMACOES_Mod_Gestao_Unidade_Agricola.md | OK | encontrado |
| arquivo_modulo:PLAYBOOK_OPERACIONAL_Mod_Gestao_Unidade_Agricola.md | OK | encontrado |
| migration:tabelas_totais | OK | 71 |
| migration:tabelas_fractais | OK | 68 |
| migration:eventos_criado | OK | 68 |
| migration:eventos_totais | OK | 272 |
| migration:tabelas_iniciando_numero | OK | 0 |
| migration:eventos_com_prefixo_numerico | OK | 0 |
| seed:unidade_piloto | OK | PA-SEED-0001 |
| seed:evento_identidade_validado | OK | encontrado |
| edge_function:unidade_api_serve | OK | unidade-agricola-api |
| edge_function:eventos_serve | OK | fractal-eventos |
| edge_function:schema_unidade_agricola | OK | schema usado nas duas funcoes |

## Próxima ação recomendada

Pacote local aprovado para teste em Supabase local ou ambiente de desenvolvimento.
