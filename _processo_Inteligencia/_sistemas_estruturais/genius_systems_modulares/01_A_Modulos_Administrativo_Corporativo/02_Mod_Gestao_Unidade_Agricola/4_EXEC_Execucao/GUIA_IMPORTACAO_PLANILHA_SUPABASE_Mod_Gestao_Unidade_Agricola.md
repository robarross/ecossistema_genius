# Guia Planilha -> Supabase - Mod_Gestao_Unidade_Agricola

## Objetivo

Permitir importar cadastros de unidades agrícolas a partir de planilha/CSV para o Supabase de forma controlada.

## Arquivos

- Migration: `supabase/migrations/202604260004_import_planilha_unidade_agricola.sql`
- CSV modelo: `imports/modelo_importacao_unidades_agricolas.csv`
- Testes: `supabase/tests/TESTES_IMPORT_PLANILHA_Mod_Gestao_Unidade_Agricola.sql`

## Fluxo

```text
Planilha/CSV
  -> import_planilha_unidades_agricolas
  -> processar_importacao_planilha_unidades_agricolas()
  -> unidades_agricolas
  -> fractal_identidade_unidade
  -> fractal_eventos_log
  -> views/dashboards
```

## Passo 1 - Aplicar migration

No Supabase SQL Editor, executar:

```text
202604260004_import_planilha_unidade_agricola.sql
```

## Passo 2 - Importar CSV

No Supabase:

1. Vá em `Table Editor`.
2. Abra o schema `unidade_agricola`.
3. Abra a tabela `import_planilha_unidades_agricolas`.
4. Use a opção de importação CSV.
5. Importe o arquivo:

```text
imports/modelo_importacao_unidades_agricolas.csv
```

## Passo 3 - Processar importação

No SQL Editor, rode:

```sql
select *
from unidade_agricola.processar_importacao_planilha_unidades_agricolas('lote_teste_001');
```

## Passo 4 - Validar

Rode:

```text
TESTES_IMPORT_PLANILHA_Mod_Gestao_Unidade_Agricola.sql
```

## Resultado esperado com o CSV modelo

- 1 linha staging importada.
- 1 unidade `PA-IMP-0001` criada.
- 1 registro no fractal de identidade.
- 1 evento de origem `planilha`.
- Dashboards passam a mostrar 2 unidades, considerando também a unidade seed `PA-SEED-0001`.
