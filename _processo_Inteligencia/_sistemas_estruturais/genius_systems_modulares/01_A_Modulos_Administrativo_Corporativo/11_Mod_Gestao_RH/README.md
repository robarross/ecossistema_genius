# Mod_Gestao_RH

Modulo plug and play do ecossistema Genius responsavel por Gestao RH, integrado as plataformas: 03_Plataforma_Genius_AgroGestao.

## Papel Plug And Play

Este modulo deve funcionar como um sistema independente, complementar e integravel. Ele possui entradas, saidas, eventos, permissoes, dashboards e contrato de integracao proprio, mantendo conexao com o core do ecossistema Genius.

## Plataformas Relacionadas

- 03_Plataforma_Genius_AgroGestao

## Submodulos

- 01_sub_planejamento_quadro_pessoas
- 02_sub_recrutamento_selecao
- 03_sub_admissao_onboarding
- 04_sub_cadastro_colaboradores
- 05_sub_jornada_frequencia
- 06_sub_folha_beneficios
- 07_sub_treinamento_desenvolvimento
- 08_sub_desempenho_feedbacks
- 09_sub_saude_seguranca_trabalho
- 10_sub_desligamento_sucessao

## Entradas Esperadas

- Demandas recebidas via Mod_Gestao_Genius_In
- Dados e documentos enviados por usuarios, agentes ou modulos relacionados
- Cadastros, status, evidencias e historicos vinculados ao dominio do modulo
- Eventos e atualizacoes vindos de integracoes/APIs autorizadas

## Saidas Geradas

- Registros processados e padronizados para o dominio do modulo
- Eventos de status para Mod_Gestao_Genius_Hub
- Dados tratados para Mod_Gestao_Dados_DataLake
- Indicadores e metricas para Mod_Gestao_Dashboards_BI
- Solicitacoes ou encaminhamentos para modulos dependentes

## Integracoes Core

- Mod_Gestao_Genius_In: entrada, triagem e encaminhamento de demandas.
- Mod_Gestao_Genius_Hub: navegacao, status, alertas e coordenacao.
- Mod_Gestao_Dados_DataLake: armazenamento, historico, linhagem e dados consolidados.
- Mod_Gestao_Integracoes_APIs: APIs, conectores, eventos e sincronizacoes.
- Mod_Gestao_Dashboards_BI: indicadores, paineis e visoes analiticas.
- Mod_Gestao_Seguranca_Informacao: identidade, permissoes, auditoria e seguranca.

## Arquivos De Contrato

- manifesto_modulo.json
- contrato_integracao.md
