-- 202604260014_sub01_cadastro_unidades_agricolas_backend.sql
-- Camada executavel do submodulo 01_sub_cadastro_unidades_agricolas.
-- Objetivo: transformar os 6 fractais do cadastro base em backend plug and play.

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

comment on table unidade_agricola.contratos_operacionais_modulo is
'Contratos plug and play de modulos, submodulos e fractais do Mod_Gestao_Unidade_Agricola.';

create unique index if not exists uq_contratos_operacionais_modulo_encaixe
on unidade_agricola.contratos_operacionais_modulo(
  modulo,
  submodulo,
  coalesce(fractal, ''),
  tipo_contrato
);

create unique index if not exists uq_fractal_dados_basicos_unidade_unidade
on unidade_agricola.fractal_dados_basicos_unidade(id_unidade_agricola)
where id_unidade_agricola is not null;

create unique index if not exists uq_fractal_localizacao_referencia_territorial_unidade
on unidade_agricola.fractal_localizacao_referencia_territorial(id_unidade_agricola)
where id_unidade_agricola is not null;

create unique index if not exists uq_fractal_classificacao_unidade_unidade
on unidade_agricola.fractal_classificacao_unidade(id_unidade_agricola)
where id_unidade_agricola is not null;

create unique index if not exists uq_fractal_situacao_cadastral_unidade
on unidade_agricola.fractal_situacao_cadastral(id_unidade_agricola)
where id_unidade_agricola is not null;

create unique index if not exists uq_fractal_validacao_campos_obrigatorios_unidade
on unidade_agricola.fractal_validacao_campos_obrigatorios(id_unidade_agricola)
where id_unidade_agricola is not null;

create unique index if not exists uq_fractal_integracao_datalake_mapas_modulos_unidade
on unidade_agricola.fractal_integracao_datalake_mapas_modulos(id_unidade_agricola)
where id_unidade_agricola is not null;

create or replace function unidade_agricola.registrar_evento_fractal(
  p_nome_evento text,
  p_id_unidade_agricola uuid,
  p_id_fractal_registro uuid,
  p_modulo_origem text,
  p_submodulo_origem text,
  p_fractal_origem text,
  p_status text,
  p_payload jsonb default '{}'::jsonb
)
returns uuid
language plpgsql
security definer
set search_path = unidade_agricola, public
as $$
declare
  v_id_evento uuid;
begin
  insert into unidade_agricola.fractal_eventos_log (
    nome_evento,
    id_unidade_agricola,
    id_fractal_registro,
    modulo_origem,
    submodulo_origem,
    fractal_origem,
    status,
    payload
  ) values (
    p_nome_evento,
    p_id_unidade_agricola,
    p_id_fractal_registro,
    p_modulo_origem,
    p_submodulo_origem,
    p_fractal_origem,
    p_status,
    coalesce(p_payload, '{}'::jsonb)
  )
  returning id_evento into v_id_evento;

  return v_id_evento;
end;
$$;

