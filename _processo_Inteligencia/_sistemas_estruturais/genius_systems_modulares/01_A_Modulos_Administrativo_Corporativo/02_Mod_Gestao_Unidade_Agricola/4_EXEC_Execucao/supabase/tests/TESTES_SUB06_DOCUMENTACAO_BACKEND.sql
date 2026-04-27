-- TESTES_SUB06_DOCUMENTACAO_BACKEND.sql
-- Testes manuais para a camada executavel do submodulo 06.
-- Pre-requisito: unidade PA-SUB01-TESTE-001 validada no submodulo 01.

select *
from unidade_agricola.salvar_sub06_documento_unidade(
  p_codigo_unidade := 'PA-SUB01-TESTE-001',
  p_codigo_documento := 'DOC-SUB06-TESTE-001',
  p_nome_documento := 'CAR Teste Submodulo 06',
  p_tipo_documento := 'Documento Ambiental',
  p_categoria_documento := 'Ambiental e Cadastral',
  p_orgao_emissor := 'Orgao Ambiental Teste',
  p_numero_documento := 'CAR-TESTE-0001',
  p_data_emissao := (current_date - interval '30 days')::date,
  p_data_validade := (current_date + interval '365 days')::date,
  p_status_documento := 'Vigente',
  p_url_arquivo := 'https://storage.genius.local/unidade-agricola/doc-sub06-teste-001.pdf',
  p_storage_bucket := 'unidade-agricola-documentos',
  p_storage_path := 'PA-SUB01-TESTE-001/documentos/DOC-SUB06-TESTE-001.pdf',
  p_evidencia_descricao := 'Documento simulado para teste do backend sub06',
  p_responsavel_documento := 'Carlos Gestor Submodulo 03',
  p_observacoes := 'Documento criado pelo teste do backend sub06',
  p_origem_registro := 'teste_sql_sub06',
  p_payload_extra := jsonb_build_object('teste', true)
);

select
  codigo_unidade,
  nome_unidade,
  codigo_documento,
  nome_documento,
  tipo_documento,
  categoria_documento,
  status_documento,
  status_validade,
  possui_arquivo_evidencia,
  status_validacao,
  fractais_validados,
  total_fractais_sub06,
  pronto_para_modulos_dependentes
from unidade_agricola.vw_sub06_documentacao_operacional
where codigo_documento = 'DOC-SUB06-TESTE-001';

select
  ordem_fractal,
  fractal,
  status,
  sync_status
from unidade_agricola.vw_sub06_fractais_status_documento
where codigo_documento = 'DOC-SUB06-TESTE-001'
order by ordem_fractal;

select
  codigo_documento,
  possui_codigo_documento,
  possui_nome_documento,
  possui_tipo_documento,
  possui_unidade_vinculada,
  possui_arquivo_evidencia,
  status_validade,
  status_validacao
from unidade_agricola.vw_sub06_validacao_documentos
where codigo_documento = 'DOC-SUB06-TESTE-001';

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
and submodulo_origem = '06_sub_documentacao_unidade'
order by published_at desc
limit 12;

select
  modulo,
  submodulo,
  tipo_contrato,
  versao,
  contrato
from unidade_agricola.vw_sub06_contrato_backend;
