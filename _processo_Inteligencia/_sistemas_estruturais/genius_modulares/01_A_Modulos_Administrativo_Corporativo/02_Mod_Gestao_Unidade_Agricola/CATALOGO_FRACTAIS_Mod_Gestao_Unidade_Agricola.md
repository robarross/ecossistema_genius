# Catalogo de Fractais - Mod_Gestao_Unidade_Agricola

Este catalogo lista os fractais centrais do modulo e os fractais de cada submodulo.

## Fractais centrais do modulo
- 01_fractal_identidade_unidade: Define codigo, nome, tipo, localizacao e identidade operacional da unidade agricola.
- 02_fractal_relacionamentos_unidade: Conecta unidade agricola com proprietarios, gestores, areas, documentos, ativos e modulos do ecossistema.
- 03_fractal_governanca_permissoes: Controla perfis, acessos, responsabilidades, autorizacoes e regras de governanca.
- 04_fractal_documental_juridico: Organiza documentos, certidoes, registros, contratos e evidencias juridicas da unidade.
- 05_fractal_operacional_status: Controla situacao operacional, produtiva, documental, estrutural e regulatoria da unidade.
- 06_fractal_integracao_ecossistema: Publica e consome dados para producao, financeiro, fiscal, ambiental, dashboards, DataLake, Hub e APIs.
- 07_fractal_indicadores_dashboards: Estrutura indicadores, metricas, visoes gerenciais e sinais de acompanhamento da unidade agricola.
- 08_fractal_inteligencia_automacoes: Habilita alertas, agentes, recomendacoes, regras, validacoes e automacoes futuras.

## Fractais por submodulo

### 01_sub_cadastro_unidades_agricolas
- 01_fractal_dados_basicos_unidade: Registra identificadores, nome, codigo, tipo, categoria e dados essenciais da unidade agricola.
- 02_fractal_localizacao_referencia_territorial: Registra endereco, coordenadas, municipio, UF, comunidade, acesso e referencias territoriais.
- 03_fractal_classificacao_unidade: Classifica a unidade por tipo, porte, finalidade, uso predominante e perfil produtivo.
- 04_fractal_situacao_cadastral: Controla status cadastral, pendencias, revisoes, validacoes e historico de atualizacao.
- 05_fractal_validacao_campos_obrigatorios: Define regras minimas de preenchimento, consistencia e liberacao para integracoes.
- 06_fractal_integracao_datalake_mapas_modulos: Conecta o cadastro da unidade ao DataLake, mapas, Hub, dashboards e modulos dependentes.

### 02_sub_proprietarios_possuidores
- 01_fractal_cadastro_proprietarios: Registra proprietarios pessoas fisicas ou juridicas vinculados a unidade agricola.
- 02_fractal_cadastro_possuidores: Registra possuidores, ocupantes, arrendatarios e demais titulares operacionais da unidade.
- 03_fractal_documentos_titulares: Organiza documentos pessoais, empresariais, fundiarios e cadastrais dos titulares.
- 04_fractal_vinculos_unidade_agricola: Define tipo de vinculo, percentual, periodo, responsabilidade e status da relacao.
- 05_fractal_historico_titularidade: Mantem historico de alteracoes, transferencias, substituicoes e revisoes de titularidade.
- 06_fractal_integracao_contratos_juridico_permissoes: Integra titulares com contratos, juridico, fiscal, permissoes, usuarios e auditoria.

### 03_sub_responsaveis_gestores
- 01_fractal_cadastro_responsaveis: Registra responsaveis administrativos, tecnicos, operacionais e financeiros.
- 02_fractal_funcoes_papeis_operacionais: Define papeis, funcoes, alcadas e responsabilidades praticas na unidade.
- 03_fractal_responsabilidade_tecnica: Controla responsaveis tecnicos, registros, areas de atuacao e vigencia.
- 04_fractal_responsabilidade_administrativa: Organiza responsaveis por documentos, compras, contratos, prestacao de contas e rotina administrativa.
- 05_fractal_niveis_autorizacao: Define niveis de aprovacao, acesso, decisao e assinatura por perfil.
- 06_fractal_integracao_tarefas_projetos_cowork: Conecta responsaveis com tarefas, projetos, workspace, cowork, alertas e permissoes.

### 04_sub_territorios_areas_producao
- 01_fractal_areas_produtivas: Registra areas produtivas vinculadas a unidade agricola e sua situacao de uso.
- 02_fractal_glebas_talhoes: Organiza glebas, talhoes, codigos, dimensoes e relacionamentos territoriais.
- 03_fractal_uso_atual_area: Registra uso atual, cultura, atividade, ocupacao, restricoes e disponibilidade.
- 04_fractal_potencial_produtivo: Avalia aptidao, capacidade produtiva, limitacoes e oportunidades de uso.
- 05_fractal_historico_ocupacao_uso: Mantem historico de culturas, atividades, rotacoes, pausas e alteracoes de uso.
- 06_fractal_integracao_producao_geo_precisao: Integra areas com producao vegetal, animal, georreferenciamento e agricultura de precisao.