create or replace function unidade_agricola.salvar_sub01_cadastro_unidade_agricola(
  p_codigo_unidade text,
  p_nome_unidade text,
  p_tipo_unidade text default null,
  p_status_cadastro text default 'Ativo',
  p_situacao_operacional text default null,
  p_uf text default null,
  p_municipio text default null,
  p_latitude_sede numeric default null,
  p_longitude_sede numeric default null,
  p_area_total_ha numeric default null,
  p_categoria_unidade text default null,
  p_referencia_territorial text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_unidade_agricola uuid,
  codigo_unidade text,
  nome_unidade text,
  status_cadastro text,
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
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_campos_obrigatorios jsonb;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_nome_unidade), '') = '' then
    raise exception 'nome_unidade obrigatorio';
  end if;

  v_campos_obrigatorios := jsonb_build_object(
    'codigo_unidade', coalesce(trim(p_codigo_unidade), '') <> '',
    'nome_unidade', coalesce(trim(p_nome_unidade), '') <> '',
    'tipo_unidade', coalesce(trim(coalesce(p_tipo_unidade, '')), '') <> '',
    'uf', coalesce(trim(coalesce(p_uf, '')), '') <> '',
    'municipio', coalesce(trim(coalesce(p_municipio, '')), '') <> '',
    'area_total_ha', p_area_total_ha is not null and p_area_total_ha > 0
  );

  if v_campos_obrigatorios ? 'codigo_unidade'
     and v_campos_obrigatorios ? 'nome_unidade' then
    v_status_fractais := 'validado';
  end if;

  v_payload_base := jsonb_build_object(
    'origem_registro', p_origem_registro,
    'categoria_unidade', p_categoria_unidade,
    'referencia_territorial', p_referencia_territorial,
    'campos_obrigatorios', v_campos_obrigatorios
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.unidades_agricolas as ua (
    codigo_unidade,
    nome_unidade,
    tipo_unidade,
    status_cadastro,
    situacao_operacional,
    uf,
    municipio,
    latitude_sede,
    longitude_sede,
    area_total_ha,
    payload,
    sync_status
  ) values (
    upper(trim(p_codigo_unidade)),
    trim(p_nome_unidade),
    nullif(trim(coalesce(p_tipo_unidade, '')), ''),
    coalesce(nullif(trim(coalesce(p_status_cadastro, '')), ''), 'Ativo'),
    nullif(trim(coalesce(p_situacao_operacional, '')), ''),
    upper(nullif(trim(coalesce(p_uf, '')), '')),
    nullif(trim(coalesce(p_municipio, '')), ''),
    p_latitude_sede,
    p_longitude_sede,
    p_area_total_ha,
    v_payload_base,
    'validado'
  )
  on conflict on constraint unidades_agricolas_codigo_unidade_key do update set
    nome_unidade = excluded.nome_unidade,
    tipo_unidade = excluded.tipo_unidade,
    status_cadastro = excluded.status_cadastro,
    situacao_operacional = excluded.situacao_operacional,
    uf = excluded.uf,
    municipio = excluded.municipio,
    latitude_sede = excluded.latitude_sede,
    longitude_sede = excluded.longitude_sede,
    area_total_ha = excluded.area_total_ha,
    payload = ua.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning ua.id_unidade_agricola into v_id_unidade;

  insert into unidade_agricola.fractal_dados_basicos_unidade (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    p_origem_registro,
    'validado',
    jsonb_build_object(
      'codigo_unidade', upper(trim(p_codigo_unidade)),
      'nome_unidade', trim(p_nome_unidade),
      'tipo_unidade', p_tipo_unidade,
      'categoria_unidade', p_categoria_unidade
    ),
    'validado'
  )
  on conflict (id_unidade_agricola) where id_unidade_agricola is not null do update set
    id_origem = excluded.id_origem,
    status = excluded.status,
    payload = unidade_agricola.fractal_dados_basicos_unidade.payload || excluded.payload,
    sync_status = excluded.sync_status,
    updated_at = now()
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_dados_basicos_unidade.validado',
    v_id_unidade,
    v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '01_sub_cadastro_unidades_agricolas',
    '01_fractal_dados_basicos_unidade',
    'validado',
    jsonb_build_object('origem_registro', p_origem_registro)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_localizacao_referencia_territorial (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    p_origem_registro,
    'validado',
    jsonb_build_object(
      'uf', upper(nullif(trim(coalesce(p_uf, '')), '')),
      'municipio', nullif(trim(coalesce(p_municipio, '')), ''),
      'latitude_sede', p_latitude_sede,
      'longitude_sede', p_longitude_sede,
      'referencia_territorial', p_referencia_territorial
    ),
    'validado'
  )
  on conflict (id_unidade_agricola) where id_unidade_agricola is not null do update set
    id_origem = excluded.id_origem,
    status = excluded.status,
    payload = unidade_agricola.fractal_localizacao_referencia_territorial.payload || excluded.payload,
    sync_status = excluded.sync_status,
    updated_at = now()
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_localizacao_referencia_territorial.validado',
    v_id_unidade,
    v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '01_sub_cadastro_unidades_agricolas',
    '02_fractal_localizacao_referencia_territorial',
    'validado',
    jsonb_build_object('origem_registro', p_origem_registro)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_classificacao_unidade (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    p_origem_registro,
    'validado',
    jsonb_build_object(
      'tipo_unidade', p_tipo_unidade,
      'categoria_unidade', p_categoria_unidade,
      'area_total_ha', p_area_total_ha
    ),
    'validado'
  )
  on conflict (id_unidade_agricola) where id_unidade_agricola is not null do update set
    id_origem = excluded.id_origem,
    status = excluded.status,
    payload = unidade_agricola.fractal_classificacao_unidade.payload || excluded.payload,
    sync_status = excluded.sync_status,
    updated_at = now()
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_classificacao_unidade.validado',
    v_id_unidade,
    v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '01_sub_cadastro_unidades_agricolas',
    '03_fractal_classificacao_unidade',
    'validado',
    jsonb_build_object('origem_registro', p_origem_registro)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_situacao_cadastral (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    p_origem_registro,
    'validado',
    jsonb_build_object(
      'status_cadastro', coalesce(nullif(trim(coalesce(p_status_cadastro, '')), ''), 'Ativo'),
      'situacao_operacional', p_situacao_operacional,
      'sync_status', 'validado'
    ),
    'validado'
  )
  on conflict (id_unidade_agricola) where id_unidade_agricola is not null do update set
    id_origem = excluded.id_origem,
    status = excluded.status,
    payload = unidade_agricola.fractal_situacao_cadastral.payload || excluded.payload,
    sync_status = excluded.sync_status,
    updated_at = now()
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_situacao_cadastral.validado',
    v_id_unidade,
    v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '01_sub_cadastro_unidades_agricolas',
    '04_fractal_situacao_cadastral',
    'validado',
    jsonb_build_object('origem_registro', p_origem_registro)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_validacao_campos_obrigatorios (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    p_origem_registro,
    'validado',
    jsonb_build_object(
      'campos_obrigatorios', v_campos_obrigatorios,
      'apto_para_submodulos_dependentes', true
    ),
    'validado'
  )
  on conflict (id_unidade_agricola) where id_unidade_agricola is not null do update set
    id_origem = excluded.id_origem,
    status = excluded.status,
    payload = unidade_agricola.fractal_validacao_campos_obrigatorios.payload || excluded.payload,
    sync_status = excluded.sync_status,
    updated_at = now()
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_validacao_campos_obrigatorios.validado',
    v_id_unidade,
    v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '01_sub_cadastro_unidades_agricolas',
    '05_fractal_validacao_campos_obrigatorios',
    'validado',
    jsonb_build_object('campos_obrigatorios', v_campos_obrigatorios)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_datalake_mapas_modulos (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    p_origem_registro,
    'validado',
    jsonb_build_object(
      'publicar_datalake', true,
      'publicar_mapas', p_latitude_sede is not null and p_longitude_sede is not null,
      'publicar_modulos_dependentes', true,
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Gestao_Producao_Vegetal',
        'Mod_Gestao_Producao_Animal_Pecuaria',
        'Mod_Gestao_Georreferenciamento',
        'Mod_Gestao_Dashboards_BI',
        'Mod_Gestao_Dados_DataLake',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  on conflict (id_unidade_agricola) where id_unidade_agricola is not null do update set
    id_origem = excluded.id_origem,
    status = excluded.status,
    payload = unidade_agricola.fractal_integracao_datalake_mapas_modulos.payload || excluded.payload,
    sync_status = excluded.sync_status,
    updated_at = now()
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_datalake_mapas_modulos.validado',
    v_id_unidade,
    v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '01_sub_cadastro_unidades_agricolas',
    '06_fractal_integracao_datalake_mapas_modulos',
    'validado',
    jsonb_build_object('origem_registro', p_origem_registro)
  );
  v_eventos := v_eventos + 1;

  return query
  select
    u.id_unidade_agricola,
    u.codigo_unidade,
    u.nome_unidade,
    u.status_cadastro,
    v_status_fractais,
    v_eventos
  from unidade_agricola.unidades_agricolas u
  where u.id_unidade_agricola = v_id_unidade;
end;
$$;

create or replace view unidade_agricola.vw_sub01_validacao_campos_obrigatorios as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  (coalesce(trim(u.codigo_unidade), '') <> '') as possui_codigo_unidade,
  (coalesce(trim(u.nome_unidade), '') <> '') as possui_nome_unidade,
  (coalesce(trim(coalesce(u.tipo_unidade, '')), '') <> '') as possui_tipo_unidade,
  (coalesce(trim(coalesce(u.uf, '')), '') <> '') as possui_uf,
  (coalesce(trim(coalesce(u.municipio, '')), '') <> '') as possui_municipio,
  (u.area_total_ha is not null and u.area_total_ha > 0) as possui_area_total,
  case
    when coalesce(trim(u.codigo_unidade), '') = '' then 'erro'
    when coalesce(trim(u.nome_unidade), '') = '' then 'erro'
    when coalesce(trim(coalesce(u.tipo_unidade, '')), '') = '' then 'atencao'
    when coalesce(trim(coalesce(u.uf, '')), '') = '' then 'atencao'
    when coalesce(trim(coalesce(u.municipio, '')), '') = '' then 'atencao'
    when u.area_total_ha is null or u.area_total_ha <= 0 then 'atencao'
    else 'saudavel'
  end as status_validacao,
  now() as atualizado_em
from unidade_agricola.unidades_agricolas u;

create or replace view unidade_agricola.vw_sub01_fractais_status_unidade as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.unidades_agricolas u
cross join lateral (
  values
    (1, '01_fractal_dados_basicos_unidade', 'Dados basicos da unidade', (select f.status from unidade_agricola.fractal_dados_basicos_unidade f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.sync_status from unidade_agricola.fractal_dados_basicos_unidade f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.updated_at from unidade_agricola.fractal_dados_basicos_unidade f where f.id_unidade_agricola = u.id_unidade_agricola limit 1)),
    (2, '02_fractal_localizacao_referencia_territorial', 'Localizacao e referencia territorial', (select f.status from unidade_agricola.fractal_localizacao_referencia_territorial f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.sync_status from unidade_agricola.fractal_localizacao_referencia_territorial f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.updated_at from unidade_agricola.fractal_localizacao_referencia_territorial f where f.id_unidade_agricola = u.id_unidade_agricola limit 1)),
    (3, '03_fractal_classificacao_unidade', 'Classificacao da unidade', (select f.status from unidade_agricola.fractal_classificacao_unidade f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.sync_status from unidade_agricola.fractal_classificacao_unidade f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.updated_at from unidade_agricola.fractal_classificacao_unidade f where f.id_unidade_agricola = u.id_unidade_agricola limit 1)),
    (4, '04_fractal_situacao_cadastral', 'Situacao cadastral', (select f.status from unidade_agricola.fractal_situacao_cadastral f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.sync_status from unidade_agricola.fractal_situacao_cadastral f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.updated_at from unidade_agricola.fractal_situacao_cadastral f where f.id_unidade_agricola = u.id_unidade_agricola limit 1)),
    (5, '05_fractal_validacao_campos_obrigatorios', 'Validacao de campos obrigatorios', (select f.status from unidade_agricola.fractal_validacao_campos_obrigatorios f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.sync_status from unidade_agricola.fractal_validacao_campos_obrigatorios f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.updated_at from unidade_agricola.fractal_validacao_campos_obrigatorios f where f.id_unidade_agricola = u.id_unidade_agricola limit 1)),
    (6, '06_fractal_integracao_datalake_mapas_modulos', 'Integracao DataLake, mapas e modulos', (select f.status from unidade_agricola.fractal_integracao_datalake_mapas_modulos f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_datalake_mapas_modulos f where f.id_unidade_agricola = u.id_unidade_agricola limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_datalake_mapas_modulos f where f.id_unidade_agricola = u.id_unidade_agricola limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub01_cadastro_unidades_agricolas_operacional as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.tipo_unidade,
  u.status_cadastro,
  u.situacao_operacional,
  u.uf,
  u.municipio,
  u.latitude_sede,
  u.longitude_sede,
  u.area_total_ha,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub01,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_submodulos_dependentes,
  u.sync_status,
  u.updated_at
from unidade_agricola.unidades_agricolas u
left join unidade_agricola.vw_sub01_validacao_campos_obrigatorios v
  on v.id_unidade_agricola = u.id_unidade_agricola
left join unidade_agricola.vw_sub01_fractais_status_unidade fs
  on fs.id_unidade_agricola = u.id_unidade_agricola
group by
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.tipo_unidade,
  u.status_cadastro,
  u.situacao_operacional,
  u.uf,
  u.municipio,
  u.latitude_sede,
  u.longitude_sede,
  u.area_total_ha,
  v.status_validacao,
  u.sync_status,
  u.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values
(
  'Mod_Gestao_Unidade_Agricola',
  '01_sub_cadastro_unidades_agricolas',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'entrada_principal', 'unidade_agricola.salvar_sub01_cadastro_unidade_agricola',
    'views_publicadas', jsonb_build_array(
      'vw_sub01_cadastro_unidades_agricolas_operacional',
      'vw_sub01_fractais_status_unidade',
      'vw_sub01_validacao_campos_obrigatorios'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_dados_basicos_unidade.validado',
      'unidade_agricola.fractal_localizacao_referencia_territorial.validado',
      'unidade_agricola.fractal_classificacao_unidade.validado',
      'unidade_agricola.fractal_situacao_cadastral.validado',
      'unidade_agricola.fractal_validacao_campos_obrigatorios.validado',
      'unidade_agricola.fractal_integracao_datalake_mapas_modulos.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Gestao_Georreferenciamento',
      'Mod_Gestao_Dados_DataLake',
      'Mod_Gestao_Dashboards_BI',
      'Mod_Gestao_Genius_Hub',
      'Mod_Gestao_Producao_Vegetal',
      'Mod_Gestao_Producao_Animal_Pecuaria'
    )
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub01_contrato_backend as
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
  and submodulo = '01_sub_cadastro_unidades_agricolas'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.vw_sub01_cadastro_unidades_agricolas_operacional,
  unidade_agricola.vw_sub01_fractais_status_unidade,
  unidade_agricola.vw_sub01_validacao_campos_obrigatorios,
  unidade_agricola.vw_sub01_contrato_backend
to anon, authenticated;

grant select on unidade_agricola.contratos_operacionais_modulo to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub01_cadastro_unidade_agricola(
  text, text, text, text, text, text, text, numeric, numeric, numeric, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub01_cadastro_unidade_agricola(
  text, text, text, text, text, text, text, numeric, numeric, numeric, text, text, text, jsonb
) to authenticated;

revoke execute on function unidade_agricola.registrar_evento_fractal(
  text, uuid, uuid, text, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.registrar_evento_fractal(
  text, uuid, uuid, text, text, text, text, jsonb
) to authenticated;
