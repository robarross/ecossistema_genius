# AUTOMACOES_Mod_Gestao_Unidade_Agricola

Este documento define automações operacionais e inteligentes do módulo.

## Automações recomendadas

| automacao | gatilho | acao | agente_responsavel | saida |
| --- | --- | --- | --- | --- |
| auto_validar_cadastro_minimo | Ao criar/atualizar unidade | Verifica campos mínimos e atualiza status cadastral. | agente_cadastro_unidade | cadastro.validado ou cadastro.incompleto |
| auto_alertar_documento_vencido | Diariamente ou por upload | Detecta documentos vencidos ou próximos do vencimento. | agente_documental | documento.vencido |
| auto_criar_pendencia_documental | Documento inválido/vencido | Cria pendência vinculada à unidade e responsável. | agente_status_pendencias | pendencia.criada |
| auto_validar_vinculo_proprietario | Titular criado/alterado | Confere vínculo com unidade e consistência documental. | agente_proprietarios_vinculos | proprietario.vinculado |
| auto_verificar_area_sem_unidade | Área/talhão criado | Bloqueia área sem id_unidade_agricola válido. | agente_territorial_areas | area.sem_vinculo |
| auto_sugerir_manutencao_ativo | Ativo estrutural com conservação ruim | Cria recomendação para manutenção ou inspeção. | agente_ativos_estruturais | manutencao.sugerida |
| auto_atualizar_dashboard_status | Evento de fractal validado | Atualiza métricas de status, pendências e completude. | agente_integracao_ecossistema | dashboard.atualizado |
| auto_publicar_evento_hub | Registro criado/atualizado/validado | Publica evento padronizado no Genius Hub. | agente_integracao_ecossistema | evento.publicado |
| auto_indexar_datalake | Evento publicado | Envia payload e metadados para DataLake. | agente_integracao_ecossistema | datalake.indexado |
| auto_gerar_relatorio_conformidade | Fechamento semanal/mensal | Gera resumo de conformidade e prestação de contas. | agente_prestacao_contas | conformidade.calculada |
| auto_auditar_inconsistencias | Rotina agendada | Procura registros órfãos, sync erro, pendências antigas e eventos sem consumo. | agente_auditor_unidade | auditoria.alerta |
| auto_liberar_modulos_consumidores | Unidade validada | Sinaliza módulos de produção, fiscal, financeiro, territorial e marketplace. | agente_integracao_ecossistema | modulos_consumidores.liberados |

## Prioridade de implantação

1. Validação de cadastro mínimo.
2. Alerta de documentos vencidos.
3. Publicação de eventos no Hub.
4. Atualização de dashboards.
5. Sincronização DataLake/APIs.
6. Auditoria de inconsistências.
