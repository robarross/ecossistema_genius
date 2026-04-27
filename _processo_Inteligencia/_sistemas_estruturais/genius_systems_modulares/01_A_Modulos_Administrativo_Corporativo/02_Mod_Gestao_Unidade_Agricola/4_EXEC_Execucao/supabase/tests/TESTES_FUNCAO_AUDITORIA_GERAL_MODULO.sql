-- TESTES_FUNCAO_AUDITORIA_GERAL_MODULO.sql
-- Teste manual da funcao de auditoria geral do Mod_Gestao_Unidade_Agricola.

select
  codigo_unidade,
  nome_unidade,
  status_modulo,
  pronto_para_ecossistema_genius,
  total_submodulos_previstos,
  total_submodulos_prontos,
  total_submodulos_pendentes,
  percentual_submodulos_prontos,
  total_fractais_validados,
  total_fractais_registrados,
  percentual_fractais_validados,
  diagnostico
from unidade_agricola.auditar_modulo_unidade_agricola('PA-SUB01-TESTE-001');

select
  codigo_unidade,
  pendencias,
  proximas_acoes
from unidade_agricola.auditar_modulo_unidade_agricola('PA-SUB01-TESTE-001');

select
  codigo_unidade,
  resumo_submodulos
from unidade_agricola.auditar_modulo_unidade_agricola('PA-SUB01-TESTE-001');
