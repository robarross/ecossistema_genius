# INDICADORES_KPIS_Mod_Gestao_Unidade_Agricola

Este catálogo define os indicadores mínimos para acompanhamento do módulo.

## KPIs recomendados

| kpi | nome | formula_logica | fonte | categoria |
| --- | --- | --- | --- | --- |
| kpi_total_unidades | Total de unidades agrícolas | count(unidades_agricolas) | unidades_agricolas | executivo |
| kpi_unidades_ativas | Unidades ativas | count where status_cadastro = Ativo | unidades_agricolas | executivo |
| kpi_unidades_pendentes | Unidades pendentes | count where status_cadastro in Pendente/Em validacao | unidades_agricolas | executivo |
| kpi_area_total_ha | Área total cadastrada | sum(area_total_ha) | unidades_agricolas | territorial |
| kpi_completude_cadastral | Completude cadastral | campos preenchidos / campos obrigatorios | fractais de cadastro | cadastro |
| kpi_documentos_validos | Documentos válidos | count documentos com status válido | fractais documentais | documental |
| kpi_documentos_vencidos | Documentos vencidos | count documentos vencidos | fractais documentais | documental |
| kpi_areas_talhoes_cadastrados | Áreas/talhões/glebas cadastrados | count registros territoriais | fractais territoriais | territorial |
| kpi_ativos_estruturais | Ativos estruturais cadastrados | count ativos estruturais | fractais de ativos | infraestrutura |
| kpi_pendencias_abertas | Pendências abertas | count status pendente/erro | todos os fractais | status |
| kpi_riscos_criticos | Riscos críticos | count riscos críticos | status e pendências | status |
| kpi_eventos_publicados | Eventos publicados | count fractal_eventos_log | fractal_eventos_log | integração |
| kpi_sync_pendente | Sincronizações pendentes | count sync_status = pendente | todos os fractais | integração |
| kpi_sync_erro | Sincronizações com erro | count sync_status = erro | todos os fractais | integração |
| kpi_conformidade_unidade | Índice de conformidade da unidade | media ponderada cadastro/documentos/status/evidencias | múltiplas fontes | executivo |

## Frequência sugerida

- Operacional: em tempo quase real ou a cada sincronização.
- Gestão diária: atualização diária.
- Auditoria e prestação de contas: atualização por evento validado.
- Histórico/DataLake: atualização incremental.
