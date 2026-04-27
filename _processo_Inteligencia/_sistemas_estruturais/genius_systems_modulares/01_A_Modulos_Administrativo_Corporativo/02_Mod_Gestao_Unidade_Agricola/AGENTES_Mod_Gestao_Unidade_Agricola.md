# AGENTES_Mod_Gestao_Unidade_Agricola

Este catálogo define os agentes operacionais do módulo Gestão da Unidade Agrícola.

## Papel dos agentes

Os agentes executam validações, alertas, auditorias, sincronizações e recomendações sobre os fractais do módulo.

## Agentes recomendados

| agente | area | funcao | fontes | eventos |
| --- | --- | --- | --- | --- |
| agente_cadastro_unidade | Cadastro e completude | Valida dados básicos, campos obrigatórios, duplicidades e status cadastral. | Cadastro_Propriedades, fractais de cadastro | cadastro.incompleto, cadastro.validado |
| agente_proprietarios_vinculos | Proprietários e vínculos | Confere titulares, possuidores, vínculos, documentos e inconsistências. | sub_proprietarios_possuidores | proprietario.vinculado, titularidade.pendente |
| agente_responsaveis_permissoes | Responsáveis e permissões | Analisa responsáveis, perfis, autorizações e coerência das permissões. | sub_responsaveis_gestores, sub_chaves_permissoes | permissao.inconsistente, responsavel.validado |
| agente_territorial_areas | Território e áreas | Valida áreas, talhões, glebas, limites, acessos e relação territorial. | sub_territorios_areas_producao, sub_limites_acessos | area.sem_vinculo, territorio.validado |
| agente_documental | Documentos e vencimentos | Monitora documentos obrigatórios, vencimentos, anexos e evidências. | sub_documentacao_unidade | documento.vencido, documento.validado |
| agente_ativos_estruturais | Ativos estruturais | Verifica estruturas, benfeitorias, equipamentos fixos e estado de conservação. | sub_base_ativos_estruturais_unidade | ativo.registrado, manutencao.sugerida |
| agente_status_pendencias | Status e pendências | Consolida status operacional, riscos, bloqueios e pendências abertas. | sub_status_operacional_unidade | pendencia.criada, risco.detectado |
| agente_prestacao_contas | Prestação de contas | Gera visão de evidências, conformidade, histórico e prestação de contas. | sub_prestacao_contas_unidade | prestacao.atualizada, conformidade.calculada |
| agente_integracao_ecossistema | Integração | Sincroniza Hub, DataLake, APIs, dashboards e módulos consumidores. | fractais de integração, eventos, APIs | sync.executado, evento.publicado |
| agente_auditor_unidade | Auditoria | Revisa trilhas, eventos, alterações, evidências e coerência geral do módulo. | todos os fractais | auditoria.alerta, auditoria.concluida |

## Regra de atuação

Cada agente deve operar sobre um conjunto claro de fractais, publicar eventos padronizados, respeitar permissões/RLS e alimentar dashboards.
