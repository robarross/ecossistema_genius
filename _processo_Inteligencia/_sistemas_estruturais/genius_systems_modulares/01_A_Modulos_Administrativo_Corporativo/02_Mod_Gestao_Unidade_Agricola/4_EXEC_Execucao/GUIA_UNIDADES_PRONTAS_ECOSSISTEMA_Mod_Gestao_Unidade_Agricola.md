# Guia de Unidades Prontas para o Ecossistema - Mod_Gestao_Unidade_Agricola

## Objetivo

Definir quais unidades agrícolas estão liberadas para consumo por outros módulos do Ecossistema Genius.

## Migration

```text
supabase/migrations/202604260012_views_unidades_prontas_ecossistema.sql
```

## Views criadas

- `vw_unidades_agricolas_prontas_ecossistema`
- `vw_unidades_bloqueadas_ecossistema`
- `vw_matriz_consumo_modulos_unidade_agricola`
- `vw_resumo_liberacao_ecossistema`

## Critérios de liberação

A unidade fica pronta quando:

- status cadastral é `Ativo`;
- sync status é `validado`;
- possui pelo menos 1 proprietário/possuidor;
- possui pelo menos 1 responsável/gestor;
- possui pelo menos 1 área produtiva;
- não possui eventos com erro;
- não possui cadastro incompleto;
- não possui área inconsistente.

## Módulos consumidores liberados

- Produção Vegetal
- Produção Animal/Pecuária
- Georreferenciamento
- Regularização Fundiária
- Financeiro
- Fiscal/Tributário
- Marketplace Agrícola
- Dashboards BI
- DataLake
- Genius Hub

## Validação

Executar:

```text
supabase/tests/TESTES_UNIDADES_PRONTAS_ECOSSISTEMA_Mod_Gestao_Unidade_Agricola.sql
```

## Resultado esperado no estado atual

Com a auditoria saudável, espera-se:

- 4 unidades prontas;
- 0 unidades bloqueadas;
- status de liberação `saudavel`;
- cada unidade liberada para 10 módulos consumidores.
