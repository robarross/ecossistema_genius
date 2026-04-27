# DASHBOARD_CONTRATO_DADOS_Mod_Gestao_Unidade_Agricola

Este contrato define quais fontes alimentam cada dashboard do módulo.

## Fontes obrigatórias

- Supabase schema: `unidade_agricola`
- Tabela raiz: `unidade_agricola.unidades_agricolas`
- Tabelas dos fractais
- `unidade_agricola.fractal_eventos_catalogo`
- `unidade_agricola.fractal_eventos_log`
- OpenAPI do módulo
- Genius Hub
- DataLake

## Contrato por dashboard

| dashboard | tabelas_fractais | eventos | api | uso |
| --- | --- | --- | --- | --- |
| dashboard_executivo_unidade | fractal_identidade_unidade, fractal_relacionamentos_unidade, fractal_integracao_ecossistema, fractal_indicadores_dashboards, fractal_inteligencia_automacoes | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Resumo de unidades, status, pendências, área total, completude e riscos. |
| dashboard_cadastro_base | fractal_dados_basicos_unidade, fractal_classificacao_unidade, fractal_situacao_cadastral, fractal_validacao_campos_obrigatorios, fractal_integracao_datalake_mapas_modulos, fractal_cadastro_proprietarios, fractal_cadastro_possuidores, fractal_vinculos_unidade_agricola | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Acompanha preenchimento, validação, duplicidades e qualidade cadastral. |
| dashboard_documental | fractal_documentos_titulares, fractal_documentos_fundiarios, fractal_documentos_ambientais, fractal_documentos_fiscais_cadastrais, fractal_validades_vencimentos, fractal_uploads_evidencias, fractal_integracao_regularizacao_fiscal_storage, fractal_status_documental | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Monitora documentos, vencimentos, pendências e situação de validação. |
| dashboard_territorial_operacional | fractal_localizacao_referencia_territorial, fractal_areas_produtivas, fractal_glebas_talhoes, fractal_uso_atual_area, fractal_potencial_produtivo, fractal_historico_ocupacao_uso, fractal_integracao_producao_geo_precisao, fractal_limites_fisicos_unidade | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Acompanha áreas, talhões, limites, acessos, circulação e pontos críticos. |
| dashboard_ativos_estruturais | fractal_estruturas_existentes, fractal_benfeitorias_instalacoes_fixas, fractal_equipamentos_fixos_unidade, fractal_estado_conservacao, fractal_integracao_construcoes_manutencao, fractal_status_estrutural | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Monitora estruturas, benfeitorias, equipamentos fixos e estado de conservação. |
| dashboard_governanca_acessos | fractal_integracao_contratos_juridico_permissoes, fractal_chaves_fisicas, fractal_perfis_operacionais, fractal_integracao_seguranca_cowork_workspace, fractal_governanca_permissoes | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Controla responsáveis, perfis, acessos, autorizações e histórico. |
| dashboard_status_pendencias | fractal_status_geral_unidade, fractal_status_produtivo, fractal_status_risco_pendencia, fractal_integracao_dashboards_alertas_planejamento, fractal_pendencias_abertas, fractal_operacional_status | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Consolida riscos, bloqueios, pendências, status operacional e alertas. |
| dashboard_prestacao_contas | fractal_resumo_operacional_unidade, fractal_evidencias_suporte, fractal_indicadores_conformidade, fractal_historico_atualizacoes, fractal_integracao_financeiro_admin_auditoria | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Consolida evidências, conformidade, pendências e histórico de atualização. |
| dashboard_integracoes_ecossistema | unidades_agricolas, fractal_eventos_log | fractal_eventos_log, fractal_eventos_catalogo | OPENAPI_Mod_Gestao_Unidade_Agricola.yaml | Monitora eventos, sync_status, APIs, Hub, DataLake e módulos consumidores. |

## Regras de qualidade dos dados

- Todo dashboard deve filtrar por `id_unidade_agricola`.
- Todo indicador deve aceitar filtros por status, período, município, UF e sync_status.
- Dados de payload devem ser estabilizados em colunas quando virarem regra permanente.
- Eventos devem ser rastreáveis por `id_evento`, `id_fractal_registro` e `id_unidade_agricola`.
- O dashboard do módulo deve se integrar ao dashboard geral do ecossistema Genius.
