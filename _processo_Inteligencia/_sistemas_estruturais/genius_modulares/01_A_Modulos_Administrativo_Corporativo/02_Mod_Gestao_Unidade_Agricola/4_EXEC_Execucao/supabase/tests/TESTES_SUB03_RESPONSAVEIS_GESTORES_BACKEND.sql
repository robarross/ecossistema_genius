-- TESTES_SUB03_RESPONSAVEIS_GESTORES_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 03.
-- Pre-requisitos:
-- 1. Unidade PA-SUB01-TESTE-001 validada no submodulo 01.
-- 2. Titular TIT-SUB02-TESTE-001 validado no submodulo 02.

select *
from unidade_agricola.salvar_sub03_responsavel_gestor(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_nome_responsavel := 'Carlos Gestor Submodulo 03',
  p_documento_responsavel := '00000000272',
  p_tipo_responsabilidade := 'Gestor Administrativo',
  p_cargo_funcao := 'Gerente da Unidade',
  p_papel_operacional := 'Gestao geral da unidade agricola',
  p_area_responsabilidade := 'Administracao e Operacao',
  p_nivel_autorizacao := 'Gerencial',
  p_principal := true,
  p_telefone := '(92) 99999-0002',
  p_email := 'carlos.sub03@genius.local',
  p_status_responsavel := 'Ativo',
  p_observacoes := 'Responsavel criado pelo teste do backend sub03',
  p_codigo_responsavel := 'RESP-SUB03-TESTE-001',
  p_codigo_titular := 'TIT-SUB02-TESTE-001',
  p_origem_registro := 'teste_sql_sub03',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_titular,
  codigo_responsavel,
  nome_responsavel,
  tipo_responsabilidade,
  nivel_autorizacao,
  status_validacao,
  fractais_validados,
  total_fractais_sub03,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub03_responsaveis_gestores_operacional
where codigo_responsavel = 'RESP-SUB03-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub03_fractais_status_responsavel
where codigo_responsavel = 'RESP-SUB03-TESTE-001'
order by ordem_fractal;

select
  codigo_responsavel,
  possui_nome_responsavel,
  possui_tipo_responsabilidade,
  possui_nivel_autorizacao,
  possui_unidade_vinculada,
  status_validacao
from unidade_agricola.vw_sub03_validacao_responsaveis
where codigo_responsavel = 'RESP-SUB03-TESTE-001';

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
and submodulo_origem = '03_sub_responsaveis_gestores'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub03_contrato_backend;
