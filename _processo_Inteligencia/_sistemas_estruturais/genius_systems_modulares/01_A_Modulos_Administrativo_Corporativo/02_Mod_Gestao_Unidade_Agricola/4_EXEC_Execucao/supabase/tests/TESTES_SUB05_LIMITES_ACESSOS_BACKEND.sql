-- TESTES_SUB05_LIMITES_ACESSOS_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 05.
-- Pre-requisitos:
-- 1. Unidade PA-SUB01-TESTE-001 validada no submodulo 01.
-- 2. Area AREA-SUB04-TESTE-001 validada no submodulo 04.

select *
from unidade_agricola.salvar_sub05_limite_acesso(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_codigo_limite_acesso := 'ACESSO-SUB05-TESTE-001',
  p_nome_limite_acesso := 'Porteira Principal Teste Submodulo 05',
  p_tipo_registro := 'Porteira',
  p_categoria_acesso := 'Acesso externo principal',
  p_descricao_local := 'Entrada principal da unidade agricola',
  p_codigo_area_relacionada := 'AREA-SUB04-TESTE-001',
  p_tipo_via := 'Ramal',
  p_condicao_acesso := 'Trafegavel',
  p_controle_circulacao := 'Entrada autorizada com registro',
  p_ponto_critico := true,
  p_risco_observado := 'Controle de entrada de terceiros',
  p_latitude_referencia := -3.1220,
  p_longitude_referencia := -60.0220,
  p_status_registro := 'Ativo',
  p_observacoes := 'Limite/acesso criado pelo teste do backend sub05',
  p_origem_registro := 'teste_sql_sub05',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_limite_acesso,
  nome_limite_acesso,
  tipo_registro,
  categoria_acesso,
  condicao_acesso,
  controle_circulacao,
  ponto_critico,
  status_validacao,
  fractais_validados,
  total_fractais_sub05,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub05_limites_acessos_operacional
where codigo_limite_acesso = 'ACESSO-SUB05-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub05_fractais_status_limite_acesso
where codigo_limite_acesso = 'ACESSO-SUB05-TESTE-001'
order by ordem_fractal;

select
  codigo_limite_acesso,
  possui_codigo_limite_acesso,
  possui_nome_limite_acesso,
  possui_unidade_vinculada,
  possui_tipo_registro,
  possui_condicao_acesso,
  status_validacao
from unidade_agricola.vw_sub05_validacao_limites_acessos
where codigo_limite_acesso = 'ACESSO-SUB05-TESTE-001';

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
and submodulo_origem = '05_sub_limites_acessos'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub05_contrato_backend;
