# REGRAS_NEGOCIO_Mod_Gestao_Unidade_Agricola

Este documento define as regras de negócio mínimas para tornar o módulo consistente e plug and play.

## Regras

| codigo | regra | descricao | acao |
| --- | --- | --- | --- |
| RN-001 | Cadastro mínimo | Unidade só pode ficar Ativa se tiver código, nome, município, UF, status e responsável principal. | Bloquear ativação e criar pendência. |
| RN-002 | Unicidade de código | codigo_unidade/codigo_propriedade deve ser único no escopo da organização. | Impedir duplicidade. |
| RN-003 | Área vinculada | Área, talhão ou gleba precisa estar vinculada a uma unidade agrícola válida. | Marcar registro como erro. |
| RN-004 | Documento vencido | Documento vencido altera status documental e gera pendência. | Criar evento documento.vencido. |
| RN-005 | Responsável autorizado | Responsável só pode executar ações compatíveis com perfil e permissão. | Bloquear ação e registrar auditoria. |
| RN-006 | Ativo estrutural vinculado | Ativo estrutural precisa ter unidade, localização ou área operacional vinculada. | Manter como pendente. |
| RN-007 | Status consolidado | Status operacional deve considerar cadastro, documentos, áreas, ativos, pendências e sync. | Atualizar dashboard de status. |
| RN-008 | Sync obrigatório | Registro validado deve ser enviado para Hub/DataLake/APIs conforme configuração. | Criar evento sincronizado ou erro. |
| RN-009 | Payload auditável | Payload flexível deve manter origem, usuário, data e status. | Bloquear payload sem metadados mínimos. |
| RN-010 | Prestação de contas | Pendências críticas impedem fechamento de prestação de contas como concluída. | Manter status em revisão. |
| RN-011 | Integração com Construções Rurais | Ativos estruturais da unidade servem de base, mas detalhamento técnico é do módulo Construções Rurais. | Publicar evento para módulo consumidor. |
| RN-012 | Integração com Produção | Módulos produtivos só devem consumir unidade/área validada. | Liberar consumo após status validado. |

## Regra central

A unidade agrícola deve ser tratada como entidade base do ecossistema. Módulos produtivos, territoriais, financeiros, fiscais, construtivos e comerciais podem consumir seus dados, mas devem respeitar status, permissões e eventos publicados.
