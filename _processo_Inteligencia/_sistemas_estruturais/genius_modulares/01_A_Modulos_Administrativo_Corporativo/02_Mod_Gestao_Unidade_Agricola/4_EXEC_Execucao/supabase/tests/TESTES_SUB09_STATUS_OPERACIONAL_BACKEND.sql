-- TESTES_SUB09_STATUS_OPERACIONAL_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 09.
-- Pre-requisito: unidade PA-SUB01-TESTE-001 validada no submodulo 01.

select *
from unidade_agricola.salvar_sub09_status_operacional_unidade(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_codigo_status_operacional := 'STATUS-SUB09-TESTE-001',
  p_nome_ciclo_status := 'Diagnostico Operacional Teste Submodulo 09',
  p_status_geral := 'Operacional',
  p_status_produtivo := 'Produtivo',
  p_status_documental := 'Regular',
  p_status_estrutural := 'Adequado',
  p_nivel_risco := 'Baixo',
  p_pendencias_abertas := 0,
  p_alertas_ativos := 0,
  p_prioridade_acao := 'Rotina',
  p_responsavel_acompanhamento := 'Carlos Gestor Submodulo 03',
  p_data_referencia := current_date,
  p_proxima_revisao := (current_date + interval '30 days')::date,
  p_resumo_operacional := 'Unidade em condicao operacional adequada para teste do submodulo 09',
  p_recomendacao_acao := 'Manter acompanhamento periodico',
  p_origem_registro := 'teste_sql_sub09',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_status_operacional,
  nome_ciclo_status,
  status_geral,
  status_produtivo,
  status_documental,
  status_estrutural,
  nivel_risco,
  pendencias_abertas,
  alertas_ativos,
  prioridade_acao,
  status_validacao,
  fractais_validados,
  total_fractais_sub09,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub09_status_operacional_unidade
where codigo_status_operacional = 'STATUS-SUB09-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub09_fractais_status_operacional
where codigo_status_operacional = 'STATUS-SUB09-TESTE-001'
order by ordem_fractal;

select
  codigo_status_operacional,
  possui_codigo_status,
  possui_nome_ciclo,
  possui_status_geral,
  possui_unidade_vinculada,
  status_validacao
from unidade_agricola.vw_sub09_validacao_status_operacional
where codigo_status_operacional = 'STATUS-SUB09-TESTE-001';

select
  nome_evento,
  fractal_origem,
  status,
  published_at
from unidade_agricola.fractal_eventos_log
where id_unidade_agricola = (
  select id_unidade_agricola
  from unidade_agricola.unidades_agricolas
  where codigo_unidade = 'PA-SUB01-TESTE-001'
)
and submodulo_origem = '09_sub_status_operacional_unidade'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub09_contrato_backend;
