# Guia de Importação Robusta - Mod_Gestao_Unidade_Agricola

## Objetivo

Melhorar o fluxo Planilha -> Supabase com pré-validação, diagnóstico de erros, reset de lote e limpeza segura da tabela staging.

## Arquivos

- Migration: `supabase/migrations/202604260005_import_planilha_validacoes_unidade_agricola.sql`
- CSV completo: `imports/modelo_importacao_unidades_agricolas_completo.csv`
- Testes: `supabase/tests/TESTES_IMPORT_PLANILHA_VALIDACOES_Mod_Gestao_Unidade_Agricola.sql`

## Novos recursos

- `vw_importacao_planilha_unidades_prevalidacao`
- `vw_importacao_planilha_unidades_erros`
- `prevalidar_lote_importacao_planilha_unidades(lote)`
- `resetar_lote_importacao_planilha_unidades(lote)`
- `limpar_lote_importacao_planilha_unidades(lote)`

## Ordem recomendada

1. Aplicar a migration `202604260005`.
2. Importar o CSV completo na tabela `import_planilha_unidades_agricolas`.
3. Rodar pré-validação:

```sql
select *
from unidade_agricola.prevalidar_lote_importacao_planilha_unidades('lote_planilha_robusta_001');
```

4. Se `total_com_erro = 0`, processar:

```sql
select *
from unidade_agricola.processar_importacao_planilha_unidades_agricolas('lote_planilha_robusta_001');
```

5. Validar dashboards:

```sql
select *
from unidade_agricola.vw_dashboard_executivo_unidade_agricola;
```

## Reprocessar um lote

```sql
select *
from unidade_agricola.resetar_lote_importacao_planilha_unidades('lote_planilha_robusta_001');

select *
from unidade_agricola.processar_importacao_planilha_unidades_agricolas('lote_planilha_robusta_001');
```

## Limpar staging de um lote

Remove apenas as linhas da tabela staging. Não apaga unidades oficiais.

```sql
select *
from unidade_agricola.limpar_lote_importacao_planilha_unidades('lote_planilha_robusta_001');
```
