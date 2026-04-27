# Guia - View Consolidada do Modulo Gestão da Unidade Agricola

Este guia acompanha a migration `202604260024_view_consolidada_modulo_completo.sql`.

## Objetivo

Criar uma visão única do `Mod_Gestao_Unidade_Agricola`, consolidando os 10 submódulos executáveis em uma linha por unidade agrícola.

## View criada

`unidade_agricola.vw_modulo_unidade_agricola_consolidado`

## O que ela mostra

- total de submódulos previstos;
- total de submódulos prontos;
- submódulos pendentes;
- percentual de prontidão do módulo;
- total de fractais validados;
- total de fractais registrados;
- percentual de fractais validados;
- status geral do módulo;
- se a unidade está pronta para o Ecossistema Genius;
- booleanos de prontidão para cada submódulo de `sub01` a `sub10`;
- resumo JSON com registros, status e fractais de cada submódulo.

## Regra de prontidão

Uma unidade fica com `pronto_para_ecossistema_genius = true` quando os 10 submódulos estão prontos.

Cada submódulo usa sua própria view operacional já validada. A view consolidada apenas lê essas views e monta a visão geral do módulo.

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_VIEW_MODULO_UNIDADE_AGRICOLA_CONSOLIDADO.sql`

Resultado esperado para a unidade de teste completa:

- `total_submodulos_previstos = 10`;
- `total_submodulos_prontos = 10`;
- `total_submodulos_pendentes = 0`;
- `percentual_submodulos_prontos = 100.00`;
- `pronto_para_ecossistema_genius = true`;
- `status_modulo = saudavel`.
