# Mod_Gestao_Regularizacao_Fundiaria

Modulo plug and play do ecossistema Genius responsavel por Gestao Regularizacao Fundiaria, integrado as plataformas: 04_Plataforma_Genius_GeoAmbiental.

## Papel Plug And Play

Este modulo deve funcionar como um sistema independente, complementar e integravel. Ele possui entradas, saidas, eventos, permissoes, dashboards e contrato de integracao proprio, mantendo conexao com o core do ecossistema Genius.

## Plataformas Relacionadas

- 04_Plataforma_Genius_GeoAmbiental

## Submodulos

- 01_sub_cadastro_imoveis_fundiarios
- 02_sub_diagnostico_situacao_fundiaria
- 03_sub_documentacao_dominial_posse
- 04_sub_cadastro_orgaos_sistemas_fundiarios
- 05_sub_analise_confrontacoes_sobreposicoes
- 06_sub_planos_regularizacao_fundiaria
- 07_sub_protocolos_processos_fundiarios
- 08_sub_retificacoes_atualizacoes_registrais
- 09_sub_validacao_conformidade_fundiaria
- 10_sub_base_fundiaria_regularizada

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
