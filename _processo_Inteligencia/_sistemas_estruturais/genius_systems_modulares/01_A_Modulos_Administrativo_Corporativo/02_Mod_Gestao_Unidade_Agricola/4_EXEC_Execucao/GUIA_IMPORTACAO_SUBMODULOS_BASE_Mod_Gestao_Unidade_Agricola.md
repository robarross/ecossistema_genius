# Guia de Importação dos Submódulos Base - Mod_Gestao_Unidade_Agricola

## Objetivo

Importar dados complementares da unidade agrícola para os submódulos:

- proprietários/possuidores;
- responsáveis/gestores;
- territórios/áreas de produção.

## Migration

```text
supabase/migrations/202604260006_import_submodulos_base_unidade_agricola.sql
```

## CSVs modelo

- `imports/modelo_importacao_proprietarios_possuidores.csv`
- `imports/modelo_importacao_responsaveis_gestores.csv`
- `imports/modelo_importacao_territorios_areas.csv`

## Ordem de uso

1. Aplicar a migration `202604260006`.
2. Importar cada CSV na tabela staging correspondente.
3. Processar os lotes:

```sql
select * from unidade_agricola.processar_importacao_proprietarios_possuidores('lote_submodulos_base_001');
select * from unidade_agricola.processar_importacao_responsaveis_gestores('lote_submodulos_base_001');
select * from unidade_agricola.processar_importacao_territorios_areas('lote_submodulos_base_001');
```

## Validação

Rodar:

```text
supabase/tests/TESTES_IMPORT_SUBMODULOS_BASE_Mod_Gestao_Unidade_Agricola.sql
```

## Resultado esperado

- 2 proprietários/possuidores importados.
- 2 responsáveis/gestores importados.
- 2 áreas/territórios importados.
- 6 eventos novos publicados.
- Dashboard executivo segue saudável.
