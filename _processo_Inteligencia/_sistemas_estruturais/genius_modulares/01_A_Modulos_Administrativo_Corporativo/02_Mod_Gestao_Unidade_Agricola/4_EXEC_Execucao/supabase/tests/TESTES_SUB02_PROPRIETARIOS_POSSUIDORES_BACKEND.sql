-- TESTES_SUB02_PROPRIETARIOS_POSSUIDORES_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 02.
-- Pre-requisito: unidade PA-SUB01-TESTE-001 validada no submodulo 01.

select *
from unidade_agricola.salvar_sub02_proprietario_possuidor(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_nome_titular := 'Maria Titular Submodulo 02',
  p_documento_titular := '00000000191',
  p_tipo_titular := 'Pessoa fisica',
  p_tipo_vinculo := 'Proprietario',
  p_percentual_participacao := 100.00,
  p_telefone := '(92) 99999-0001',
  p_email := 'maria.sub02@genius.local',
  p_status_vinculo := 'Ativo',
  p_observacoes := 'Titular criado pelo teste do backend sub02',
  p_codigo_titular := 'TIT-SUB02-TESTE-001',
  p_origem_registro := 'teste_sql_sub02',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_titular,
  nome_titular,
  tipo_vinculo,
  status_validacao,
  fractais_validados,
  total_fractais_sub02,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub02_proprietarios_possuidores_operacional
where codigo_titular = 'TIT-SUB02-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub02_fractais_status_titular
where codigo_titular = 'TIT-SUB02-TESTE-001'
order by ordem_fractal;

select
  codigo_titular,
  possui_nome_titular,
  possui_tipo_vinculo,
  possui_documento,
  possui_unidade_vinculada,
  status_validacao
from unidade_agricola.vw_sub02_validacao_titulares
where codigo_titular = 'TIT-SUB02-TESTE-001';

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
and submodulo_origem = '02_sub_proprietarios_possuidores'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub02_contrato_backend;