### 05_sub_limites_acessos
- 01_fractal_limites_fisicos_unidade: Registra limites, confrontacoes, cercas, marcos, pontos e referencias fisicas.
- 02_fractal_acessos_internos_externos: Mapeia entradas, saidas, acessos internos, acessos externos e condicoes de trafego.
- 03_fractal_estradas_ramais_porteiras: Registra estradas, ramais, porteiras, pontes, passagens e pontos de controle.
- 04_fractal_pontos_criticos_acesso: Identifica riscos, gargalos, bloqueios, manutencoes e vulnerabilidades de acesso.
- 05_fractal_controle_circulacao: Controla circulacao de pessoas, veiculos, maquinas, cargas e visitantes.
- 06_fractal_integracao_seguranca_logistica_manutencao: Integra acessos com seguranca, logistica, mapas, manutencao e monitoramento.

### 06_sub_documentacao_unidade
- 01_fractal_documentos_fundiarios: Organiza matriculas, posses, contratos, CCIR e demais registros fundiarios.
- 02_fractal_documentos_ambientais: Organiza CAR, licencas, autorizacoes, reservas, APPs e documentos ambientais.
- 03_fractal_documentos_fiscais_cadastrais: Organiza ITR, inscricoes, certidoes fiscais, cadastros oficiais e comprovantes.
- 04_fractal_validades_vencimentos: Controla prazos, vencimentos, alertas, renovacoes e situacao documental.
- 05_fractal_uploads_evidencias: Gerencia arquivos, anexos, evidencias, URLs, metadados e storage.
- 06_fractal_integracao_regularizacao_fiscal_storage: Integra documentos com regularizacao fundiaria, ambiental, fiscal, Supabase e storage.

### 07_sub_base_ativos_estruturais_unidade
- 01_fractal_estruturas_existentes: Registra estruturas, edificacoes, instalacoes e bases fisicas existentes na unidade.
- 02_fractal_benfeitorias_instalacoes_fixas: Organiza benfeitorias, cercas, currais, galpoes, reservatorios e instalacoes fixas.
- 03_fractal_equipamentos_fixos_unidade: Registra equipamentos instalados de forma fixa ou estrutural na unidade agricola.
- 04_fractal_estado_conservacao: Avalia conservacao, risco, manutencao necessaria e prioridade de intervencao.
- 05_fractal_relacao_areas_uso_operacional: Relaciona ativos estruturais com areas, talhoes, operacoes e uso produtivo.
- 06_fractal_integracao_construcoes_manutencao: Serve de base para Construcoes Rurais e integra com Manutencao, ativos e dashboards.

### 08_sub_chaves_permissoes_operacionais
- 01_fractal_chaves_fisicas: Controla chaves fisicas, copias, responsaveis, locais e historico de entrega.
- 02_fractal_acessos_digitais: Controla senhas, acessos, credenciais, sistemas, tokens e autorizacoes digitais.
- 03_fractal_perfis_operacionais: Define perfis de usuario, niveis de acesso e responsabilidades operacionais.
- 04_fractal_autorizacoes_area_funcao: Regula acessos conforme area, funcao, modulo, unidade e tipo de operacao.
- 05_fractal_historico_acesso: Registra logs, retiradas, devolucoes, acessos concedidos e acessos revogados.
- 06_fractal_integracao_seguranca_cowork_workspace: Integra chaves e permissoes com seguranca da informacao, cowork, workspace e usuarios.

### 09_sub_status_operacional_unidade
- 01_fractal_status_geral_unidade: Define status consolidado da unidade agricola e sua prontidao operacional.
- 02_fractal_status_produtivo: Controla condicao produtiva, areas ativas, ciclos e disponibilidade de producao.
- 03_fractal_status_documental: Consolida pendencias, validades, riscos e aprovacao documental.
- 04_fractal_status_estrutural: Consolida situacao de estruturas, benfeitorias, acessos e ativos fixos.
- 05_fractal_status_risco_pendencia: Identifica riscos, bloqueios, inconformidades, alertas e tarefas pendentes.
- 06_fractal_integracao_dashboards_alertas_planejamento: Publica status para dashboards, alertas, planejamento, tarefas e agentes.

### 10_sub_prestacao_contas_unidade
- 01_fractal_resumo_operacional_unidade: Gera visao resumida da operacao, status, indicadores e eventos relevantes.
- 02_fractal_evidencias_suporte: Organiza evidencias, comprovantes, fotos, documentos e anexos de suporte.
- 03_fractal_indicadores_conformidade: Calcula indicadores de conformidade cadastral, documental, estrutural e operacional.
- 04_fractal_pendencias_abertas: Lista pendencias, responsaveis, prazos, prioridades e status de resolucao.
- 05_fractal_historico_atualizacoes: Mantem trilha de alteracoes, revisoes, aprovacoes e auditoria da unidade.
- 06_fractal_integracao_financeiro_admin_auditoria: Integra prestacao de contas com financeiro, administrativo, dashboards, auditoria e DataLake.
