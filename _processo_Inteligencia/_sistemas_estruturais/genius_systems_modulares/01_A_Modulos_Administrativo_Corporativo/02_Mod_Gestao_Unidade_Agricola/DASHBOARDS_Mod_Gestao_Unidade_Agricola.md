# DASHBOARDS_Mod_Gestao_Unidade_Agricola

Este documento define os dashboards plug and play do módulo Gestão da Unidade Agrícola.

## Objetivo

Transformar os dados dos fractais em visões gerenciais, operacionais e técnicas para tomada de decisão.

## Dashboards recomendados

| dashboard | nome | publico | funcao |
| --- | --- | --- | --- |
| dashboard_executivo_unidade | Visão executiva da unidade agrícola | Gestores, diretoria, agentes executivos | Resumo de unidades, status, pendências, área total, completude e riscos. |
| dashboard_cadastro_base | Cadastro base da unidade | Equipe administrativa e cadastro | Acompanha preenchimento, validação, duplicidades e qualidade cadastral. |
| dashboard_documental | Documentação e regularidade | Administrativo, jurídico, fiscal e ambiental | Monitora documentos, vencimentos, pendências e situação de validação. |
| dashboard_territorial_operacional | Território, áreas e acessos | Operação, campo, georreferenciamento e logística | Acompanha áreas, talhões, limites, acessos, circulação e pontos críticos. |
| dashboard_ativos_estruturais | Ativos estruturais da unidade | Infraestrutura, manutenção e construções rurais | Monitora estruturas, benfeitorias, equipamentos fixos e estado de conservação. |
| dashboard_governanca_acessos | Governança, chaves e permissões | Gestão, segurança, workspace e cowork | Controla responsáveis, perfis, acessos, autorizações e histórico. |
| dashboard_status_pendencias | Status, riscos e pendências | Gestores, agentes e responsáveis | Consolida riscos, bloqueios, pendências, status operacional e alertas. |
| dashboard_prestacao_contas | Prestação de contas da unidade | Gestão, auditoria, financeiro e administrativo | Consolida evidências, conformidade, pendências e histórico de atualização. |
| dashboard_integracoes_ecossistema | Integrações com ecossistema Genius | TechOps, integrações, BI e DataLake | Monitora eventos, sync_status, APIs, Hub, DataLake e módulos consumidores. |

## Fluxo de alimentação

```text
Supabase / Formularios / Planilhas
  -> Tabelas dos fractais
  -> Eventos dos fractais
  -> Genius Hub
  -> DataLake
  -> Dashboards BI
  -> Agentes e automacoes
```

## Regra plug and play

Cada dashboard deve poder funcionar isoladamente, mas todos devem alimentar o dashboard executivo da unidade e o dashboard geral do ecossistema Genius.
