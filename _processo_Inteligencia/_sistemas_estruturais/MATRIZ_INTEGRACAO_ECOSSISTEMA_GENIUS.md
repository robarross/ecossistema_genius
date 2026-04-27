# Matriz de Integracao do Ecossistema Genius

Este documento define as principais integracoes entre modulos, plataformas e core do ecossistema Genius. Ele serve como referencia para APIs, eventos, DataLake, dashboards e orquestracao de fluxos.

## Integracoes Core Obrigatorias

| Origem | Destino | Tipo | Dados Principais | Evento/API | Criticidade |
|---|---|---|---|---|---|
| Mod_Gestao_Genius_In | Mod_Gestao_Genius_Hub | Encaminhamento | demandas, documentos, contexto, modulo destino | demanda.recebida / fluxo.encaminhado | Alta |
| Mod_Gestao_Genius_Hub | Todos os modulos | Orquestracao | status, alertas, navegacao, permissoes, contexto | hub.fluxo.encaminhado | Alta |
| Todos os modulos | Mod_Gestao_Dados_DataLake | Dados | registros, historico, evidencias, indicadores | datalake.ingestao.solicitada | Alta |
| Mod_Gestao_Dados_DataLake | Mod_Gestao_Dashboards_BI | Analitica | dados tratados, modelos, indicadores | indicador.atualizado | Alta |
| Mod_Gestao_Integracoes_APIs | Todos os modulos | APIs/Eventos | conectores, rotas, webhooks, sincronizacoes | api.sincronizacao.recebida | Alta |
| Mod_Gestao_Seguranca_Informacao | Todos os modulos | Seguranca | perfis, acessos, auditoria, permissoes | acesso.validado | Alta |

## Cadeias Integradas Principais

| Fluxo | Origem | Destino | Dados Trocados | Resultado |
|---|---|---|---|---|
| Cadeia produtiva vegetal | Mod_Gestao_Producao_Vegetal_Agricola | Mod_Gestao_PosColheita | cultura, lote, talhao, volume, qualidade inicial | produto colhido rastreavel |
| Cadeia pos-colheita | Mod_Gestao_PosColheita | Mod_Gestao_Agroindustria_Rural | lote classificado, volume, qualidade, destino | materia-prima apta a processamento |
| Cadeia alimentar | Mod_Gestao_Agroindustria_Rural | Mod_Gestao_Alimentos | produto, lote, ficha, qualidade, regularizacao | alimento validado |
| Cadeia comercial | Mod_Gestao_Alimentos | Mod_Gestao_Marketplace_Agricola | produto liberado, lote, validade, disponibilidade | oferta apta para venda |
| Projetos colaborativos | Mod_Gestao_Projetos | Mod_Gestao_Genius_Workspace | projeto, entregas, tarefas, prazos, responsaveis | execucao operacional organizada |
| Colaboracao presencial | Mod_Gestao_Genius_Workspace | Mod_Gestao_Genius_Cowork | reunioes, eventos, reservas, equipes | atividade presencial vinculada |
| Experiencia 3D | Mod_Gestao_Simulador_Rural_3D | Mod_Jogos_3D | cenarios, modelos, simulacoes, parametros | missoes e treinamentos gamificados |
| Dados executivos | Todos os modulos | Mod_Gestao_Dashboards_BI | indicadores locais e transversais | paineis integrados |

## Padrao De Integracao

Todo modulo deve declarar:

- entradas esperadas;
- saidas geradas;
- eventos publicados;
- eventos consumidos;
- APIs previstas;
- dashboards proprios;
- integracao com DataLake;
- integracao com Hub;
- integracao com Genius_In;
- perfis e permissoes.

A fonte local de cada modulo esta em:

- README.md
- manifesto_modulo.json
- contrato_integracao.md