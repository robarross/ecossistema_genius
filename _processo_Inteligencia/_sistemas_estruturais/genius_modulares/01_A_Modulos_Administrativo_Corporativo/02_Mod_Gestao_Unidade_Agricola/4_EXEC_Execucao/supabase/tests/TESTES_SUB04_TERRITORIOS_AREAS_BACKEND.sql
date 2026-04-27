-- TESTES_SUB04_TERRITORIOS_AREAS_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 04.
-- Pre-requisito: unidade PA-SUB01-TESTE-001 validada no submodulo 01.

select *
from unidade_agricola.salvar_sub04_area_producao(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_codigo_area := 'AREA-SUB04-TESTE-001',
  p_nome_area := 'Talhao Teste Submodulo 04',
  p_tipo_area := 'Talhao',
  p_codigo_area_pai := 'GLEBA-SUB04-TESTE-001',
  p_nome_area_pai := 'Gleba Teste Submodulo 04',
  p_area_ha := 25.75,
  p_uso_atual := 'Producao vegetal',
  p_cultura_atividade := 'Mandioca',
  p_potencial_produtivo := 'Alto',
  p_latitude_centroide := -3.1210,
  p_longitude_centroide := -60.0210,
  p_status_area := 'Ativa',
  p_observacoes := 'Area criada pelo teste do backend sub04',
  p_origem_registro := 'teste_sql_sub04',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_area,
  nome_area,
  tipo_area,
  area_ha,
  uso_atual,
  cultura_atividade,
  status_validacao,
  fractais_validados,
  total_fractais_sub04,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub04_territorios_areas_operacional
where codigo_area = 'AREA-SUB04-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub04_fractais_status_area
where codigo_area = 'AREA-SUB04-TESTE-001'
order by ordem_fractal;

select
  codigo_area,
  possui_codigo_area,
  possui_nome_area,
  possui_unidade_vinculada,
  possui_area_valida,
  possui_uso_atual,
  status_validacao
from unidade_agricola.vw_sub04_validacao_areas_producao
where codigo_area = 'AREA-SUB04-TESTE-001';

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
and submodulo_origem = '04_sub_territorios_areas_producao'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub04_contrato_backend;
