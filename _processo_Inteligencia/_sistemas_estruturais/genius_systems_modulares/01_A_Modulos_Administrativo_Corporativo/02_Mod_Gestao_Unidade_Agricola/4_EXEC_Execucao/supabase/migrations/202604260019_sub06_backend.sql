-- 202604260019_sub06_backend.sql
-- Camada executavel do submodulo 06_sub_documentacao_unidade.
-- Organiza documentos fundiarios, ambientais, fiscais/cadastrais, validades, evidencias e integracoes.

create table if not exists unidade_agricola.sub06_documentos_unidade (
  id_documento_unidade uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_documento text not null unique,
  nome_documento text not null,
  tipo_documento text not null,
  categoria_documento text,
  orgao_emissor text,
  numero_documento text,
  data_emissao date,
  data_validade date,
  status_documento text not null default 'Vigente',
  url_arquivo text,
  storage_bucket text,
  storage_path text,
  evidencia_descricao text,
  responsavel_documento text,
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub06_documentos_unidade is
'Tabela operacional do submodulo 06. Registra documentos fundiarios, ambientais, fiscais/cadastrais, validades, uploads e evidencias da unidade agricola.';

create index if not exists idx_sub06_docs_id_unidade
on unidade_agricola.sub06_documentos_unidade(id_unidade_agricola);

create index if not exists idx_sub06_docs_codigo_unidade
on unidade_agricola.sub06_documentos_unidade(codigo_unidade);

create index if not exists idx_sub06_docs_tipo_status
on unidade_agricola.sub06_documentos_unidade(tipo_documento, status_documento);

create index if not exists idx_sub06_docs_validade
on unidade_agricola.sub06_documentos_unidade(data_validade);

create index if not exists idx_sub06_docs_payload_gin
on unidade_agricola.sub06_documentos_unidade using gin(payload);

create table if not exists unidade_agricola.contratos_operacionais_modulo (
  id_contrato uuid primary key default gen_random_uuid(),
  modulo text not null,
  submodulo text not null,
  fractal text,
  tipo_contrato text not null,
  versao text not null default '0.1.0',
  ativo boolean not null default true,
  contrato jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists uq_contratos_operacionais_modulo_encaixe
on unidade_agricola.contratos_operacionais_modulo(
  modulo,
  submodulo,
  coalesce(fractal, ''),
  tipo_contrato
);

create or replace function unidade_agricola.salvar_sub06_documento_unidade(
  p_codigo_unidade text,
  p_codigo_documento text,
  p_nome_documento text,
  p_tipo_documento text,
  p_categoria_documento text default null,
  p_orgao_emissor text default null,
  p_numero_documento text default null,
  p_data_emissao date default null,
  p_data_validade date default null,
  p_status_documento text default 'Vigente',
  p_url_arquivo text default null,
  p_storage_bucket text default null,
  p_storage_path text default null,
  p_evidencia_descricao text default null,
  p_responsavel_documento text default null,
  p_observacoes text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_documento_unidade uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_documento text,
  nome_documento text,
  tipo_documento text,
  status_documento text,
  status_fractais text,
  eventos_publicados integer
)
language plpgsql
security definer
set search_path = unidade_agricola, public
as $$
#variable_conflict use_column
declare
  v_id_unidade uuid;
  v_codigo_unidade text;
  v_id_documento uuid;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
  v_status_validade text;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_codigo_documento), '') = '' then
    raise exception 'codigo_documento obrigatorio';
  end if;

  if coalesce(trim(p_nome_documento), '') = '' then
    raise exception 'nome_documento obrigatorio';
  end if;

  if coalesce(trim(p_tipo_documento), '') = '' then
    raise exception 'tipo_documento obrigatorio';
  end if;

  select u.id_unidade_agricola, u.codigo_unidade
    into v_id_unidade, v_codigo_unidade
  from unidade_agricola.unidades_agricolas u
  where u.codigo_unidade = upper(trim(p_codigo_unidade))
  limit 1;

  if v_id_unidade is null then
    raise exception 'codigo_unidade nao encontrado: %', p_codigo_unidade;
  end if;

  select coalesce(s1.pronto_para_submodulos_dependentes, false)
    into v_unidade_pronta
  from unidade_agricola.vw_sub01_cadastro_unidades_agricolas_operacional s1
  where s1.id_unidade_agricola = v_id_unidade
  limit 1;

  if coalesce(v_unidade_pronta, false) is not true then
    raise exception 'unidade ainda nao esta pronta no submodulo 01: %', p_codigo_unidade;
  end if;

  v_status_validade := case
    when p_data_validade is null then 'sem_validade_informada'
    when p_data_validade < current_date then 'vencido'
    when p_data_validade <= current_date + interval '30 days' then 'vence_em_30_dias'
    when p_data_validade <= current_date + interval '90 days' then 'vence_em_90_dias'
    else 'vigente'
  end;

  v_payload_base := jsonb_build_object(
    'origem_registro', p_origem_registro,
    'categoria_documento', p_categoria_documento,
    'orgao_emissor', p_orgao_emissor,
    'numero_documento', p_numero_documento,
    'data_emissao', p_data_emissao,
    'data_validade', p_data_validade,
    'status_validade', v_status_validade,
    'possui_arquivo', coalesce(trim(coalesce(p_url_arquivo, '')), '') <> '' or coalesce(trim(coalesce(p_storage_path, '')), '') <> '',
    'storage_bucket', p_storage_bucket,
    'storage_path', p_storage_path,
    'evidencia_descricao', p_evidencia_descricao,
    'responsavel_documento', p_responsavel_documento,
    'submodulo_01_validado', true
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub06_documentos_unidade as d (
    id_unidade_agricola,
    codigo_unidade,
    codigo_documento,
    nome_documento,
    tipo_documento,
    categoria_documento,
    orgao_emissor,
    numero_documento,
    data_emissao,
    data_validade,
    status_documento,
    url_arquivo,
    storage_bucket,
    storage_path,
    evidencia_descricao,
    responsavel_documento,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    upper(trim(p_codigo_documento)),
    trim(p_nome_documento),
    trim(p_tipo_documento),
    nullif(trim(coalesce(p_categoria_documento, '')), ''),
    nullif(trim(coalesce(p_orgao_emissor, '')), ''),
    nullif(trim(coalesce(p_numero_documento, '')), ''),
    p_data_emissao,
    p_data_validade,
    coalesce(nullif(trim(coalesce(p_status_documento, '')), ''), 'Vigente'),
    nullif(trim(coalesce(p_url_arquivo, '')), ''),
    nullif(trim(coalesce(p_storage_bucket, '')), ''),
    nullif(trim(coalesce(p_storage_path, '')), ''),
    nullif(trim(coalesce(p_evidencia_descricao, '')), ''),
    nullif(trim(coalesce(p_responsavel_documento, '')), ''),
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_documento) do update set
    nome_documento = excluded.nome_documento,
    tipo_documento = excluded.tipo_documento,
    categoria_documento = excluded.categoria_documento,
    orgao_emissor = excluded.orgao_emissor,
    numero_documento = excluded.numero_documento,
    data_emissao = excluded.data_emissao,
    data_validade = excluded.data_validade,
    status_documento = excluded.status_documento,
    url_arquivo = excluded.url_arquivo,
    storage_bucket = excluded.storage_bucket,
    storage_path = excluded.storage_path,
    evidencia_descricao = excluded.evidencia_descricao,
    responsavel_documento = excluded.responsavel_documento,
    observacoes = excluded.observacoes,
    payload = d.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning d.id_documento_unidade into v_id_documento;

  insert into unidade_agricola.fractal_documentos_fundiarios (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub06:' || v_id_documento::text,
    'validado',
    jsonb_build_object(
      'id_documento_unidade', v_id_documento,
      'codigo_documento', upper(trim(p_codigo_documento)),
      'tipo_documento', p_tipo_documento,
      'aplicavel_fundiario', coalesce(p_tipo_documento, '') ilike '%fundi%' or coalesce(p_categoria_documento, '') ilike '%fundi%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_documentos_fundiarios.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '06_sub_documentacao_unidade',
    '01_fractal_documentos_fundiarios',
    'validado',
    jsonb_build_object('id_documento_unidade', v_id_documento)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_documentos_ambientais (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub06:' || v_id_documento::text,
    'validado',
    jsonb_build_object(
      'id_documento_unidade', v_id_documento,
      'codigo_documento', upper(trim(p_codigo_documento)),
      'tipo_documento', p_tipo_documento,
      'aplicavel_ambiental', coalesce(p_tipo_documento, '') ilike '%ambient%' or coalesce(p_categoria_documento, '') ilike '%ambient%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_documentos_ambientais.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '06_sub_documentacao_unidade',
    '02_fractal_documentos_ambientais',
    'validado',
    jsonb_build_object('id_documento_unidade', v_id_documento)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_documentos_fiscais_cadastrais (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub06:' || v_id_documento::text,
    'validado',
    jsonb_build_object(
      'id_documento_unidade', v_id_documento,
      'codigo_documento', upper(trim(p_codigo_documento)),
      'tipo_documento', p_tipo_documento,
      'aplicavel_fiscal_cadastral',
        coalesce(p_tipo_documento, '') ilike '%fiscal%' or
        coalesce(p_tipo_documento, '') ilike '%cadastr%' or
        coalesce(p_categoria_documento, '') ilike '%fiscal%' or
        coalesce(p_categoria_documento, '') ilike '%cadastr%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_documentos_fiscais_cadastrais.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '06_sub_documentacao_unidade',
    '03_fractal_documentos_fiscais_cadastrais',
    'validado',
    jsonb_build_object('id_documento_unidade', v_id_documento)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_validades_vencimentos (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub06:' || v_id_documento::text,
    'validado',
    jsonb_build_object(
      'id_documento_unidade', v_id_documento,
      'codigo_documento', upper(trim(p_codigo_documento)),
      'data_emissao', p_data_emissao,
      'data_validade', p_data_validade,
      'status_validade', v_status_validade
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_validades_vencimentos.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '06_sub_documentacao_unidade',
    '04_fractal_validades_vencimentos',
    'validado',
    jsonb_build_object('id_documento_unidade', v_id_documento, 'status_validade', v_status_validade)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_uploads_evidencias (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub06:' || v_id_documento::text,
    'validado',
    jsonb_build_object(
      'id_documento_unidade', v_id_documento,
      'codigo_documento', upper(trim(p_codigo_documento)),
      'url_arquivo', p_url_arquivo,
      'storage_bucket', p_storage_bucket,
      'storage_path', p_storage_path,
      'evidencia_descricao', p_evidencia_descricao,
      'possui_arquivo', coalesce(trim(coalesce(p_url_arquivo, '')), '') <> '' or coalesce(trim(coalesce(p_storage_path, '')), '') <> ''
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_uploads_evidencias.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '06_sub_documentacao_unidade',
    '05_fractal_uploads_evidencias',
    'validado',
    jsonb_build_object('id_documento_unidade', v_id_documento)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_regularizacao_fiscal_storage (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub06:' || v_id_documento::text,
    'validado',
    jsonb_build_object(
      'id_documento_unidade', v_id_documento,
      'codigo_documento', upper(trim(p_codigo_documento)),
      'integrar_regularizacao_fundiaria', true,
      'integrar_fiscal_tributaria', true,
      'integrar_storage', true,
      'integrar_juridico', true,
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Gestao_Regularizacao_Fundiaria',
        'Mod_Gestao_Fiscal_Tributaria',
        'Mod_Gestao_Juridica',
        'Mod_Gestao_Documentos_Storage',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '06_sub_documentacao_unidade',
    '06_fractal_integracao_regularizacao_fiscal_storage',
    'validado',
    jsonb_build_object('id_documento_unidade', v_id_documento)
  );
  v_eventos := v_eventos + 1;

  return query
  select
    d.id_documento_unidade,
    d.id_unidade_agricola,
    d.codigo_unidade,
    d.codigo_documento,
    d.nome_documento,
    d.tipo_documento,
    d.status_documento,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub06_documentos_unidade d
  where d.id_documento_unidade = v_id_documento;
end;
$$;

create or replace view unidade_agricola.vw_sub06_validacao_documentos as
select
  d.id_documento_unidade,
  d.id_unidade_agricola,
  d.codigo_unidade,
  d.codigo_documento,
  d.nome_documento,
  d.tipo_documento,
  d.categoria_documento,
  d.data_validade,
  d.status_documento,
  (coalesce(trim(d.codigo_documento), '') <> '') as possui_codigo_documento,
  (coalesce(trim(d.nome_documento), '') <> '') as possui_nome_documento,
  (coalesce(trim(coalesce(d.tipo_documento, '')), '') <> '') as possui_tipo_documento,
  (d.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  (coalesce(trim(coalesce(d.url_arquivo, '')), '') <> '' or coalesce(trim(coalesce(d.storage_path, '')), '') <> '') as possui_arquivo_evidencia,
  case
    when d.data_validade is null then 'sem_validade_informada'
    when d.data_validade < current_date then 'vencido'
    when d.data_validade <= current_date + interval '30 days' then 'vence_em_30_dias'
    when d.data_validade <= current_date + interval '90 days' then 'vence_em_90_dias'
    else 'vigente'
  end as status_validade,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(d.codigo_documento), '') = '' then 'erro'
    when coalesce(trim(d.nome_documento), '') = '' then 'erro'
    when coalesce(trim(coalesce(d.tipo_documento, '')), '') = '' then 'erro'
    when d.data_validade is not null and d.data_validade < current_date then 'atencao'
    when coalesce(trim(coalesce(d.url_arquivo, '')), '') = '' and coalesce(trim(coalesce(d.storage_path, '')), '') = '' then 'atencao'
    else 'saudavel'
  end as status_validacao,
  d.updated_at
from unidade_agricola.sub06_documentos_unidade d
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = d.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub06_fractais_status_documento as
select
  d.id_documento_unidade,
  d.codigo_documento,
  d.codigo_unidade,
  d.nome_documento,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub06_documentos_unidade d
cross join lateral (
  values
    (1, '01_fractal_documentos_fundiarios', 'Documentos fundiarios', (select f.status from unidade_agricola.fractal_documentos_fundiarios f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_documentos_fundiarios f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_documentos_fundiarios f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_documentos_ambientais', 'Documentos ambientais', (select f.status from unidade_agricola.fractal_documentos_ambientais f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_documentos_ambientais f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_documentos_ambientais f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_documentos_fiscais_cadastrais', 'Documentos fiscais e cadastrais', (select f.status from unidade_agricola.fractal_documentos_fiscais_cadastrais f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_documentos_fiscais_cadastrais f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_documentos_fiscais_cadastrais f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_validades_vencimentos', 'Validades e vencimentos', (select f.status from unidade_agricola.fractal_validades_vencimentos f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_validades_vencimentos f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_validades_vencimentos f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_uploads_evidencias', 'Uploads e evidencias', (select f.status from unidade_agricola.fractal_uploads_evidencias f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_uploads_evidencias f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_uploads_evidencias f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_regularizacao_fiscal_storage', 'Integracao regularizacao, fiscal e storage', (select f.status from unidade_agricola.fractal_integracao_regularizacao_fiscal_storage f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_regularizacao_fiscal_storage f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_regularizacao_fiscal_storage f where f.id_origem = 'sub06:' || d.id_documento_unidade::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub06_documentacao_operacional as
select
  d.id_documento_unidade,
  d.id_unidade_agricola,
  d.codigo_unidade,
  u.nome_unidade,
  d.codigo_documento,
  d.nome_documento,
  d.tipo_documento,
  d.categoria_documento,
  d.orgao_emissor,
  d.numero_documento,
  d.data_emissao,
  d.data_validade,
  d.status_documento,
  v.status_validade,
  v.possui_arquivo_evidencia,
  d.storage_bucket,
  d.storage_path,
  d.responsavel_documento,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub06,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  d.sync_status,
  d.updated_at
from unidade_agricola.sub06_documentos_unidade d
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = d.id_unidade_agricola
left join unidade_agricola.vw_sub06_validacao_documentos v
  on v.id_documento_unidade = d.id_documento_unidade
left join unidade_agricola.vw_sub06_fractais_status_documento fs
  on fs.id_documento_unidade = d.id_documento_unidade
group by
  d.id_documento_unidade,
  d.id_unidade_agricola,
  d.codigo_unidade,
  u.nome_unidade,
  d.codigo_documento,
  d.nome_documento,
  d.tipo_documento,
  d.categoria_documento,
  d.orgao_emissor,
  d.numero_documento,
  d.data_emissao,
  d.data_validade,
  d.status_documento,
  v.status_validade,
  v.possui_arquivo_evidencia,
  d.storage_bucket,
  d.storage_path,
  d.responsavel_documento,
  v.status_validacao,
  d.sync_status,
  d.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '06_sub_documentacao_unidade',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'complementa', jsonb_build_array('Mod_Gestao_Regularizacao_Fundiaria', 'Mod_Gestao_Fiscal_Tributaria', 'Mod_Gestao_Documentos_Storage'),
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_documento', 'storage_path'),
    'entrada_principal', 'unidade_agricola.salvar_sub06_documento_unidade',
    'views_publicadas', jsonb_build_array(
      'vw_sub06_documentacao_operacional',
      'vw_sub06_fractais_status_documento',
      'vw_sub06_validacao_documentos'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_documentos_fundiarios.validado',
      'unidade_agricola.fractal_documentos_ambientais.validado',
      'unidade_agricola.fractal_documentos_fiscais_cadastrais.validado',
      'unidade_agricola.fractal_validades_vencimentos.validado',
      'unidade_agricola.fractal_uploads_evidencias.validado',
      'unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Gestao_Regularizacao_Fundiaria',
      'Mod_Gestao_Fiscal_Tributaria',
      'Mod_Gestao_Juridica',
      'Mod_Gestao_Documentos_Storage',
      'Mod_Gestao_Genius_Hub'
    )
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub06_contrato_backend as
select
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  ativo,
  contrato,
  updated_at
from unidade_agricola.contratos_operacionais_modulo
where modulo = 'Mod_Gestao_Unidade_Agricola'
  and submodulo = '06_sub_documentacao_unidade'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub06_documentos_unidade,
  unidade_agricola.vw_sub06_documentacao_operacional,
  unidade_agricola.vw_sub06_fractais_status_documento,
  unidade_agricola.vw_sub06_validacao_documentos,
  unidade_agricola.vw_sub06_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub06_documento_unidade(
  text, text, text, text, text, text, text, date, date, text, text, text, text, text, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub06_documento_unidade(
  text, text, text, text, text, text, text, date, date, text, text, text, text, text, text, text, text, jsonb
) to authenticated;
