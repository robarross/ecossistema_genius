-- 202604260005_import_planilha_validacoes_unidade_agricola.sql
-- Melhorias de validação, diagnóstico e reprocessamento para Planilha -> Supabase.

create or replace view unidade_agricola.vw_importacao_planilha_unidades_erros as
select
  id_importacao,
  lote_importacao,
  linha_origem,
  codigo_unidade,
  nome_unidade,
  status_importacao,
  mensagem_importacao,
  case
    when coalesce(trim(codigo_unidade), '') = '' then 'codigo_unidade_obrigatorio'
    when coalesce(trim(nome_unidade), '') = '' then 'nome_unidade_obrigatorio'
    when latitude_sede is not null and latitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$' then 'latitude_invalida'
    when longitude_sede is not null and longitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$' then 'longitude_invalida'
    when area_total_ha is not null and area_total_ha !~ '^[0-9]+([.,][0-9]+)?$' then 'area_total_invalida'
    when status_importacao = 'erro' then 'erro_processamento'
    else null
  end as tipo_erro,
  created_at,
  processed_at
from unidade_agricola.import_planilha_unidades_agricolas
where
  coalesce(trim(codigo_unidade), '') = ''
  or coalesce(trim(nome_unidade), '') = ''
  or (latitude_sede is not null and latitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$')
  or (longitude_sede is not null and longitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$')
  or (area_total_ha is not null and area_total_ha !~ '^[0-9]+([.,][0-9]+)?$')
  or status_importacao = 'erro';

comment on view unidade_agricola.vw_importacao_planilha_unidades_erros is
'Erros e inconsistências detectadas nos lotes de importação de unidades agrícolas.';

create or replace view unidade_agricola.vw_importacao_planilha_unidades_prevalidacao as
select
  id_importacao,
  lote_importacao,
  linha_origem,
  codigo_unidade,
  nome_unidade,
  tipo_unidade,
  status_cadastro,
  situacao_operacional,
  uf,
  municipio,
  area_total_ha,
  status_importacao,
  case
    when coalesce(trim(codigo_unidade), '') = '' then false
    when coalesce(trim(nome_unidade), '') = '' then false
    when latitude_sede is not null and latitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$' then false
    when longitude_sede is not null and longitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$' then false
    when area_total_ha is not null and area_total_ha !~ '^[0-9]+([.,][0-9]+)?$' then false
    else true
  end as apto_processamento,
  case
    when coalesce(trim(codigo_unidade), '') = '' then 'Informar codigo_unidade.'
    when coalesce(trim(nome_unidade), '') = '' then 'Informar nome_unidade.'
    when latitude_sede is not null and latitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$' then 'Latitude deve ser numérica.'
    when longitude_sede is not null and longitude_sede !~ '^-?[0-9]+([.,][0-9]+)?$' then 'Longitude deve ser numérica.'
    when area_total_ha is not null and area_total_ha !~ '^[0-9]+([.,][0-9]+)?$' then 'Área total deve ser numérica.'
    else 'OK'
  end as mensagem_prevalidacao
from unidade_agricola.import_planilha_unidades_agricolas;

comment on view unidade_agricola.vw_importacao_planilha_unidades_prevalidacao is
'Pré-validação das linhas importadas por planilha antes do processamento.';

create or replace function unidade_agricola.resetar_lote_importacao_planilha_unidades(p_lote_importacao text)
returns table (
  lote_importacao text,
  linhas_resetadas integer
)
language plpgsql
as $$
declare
  v_linhas integer;
begin
  update unidade_agricola.import_planilha_unidades_agricolas
  set
    status_importacao = 'pendente',
    mensagem_importacao = null,
    processed_at = null
  where import_planilha_unidades_agricolas.lote_importacao = p_lote_importacao;

  get diagnostics v_linhas = row_count;

  return query select p_lote_importacao, v_linhas;
end;
$$;

create or replace function unidade_agricola.limpar_lote_importacao_planilha_unidades(
  p_lote_importacao text,
  p_apenas_staging boolean default true
)
returns table (
  lote_importacao text,
  linhas_removidas integer,
  observacao text
)
language plpgsql
as $$
declare
  v_linhas integer;
begin
  if p_apenas_staging is distinct from true then
    raise exception 'Por segurança, esta função remove apenas staging. Para apagar dados oficiais, criar rotina específica auditada.';
  end if;

  delete from unidade_agricola.import_planilha_unidades_agricolas
  where import_planilha_unidades_agricolas.lote_importacao = p_lote_importacao;

  get diagnostics v_linhas = row_count;

  return query select p_lote_importacao, v_linhas, 'Linhas removidas apenas da tabela staging'::text;
end;
$$;

create or replace function unidade_agricola.prevalidar_lote_importacao_planilha_unidades(p_lote_importacao text default null)
returns table (
  lote_importacao text,
  total_linhas integer,
  total_aptas integer,
  total_com_erro integer
)
language sql
as $$
  select
    coalesce(p_lote_importacao, 'todos')::text as lote_importacao,
    count(*)::integer as total_linhas,
    count(*) filter (where apto_processamento)::integer as total_aptas,
    count(*) filter (where not apto_processamento)::integer as total_com_erro
  from unidade_agricola.vw_importacao_planilha_unidades_prevalidacao
  where p_lote_importacao is null or lote_importacao = p_lote_importacao;
$$;
