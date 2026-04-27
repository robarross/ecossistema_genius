-- 202604260017_sub04_backend.sql
-- Camada executavel do submodulo 04_sub_territorios_areas_producao.
-- Estrutura areas, glebas, talhoes, usos produtivos e conexao com georreferenciamento/producao.

create table if not exists unidade_agricola.sub04_territorios_areas_producao (
  id_area_producao uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_area text not null unique,
  nome_area text not null,
  tipo_area text,
  codigo_area_pai text,
  nome_area_pai text,
  area_ha numeric,
  uso_atual text,
  cultura_atividade text,
  potencial_produtivo text,
  latitude_centroide numeric,
  longitude_centroide numeric,
  status_area text not null default 'Ativa',
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub04_territorios_areas_producao is
'Tabela operacional do submodulo 04. Registra areas produtivas, glebas, talhoes, usos atuais e potencial produtivo da unidade agricola.';

create index if not exists idx_sub04_areas_id_unidade
on unidade_agricola.sub04_territorios_areas_producao(id_unidade_agricola);

create index if not exists idx_sub04_areas_codigo_unidade
on unidade_agricola.sub04_territorios_areas_producao(codigo_unidade);

create index if not exists idx_sub04_areas_codigo_area_pai
on unidade_agricola.sub04_territorios_areas_producao(codigo_area_pai);

create index if not exists idx_sub04_areas_status
on unidade_agricola.sub04_territorios_areas_producao(status_area);

create index if not exists idx_sub04_areas_payload_gin
on unidade_agricola.sub04_territorios_areas_producao using gin(payload);

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

create or replace function unidade_agricola.salvar_sub04_area_producao(
  p_codigo_unidade text,
  p_codigo_area text,
  p_nome_area text,
  p_tipo_area text default 'Area produtiva',
  p_codigo_area_pai text default null,
  p_nome_area_pai text default null,
  p_area_ha numeric default null,
  p_uso_atual text default null,
  p_cultura_atividade text default null,
  p_potencial_produtivo text default null,
  p_latitude_centroide numeric default null,
  p_longitude_centroide numeric default null,
  p_status_area text default 'Ativa',
  p_observacoes text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_area_producao uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_area text,
  nome_area text,
  tipo_area text,
  area_ha numeric,
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
  v_id_area uuid;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_codigo_area), '') = '' then
    raise exception 'codigo_area obrigatorio';
  end if;

  if coalesce(trim(p_nome_area), '') = '' then
    raise exception 'nome_area obrigatorio';
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

  v_payload_base := jsonb_build_object(
    'origem_registro', p_origem_registro,
    'codigo_area_pai', p_codigo_area_pai,
    'nome_area_pai', p_nome_area_pai,
    'uso_atual', p_uso_atual,
    'cultura_atividade', p_cultura_atividade,
    'potencial_produtivo', p_potencial_produtivo,
    'centroide_informado', p_latitude_centroide is not null and p_longitude_centroide is not null,
    'submodulo_01_validado', true
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub04_territorios_areas_producao as a (
    id_unidade_agricola,
    codigo_unidade,
    codigo_area,
    nome_area,
    tipo_area,
    codigo_area_pai,
    nome_area_pai,
    area_ha,
    uso_atual,
    cultura_atividade,
    potencial_produtivo,
    latitude_centroide,
    longitude_centroide,
    status_area,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    upper(trim(p_codigo_area)),
    trim(p_nome_area),
    nullif(trim(coalesce(p_tipo_area, '')), ''),
    upper(nullif(trim(coalesce(p_codigo_area_pai, '')), '')),
    nullif(trim(coalesce(p_nome_area_pai, '')), ''),
    p_area_ha,
    nullif(trim(coalesce(p_uso_atual, '')), ''),
    nullif(trim(coalesce(p_cultura_atividade, '')), ''),
    nullif(trim(coalesce(p_potencial_produtivo, '')), ''),
    p_latitude_centroide,
    p_longitude_centroide,
    coalesce(nullif(trim(coalesce(p_status_area, '')), ''), 'Ativa'),
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_area) do update set
    nome_area = excluded.nome_area,
    tipo_area = excluded.tipo_area,
    codigo_area_pai = excluded.codigo_area_pai,
    nome_area_pai = excluded.nome_area_pai,
    area_ha = excluded.area_ha,
    uso_atual = excluded.uso_atual,
    cultura_atividade = excluded.cultura_atividade,
    potencial_produtivo = excluded.potencial_produtivo,
    latitude_centroide = excluded.latitude_centroide,
    longitude_centroide = excluded.longitude_centroide,
    status_area = excluded.status_area,
    observacoes = excluded.observacoes,
    payload = a.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning a.id_area_producao into v_id_area;

  insert into unidade_agricola.fractal_areas_produtivas (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub04:' || v_id_area::text,
    'validado',
    jsonb_build_object(
      'id_area_producao', v_id_area,
      'codigo_area', upper(trim(p_codigo_area)),
      'nome_area', p_nome_area,
      'area_ha', p_area_ha
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_areas_produtivas.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '04_sub_territorios_areas_producao',
    '01_fractal_areas_produtivas',
    'validado',
    jsonb_build_object('id_area_producao', v_id_area, 'codigo_area', upper(trim(p_codigo_area)))
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_glebas_talhoes (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub04:' || v_id_area::text,
    'validado',
    jsonb_build_object(
      'id_area_producao', v_id_area,
      'codigo_area', upper(trim(p_codigo_area)),
      'tipo_area', p_tipo_area,
      'codigo_area_pai', p_codigo_area_pai,
      'nome_area_pai', p_nome_area_pai,
      'aplicavel_como_gleba_talhao', coalesce(p_tipo_area, '') ilike '%gleba%' or coalesce(p_tipo_area, '') ilike '%talh%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_glebas_talhoes.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '04_sub_territorios_areas_producao',
    '02_fractal_glebas_talhoes',
    'validado',
    jsonb_build_object('id_area_producao', v_id_area, 'tipo_area', p_tipo_area)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_uso_atual_area (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub04:' || v_id_area::text,
    'validado',
    jsonb_build_object(
      'id_area_producao', v_id_area,
      'codigo_area', upper(trim(p_codigo_area)),
      'uso_atual', p_uso_atual,
      'cultura_atividade', p_cultura_atividade,
      'status_area', p_status_area
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_uso_atual_area.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '04_sub_territorios_areas_producao',
    '03_fractal_uso_atual_area',
    'validado',
    jsonb_build_object('id_area_producao', v_id_area, 'uso_atual', p_uso_atual)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_potencial_produtivo (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub04:' || v_id_area::text,
    'validado',
    jsonb_build_object(
      'id_area_producao', v_id_area,
      'codigo_area', upper(trim(p_codigo_area)),
      'area_ha', p_area_ha,
      'potencial_produtivo', p_potencial_produtivo,
      'cultura_atividade', p_cultura_atividade
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_potencial_produtivo.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '04_sub_territorios_areas_producao',
    '04_fractal_potencial_produtivo',
    'validado',
    jsonb_build_object('id_area_producao', v_id_area, 'potencial_produtivo', p_potencial_produtivo)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_historico_ocupacao_uso (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub04:' || v_id_area::text,
    'validado',
    jsonb_build_object(
      'id_area_producao', v_id_area,
      'codigo_area', upper(trim(p_codigo_area)),
      'acao', 'cadastro_ou_atualizacao_area_producao',
      'uso_atual', p_uso_atual,
      'registrado_em', now(),
      'origem_registro', p_origem_registro
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_historico_ocupacao_uso.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '04_sub_territorios_areas_producao',
    '05_fractal_historico_ocupacao_uso',
    'validado',
    jsonb_build_object('id_area_producao', v_id_area, 'acao', 'cadastro_ou_atualizacao_area_producao')
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_producao_geo_precisao (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub04:' || v_id_area::text,
    'validado',
    jsonb_build_object(
      'id_area_producao', v_id_area,
      'codigo_area', upper(trim(p_codigo_area)),
      'integrar_producao_vegetal', true,
      'integrar_producao_animal', true,
      'integrar_georreferenciamento', true,
      'integrar_agricultura_precisao', true,
      'centroide_informado', p_latitude_centroide is not null and p_longitude_centroide is not null,
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Gestao_Producao_Vegetal',
        'Mod_Gestao_Producao_Animal_Pecuaria',
        'Mod_Gestao_Georreferenciamento',
        'Mod_Gestao_Agricultura_Precisao',
        'Mod_Gestao_Dashboards_BI',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_producao_geo_precisao.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '04_sub_territorios_areas_producao',
    '06_fractal_integracao_producao_geo_precisao',
    'validado',
    jsonb_build_object('id_area_producao', v_id_area, 'codigo_area', upper(trim(p_codigo_area)))
  );
  v_eventos := v_eventos + 1;

  return query
  select
    a.id_area_producao,
    a.id_unidade_agricola,
    a.codigo_unidade,
    a.codigo_area,
    a.nome_area,
    a.tipo_area,
    a.area_ha,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub04_territorios_areas_producao a
  where a.id_area_producao = v_id_area;
end;
$$;

create or replace view unidade_agricola.vw_sub04_validacao_areas_producao as
select
  a.id_area_producao,
  a.id_unidade_agricola,
  a.codigo_unidade,
  a.codigo_area,
  a.nome_area,
  a.tipo_area,
  a.area_ha,
  a.uso_atual,
  a.cultura_atividade,
  (coalesce(trim(a.codigo_area), '') <> '') as possui_codigo_area,
  (coalesce(trim(a.nome_area), '') <> '') as possui_nome_area,
  (a.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  (a.area_ha is not null and a.area_ha > 0) as possui_area_valida,
  (coalesce(trim(coalesce(a.uso_atual, '')), '') <> '') as possui_uso_atual,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(a.codigo_area), '') = '' then 'erro'
    when coalesce(trim(a.nome_area), '') = '' then 'erro'
    when a.area_ha is null or a.area_ha <= 0 then 'atencao'
    when coalesce(trim(coalesce(a.uso_atual, '')), '') = '' then 'atencao'
    else 'saudavel'
  end as status_validacao,
  a.updated_at
from unidade_agricola.sub04_territorios_areas_producao a
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = a.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub04_fractais_status_area as
select
  a.id_area_producao,
  a.codigo_area,
  a.codigo_unidade,
  a.nome_area,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub04_territorios_areas_producao a
cross join lateral (
  values
    (1, '01_fractal_areas_produtivas', 'Areas produtivas', (select f.status from unidade_agricola.fractal_areas_produtivas f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_areas_produtivas f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_areas_produtivas f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_glebas_talhoes', 'Glebas e talhoes', (select f.status from unidade_agricola.fractal_glebas_talhoes f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_glebas_talhoes f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_glebas_talhoes f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_uso_atual_area', 'Uso atual da area', (select f.status from unidade_agricola.fractal_uso_atual_area f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_uso_atual_area f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_uso_atual_area f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_potencial_produtivo', 'Potencial produtivo', (select f.status from unidade_agricola.fractal_potencial_produtivo f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_potencial_produtivo f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_potencial_produtivo f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_historico_ocupacao_uso', 'Historico de ocupacao e uso', (select f.status from unidade_agricola.fractal_historico_ocupacao_uso f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_historico_ocupacao_uso f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_historico_ocupacao_uso f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_producao_geo_precisao', 'Integracao producao, geo e precisao', (select f.status from unidade_agricola.fractal_integracao_producao_geo_precisao f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_producao_geo_precisao f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_producao_geo_precisao f where f.id_origem = 'sub04:' || a.id_area_producao::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub04_territorios_areas_operacional as
select
  a.id_area_producao,
  a.id_unidade_agricola,
  a.codigo_unidade,
  u.nome_unidade,
  a.codigo_area,
  a.nome_area,
  a.tipo_area,
  a.codigo_area_pai,
  a.nome_area_pai,
  a.area_ha,
  a.uso_atual,
  a.cultura_atividade,
  a.potencial_produtivo,
  a.latitude_centroide,
  a.longitude_centroide,
  a.status_area,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub04,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  a.sync_status,
  a.updated_at
from unidade_agricola.sub04_territorios_areas_producao a
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = a.id_unidade_agricola
left join unidade_agricola.vw_sub04_validacao_areas_producao v
  on v.id_area_producao = a.id_area_producao
left join unidade_agricola.vw_sub04_fractais_status_area fs
  on fs.id_area_producao = a.id_area_producao
group by
  a.id_area_producao,
  a.id_unidade_agricola,
  a.codigo_unidade,
  u.nome_unidade,
  a.codigo_area,
  a.nome_area,
  a.tipo_area,
  a.codigo_area_pai,
  a.nome_area_pai,
  a.area_ha,
  a.uso_atual,
  a.cultura_atividade,
  a.potencial_produtivo,
  a.latitude_centroide,
  a.longitude_centroide,
  a.status_area,
  v.status_validacao,
  a.sync_status,
  a.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '04_sub_territorios_areas_producao',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'complementa', jsonb_build_array('Mod_Gestao_Producao_Vegetal', 'Mod_Gestao_Georreferenciamento'),
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_area', 'codigo_area_pai'),
    'entrada_principal', 'unidade_agricola.salvar_sub04_area_producao',
    'views_publicadas', jsonb_build_array(
      'vw_sub04_territorios_areas_operacional',
      'vw_sub04_fractais_status_area',
      'vw_sub04_validacao_areas_producao'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_areas_produtivas.validado',
      'unidade_agricola.fractal_glebas_talhoes.validado',
      'unidade_agricola.fractal_uso_atual_area.validado',
      'unidade_agricola.fractal_potencial_produtivo.validado',
      'unidade_agricola.fractal_historico_ocupacao_uso.validado',
      'unidade_agricola.fractal_integracao_producao_geo_precisao.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Gestao_Producao_Vegetal',
      'Mod_Gestao_Producao_Animal_Pecuaria',
      'Mod_Gestao_Georreferenciamento',
      'Mod_Gestao_Agricultura_Precisao',
      'Mod_Gestao_Dashboards_BI',
      'Mod_Gestao_Genius_Hub'
    )
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub04_contrato_backend as
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
  and submodulo = '04_sub_territorios_areas_producao'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub04_territorios_areas_producao,
  unidade_agricola.vw_sub04_territorios_areas_operacional,
  unidade_agricola.vw_sub04_fractais_status_area,
  unidade_agricola.vw_sub04_validacao_areas_producao,
  unidade_agricola.vw_sub04_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub04_area_producao(
  text, text, text, text, text, text, numeric, text, text, text, numeric, numeric, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub04_area_producao(
  text, text, text, text, text, text, numeric, text, text, text, numeric, numeric, text, text, text, jsonb
) to authenticated;
