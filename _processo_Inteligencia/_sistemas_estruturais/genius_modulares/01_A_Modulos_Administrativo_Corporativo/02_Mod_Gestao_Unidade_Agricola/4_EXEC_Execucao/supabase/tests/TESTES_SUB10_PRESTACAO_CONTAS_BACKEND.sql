-- TESTES_SUB10_PRESTACAO_CONTAS_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 10.
-- Pre-requisito: unidade PA-SUB01-TESTE-001 validada no submodulo 01.
-- Opcional recomendado: status STATUS-SUB09-TESTE-001 criado no submodulo 09.

select *
from unidade_agricola.salvar_sub10_prestacao_contas_unidade(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_codigo_prestacao_contas := 'PC-SUB10-TESTE-001',
  p_nome_prestacao_contas := 'Prestacao de Contas Teste Submodulo 10',
  p_periodo_inicio := (current_date - interval '30 days')::date,
  p_periodo_fim := current_date,
  p_codigo_status_operacional := 'STATUS-SUB09-TESTE-001',
  p_resumo_operacional := 'Fechamento operacional da unidade para teste do submodulo 10',
  p_total_evidencias := 8,
  p_url_pasta_evidencias := 'https://storage.genius.local/unidade-agricola/prestacao-contas/PC-SUB10-TESTE-001',
  p_conformidade_percentual := 96.50,
  p_status_conformidade := 'Conforme',
  p_pendencias_abertas := 0,
  p_pendencias_resolvidas := 3,
  p_valor_referenciado := 12500.75,
  p_moeda := 'BRL',
  p_responsavel_prestacao := 'Carlos Gestor Submodulo 03',
  p_status_prestacao := 'Fechada',
  p_data_fechamento := current_date,
  p_observacoes := 'Registro criado pelo teste do backend sub10',
  p_origem_registro := 'teste_sql_sub10',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_prestacao_contas,
  nome_prestacao_contas,
  periodo_inicio,
  periodo_fim,
  codigo_status_operacional,
  total_evidencias,
  conformidade_percentual,
  status_conformidade,
  pendencias_abertas,
  pendencias_resolvidas,
  valor_referenciado,
  moeda,
  status_prestacao,
  status_validacao,
  fractais_validados,
  total_fractais_sub10,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub10_prestacao_contas_operacional
where codigo_prestacao_contas = 'PC-SUB10-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub10_fractais_status_prestacao
where codigo_prestacao_contas = 'PC-SUB10-TESTE-001'
order by ordem_fractal;

select
  codigo_prestacao_contas,
  possui_codigo_prestacao,
  possui_nome_prestacao,
  possui_periodo_valido,
  possui_unidade_vinculada,
  possui_evidencia_suporte,
  status_validacao
from unidade_agricola.vw_sub10_validacao_prestacao_contas
where codigo_prestacao_contas = 'PC-SUB10-TESTE-001';

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
and submodulo_origem = '10_sub_prestacao_contas_unidade'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub10_contrato_backend;
