-- TESTES_SUB08_CHAVES_PERMISSOES_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 08.
-- Pre-requisito: unidade PA-SUB01-TESTE-001 validada no submodulo 01.
-- Opcional recomendado: responsavel RESP-SUB03-TESTE-001, area AREA-SUB04-TESTE-001 e ativo ATIVO-SUB07-TESTE-001.

select *
from unidade_agricola.salvar_sub08_chave_permissao_operacional(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_codigo_chave_permissao := 'PERM-SUB08-TESTE-001',
  p_nome_chave_permissao := 'Acesso Operacional Teste Submodulo 08',
  p_tipo_acesso := 'Fisico e Digital',
  p_categoria_acesso := 'Porteira e Sistema',
  p_codigo_responsavel := 'RESP-SUB03-TESTE-001',
  p_codigo_titular := 'TIT-SUB02-TESTE-001',
  p_codigo_area_relacionada := 'AREA-SUB04-TESTE-001',
  p_codigo_ativo_estrutural := 'ATIVO-SUB07-TESTE-001',
  p_recurso_controlado := 'Porteira principal e painel operacional',
  p_perfil_operacional := 'Gestor Administrativo',
  p_nivel_permissao := 'Gerencial',
  p_forma_credencial := 'Chave fisica e login nominal',
  p_validade_inicio := current_date,
  p_validade_fim := (current_date + interval '365 days')::date,
  p_status_permissao := 'Ativa',
  p_historico_acao := 'Permissao concedida para teste backend sub08',
  p_observacoes := 'Registro criado pelo teste do backend sub08',
  p_origem_registro := 'teste_sql_sub08',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_chave_permissao,
  nome_chave_permissao,
  tipo_acesso,
  categoria_acesso,
  codigo_responsavel,
  codigo_area_relacionada,
  codigo_ativo_estrutural,
  perfil_operacional,
  nivel_permissao,
  status_permissao,
  status_validacao,
  fractais_validados,
  total_fractais_sub08,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub08_chaves_permissoes_operacional
where codigo_chave_permissao = 'PERM-SUB08-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub08_fractais_status_chave_permissao
where codigo_chave_permissao = 'PERM-SUB08-TESTE-001'
order by ordem_fractal;

select
  codigo_chave_permissao,
  possui_codigo_chave_permissao,
  possui_nome_chave_permissao,
  possui_tipo_acesso,
  possui_unidade_vinculada,
  possui_perfil_operacional,
  status_validacao
from unidade_agricola.vw_sub08_validacao_chaves_permissoes
where codigo_chave_permissao = 'PERM-SUB08-TESTE-001';

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
and submodulo_origem = '08_sub_chaves_permissoes_operacionais'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub08_contrato_backend;
