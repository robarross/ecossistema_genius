# Guia de Views Relacionais - Mod_Gestao_Unidade_Agricola

## Objetivo

Criar consultas consolidadas por unidade agrícola, conectando unidade, proprietários, responsáveis, áreas e eventos.

## Migration

```text
supabase/migrations/202604260008_views_relacionais_unidade_agricola.sql
```

## Views criadas

- `vw_unidade_proprietarios`
- `vw_unidade_responsaveis`
- `vw_unidade_areas_produtivas`
- `vw_unidade_eventos_timeline`
- `vw_unidade_relacional_resumo`

## Como aplicar

No Supabase SQL Editor, executar a migration `202604260008`.

## Como testar

Executar:

```text
supabase/tests/TESTES_VIEWS_RELACIONAIS_Mod_Gestao_Unidade_Agricola.sql
```

## Resultado esperado com os dados atuais

- Proprietários importados: 2.
- Responsáveis importados: 2.
- Áreas importadas: 2.
- Eventos totais na timeline: 11.
- Unidades `PA-IMP-0002` e `PA-IMP-0003` com 1 proprietário, 1 responsável, 1 área e eventos validados.
