# Guia - View de Liberacao Plug and Play do Ecossistema

Este guia acompanha a migration `202604260026_view_liberacao_plug_play_ecossistema.sql`.

## Objetivo

Criar a matriz oficial de liberacao do `Mod_Gestao_Unidade_Agricola` para os modulos consumidores do Ecossistema Genius.

## View criada

`unidade_agricola.vw_modulo_unidade_agricola_liberacao_ecossistema`

## O que ela responde

Para cada unidade agricola e cada modulo consumidor, a view informa:

- modulo consumidor;
- categoria de consumo;
- submodulos-chave exigidos;
- se esta liberado;
- motivo da liberacao ou bloqueio;
- status de origem;
- percentuais e totais herdados da view consolidada.

## Fonte de dados

A view usa:

`unidade_agricola.vw_modulo_unidade_agricola_consolidado`

Assim, ela nao reprocessa dados dos submodulos. Ela transforma a prontidao consolidada em regras de consumo plug and play.

## Consumidores previstos

- `Mod_Gestao_Dados_DataLake`
- `Mod_Gestao_Dashboards_BI`
- `Mod_Gestao_Genius_Hub`
- `Mod_Gestao_Georreferenciamento`
- `Mod_Gestao_Financeira`
- `Mod_Gestao_Administrativa`
- `Mod_Gestao_Auditoria_Conformidade`
- `Mod_Gestao_Producao_Vegetal`
- `Mod_Gestao_Producao_Animal_Pecuaria`
- `Mod_Construcoes_Rurais`
- `Mod_Gestao_Manutencao`
- `Mod_Gestao_Cowork_Workspace`
- `Mod_Gestao_Seguranca_Patrimonial`
- `Mod_Gestao_Projetos`
- `Mod_Gestao_Tarefas_Processos`
- `Mod_Gestao_Agentes_IA`

## Teste manual

Depois de aplicar a migration no Supabase SQL Editor, execute:

`supabase/tests/TESTES_VIEW_LIBERACAO_PLUG_PLAY_ECOSSISTEMA.sql`

Resultado esperado para a unidade de teste completa:

- `total_modulos_consumidores = 16`;
- `total_liberados = 16`;
- `total_bloqueados = 0`.
