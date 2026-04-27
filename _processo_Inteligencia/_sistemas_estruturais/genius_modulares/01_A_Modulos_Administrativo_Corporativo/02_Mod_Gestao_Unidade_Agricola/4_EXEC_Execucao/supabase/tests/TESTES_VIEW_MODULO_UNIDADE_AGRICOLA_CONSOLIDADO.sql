-- TESTES_VIEW_MODULO_UNIDADE_AGRICOLA_CONSOLIDADO.sql
-- Teste manual da view consolidada do modulo completo.

select
  codigo_unidade,
  nome_unidade,
  total_submodulos_previstos,
  total_submodulos_prontos,
  total_submodulos_pendentes,
  percentual_submodulos_prontos,
  total_fractais_validados,
  total_fractais_registrados,
  percentual_fractais_validados,
  pronto_para_ecossistema_genius,
  status_modulo
from unidade_agricola.vw_modulo_unidade_agricola_consolidado
where codigo_unidade = 'PA-SUB01-TESTE-001';

select
  codigo_unidade,
  sub01_cadastro_unidade_pronto,
  sub02_proprietarios_possuidores_pronto,
  sub03_responsaveis_gestores_pronto,
  sub04_territorios_areas_pronto,
  sub05_limites_acessos_pronto,
  sub06_documentacao_pronto,
  sub07_ativos_estruturais_pronto,
  sub08_chaves_permissoes_pronto,
  sub09_status_operacional_pronto,
  sub10_prestacao_contas_pronto
from unidade_agricola.vw_modulo_unidade_agricola_consolidado
where codigo_unidade = 'PA-SUB01-TESTE-001';

select
  codigo_unidade,
  resumo_submodulos
from unidade_agricola.vw_modulo_unidade_agricola_consolidado
where codigo_unidade = 'PA-SUB01-TESTE-001';
