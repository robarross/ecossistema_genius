-- TESTES_SUB01_CADASTRO_UNIDADES_AGRICOLAS_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 01.

select *
from unidade_agricola.salvar_sub01_cadastro_unidade_agricola(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_nome_unidade := 'Fazenda Teste Submodulo 01',
  p_tipo_unidade := 'Fazenda',
  p_status_cadastro := 'Ativo',
  p_situacao_operacional := 'Em operacao',
  p_uf := 'AM',
  p_municipio := 'Manaus',
  p_latitude_sede := -3.1200,
  p_longitude_sede := -60.0200,
  p_area_total_ha := 321.45,
  p_categoria_unidade := 'Produtiva',
  p_referencia_territorial := 'Sede principal validada',
  p_origem_registro := 'teste_sql_sub01',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  status_validacao,
  fractais_validados,
  total_fractais_sub01,
  pronto_para_submodulos_dependentes
from unidade_agricola.vw_sub01_cadastro_unidades_agricolas_operacional
where codigo_unidade = 'PA-SUB01-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub01_fractais_status_unidade
where codigo_unidade = 'PA-SUB01-TESTE-001'
order by ordem_fractal;

select
  codigo_unidade,
  possui_codigo_unidade,
  possui_nome_unidade,
  possui_tipo_unidade,
  possui_uf,
  possui_municipio,
  possui_area_total,
  status_validacao
from unidade_agricola.vw_sub01_validacao_campos_obrigatorios
where codigo_unidade = 'PA-SUB01-TESTE-001';

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
and submodulo_origem = '01_sub_cadastro_unidades_agricolas'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub01_contrato_backend;
