-- TESTES_SUB07_ATIVOS_ESTRUTURAIS_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 07.
-- Pre-requisito: unidade PA-SUB01-TESTE-001 validada no submodulo 01.
-- Opcional recomendado: area AREA-SUB04-TESTE-001 criada no submodulo 04.

select *
from unidade_agricola.salvar_sub07_ativo_estrutural(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_codigo_ativo_estrutural := 'ATIVO-SUB07-TESTE-001',
  p_nome_ativo_estrutural := 'Galpao Teste Submodulo 07',
  p_tipo_ativo_estrutural := 'Edificacao Rural',
  p_categoria_ativo := 'Galpao',
  p_codigo_area_relacionada := 'AREA-SUB04-TESTE-001',
  p_localizacao_descritiva := 'Proximo ao talhao teste',
  p_finalidade_uso := 'Armazenamento operacional',
  p_material_predominante := 'Alvenaria e cobertura metalica',
  p_area_construida_m2 := 180.50,
  p_capacidade_operacional := 'Armazenamento de insumos e equipamentos',
  p_estado_conservacao := 'Bom',
  p_prioridade_manutencao := 'Media',
  p_demanda_construcao_rural := true,
  p_latitude_referencia := -3.1230,
  p_longitude_referencia := -60.0230,
  p_status_ativo := 'Ativo',
  p_observacoes := 'Ativo estrutural criado pelo teste do backend sub07',
  p_origem_registro := 'teste_sql_sub07',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_ativo_estrutural,
  nome_ativo_estrutural,
  tipo_ativo_estrutural,
  categoria_ativo,
  codigo_area_relacionada,
  estado_conservacao,
  prioridade_manutencao,
  demanda_construcao_rural,
  status_validacao,
  fractais_validados,
  total_fractais_sub07,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub07_ativos_estruturais_operacional
where codigo_ativo_estrutural = 'ATIVO-SUB07-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub07_fractais_status_ativo
where codigo_ativo_estrutural = 'ATIVO-SUB07-TESTE-001'
order by ordem_fractal;

select
  codigo_ativo_estrutural,
  possui_codigo_ativo,
  possui_nome_ativo,
  possui_tipo_ativo,
  possui_unidade_vinculada,
  possui_estado_conservacao,
  status_validacao
from unidade_agricola.vw_sub07_validacao_ativos_estruturais
where codigo_ativo_estrutural = 'ATIVO-SUB07-TESTE-001';

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
and submodulo_origem = '07_sub_base_ativos_estruturais_unidade'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub07_contrato_backend;
      