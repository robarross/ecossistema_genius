-- 202604260020_sub07_backend.sql
-- Camada executavel do submodulo 07_sub_base_ativos_estruturais_unidade.
-- Base cadastral para estruturas, benfeitorias, instalacoes fixas e ativos estruturais.
-- Este submodulo serve de base para o futuro Mod_Construcoes_Rurais, sem competir com ele.

create table if not exists unidade_agricola.sub07_ativos_estruturais (
  id_ativo_estrutural uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_ativo_estrutural text not null unique,
  nome_ativo_estrutural text not null,
  tipo_ativo_estrutural text not null,
  categoria_ativo text,
  codigo_area_relacionada text,
  localizacao_descritiva text,
  finalidade_uso text,
  material_predominante text,
  area_construida_m2 numeric,
  capacidade_operacional text,
  estado_conservacao text,
  prioridade_manutencao text,
  demanda_construcao_rural boolean not null default false,
  latitude_referencia numeric,
  longitude_referencia numeric,
  status_ativo text not null default 'Ativo',
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub07_ativos_estruturais is
'Tabela operacional do submodulo 07. Registra estruturas, benfeitorias, instalacoes fixas, equipamentos fixos e ativos estruturais da unidade. Serve como base para o futuro Mod_Construcoes_Rurais.';

create index if not exists idx_sub07_ativos_id_unidade
on unidade_agricola.sub07_ativos_estruturais(id_unidade_agricola);

create index if not exists idx_sub07_ativos_codigo_unidade
on unidade_agricola.sub07_ativos_estruturais(codigo_unidade);

create index if not exists idx_sub07_ativos_area
on unidade_agricola.sub07_ativos_estruturais(codigo_area_relacionada);

create index if not exists idx_sub07_ativos_tipo_status
on unidade_agricola.sub07_ativos_estruturais(tipo_ativo_estrutural, status_ativo);

create index if not exists idx_sub07_ativos_payload_gin
on unidade_agricola.sub07_ativos_estruturais using gin(payload);

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

create or replace function unidade_agricola.salvar_sub07_ativo_estrutural(
  p_codigo_unidade text,
  p_codigo_ativo_estrutural text,
  p_nome_ativo_estrutural text,
  p_tipo_ativo_estrutural text,
  p_categoria_ativo text default null,
  p_codigo_area_relacionada text default null,
  p_localizacao_descritiva text default null,
  p_finalidade_uso text default null,
  p_material_predominante text default null,
  p_area_construida_m2 numeric default null,
  p_capacidade_operacional text default null,
  p_estado_conservacao text default null,
  p_prioridade_manutencao text default null,
  p_demanda_construcao_rural boolean default false,
  p_latitude_referencia numeric default null,
  p_longitude_referencia numeric default null,
  p_status_ativo text default 'Ativo',
  p_observacoes text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_ativo_estrutural uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_ativo_estrutural text,
  nome_ativo_estrutural text,
  tipo_ativo_estrutural text,
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
  v_id_ativo uuid;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_codigo_ativo_estrutural), '') = '' then
    raise exception 'codigo_ativo_estrutural obrigatorio';
  end if;

  if coalesce(trim(p_nome_ativo_estrutural), '') = '' then
    raise exception 'nome_ativo_estrutural obrigatorio';
  end if;

  if coalesce(trim(p_tipo_ativo_estrutural), '') = '' then
    raise exception 'tipo_ativo_estrutural obrigatorio';
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
    'categoria_ativo', p_categoria_ativo,
    'codigo_area_relacionada', p_codigo_area_relacionada,
    'localizacao_descritiva', p_localizacao_descritiva,
    'finalidade_uso', p_finalidade_uso,
    'material_predominante', p_material_predominante,
    'area_construida_m2', p_area_construida_m2,
    'capacidade_operacional', p_capacidade_operacional,
    'estado_conservacao', p_estado_conservacao,
    'prioridade_manutencao', p_prioridade_manutencao,
    'demanda_construcao_rural', coalesce(p_demanda_construcao_rural, false),
    'referencia_geografica_informada', p_latitude_referencia is not null and p_longitude_referencia is not null,
    'submodulo_01_validado', true,
    'papel_no_ecossistema', 'base_para_mod_construcoes_rurais'
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub07_ativos_estruturais as ae (
    id_unidade_agricola,
    codigo_unidade,
    codigo_ativo_estrutural,
    nome_ativo_estrutural,
    tipo_ativo_estrutural,
    categoria_ativo,
    codigo_area_relacionada,
    localizacao_descritiva,
    finalidade_uso,
    material_predominante,
    area_construida_m2,
    capacidade_operacional,
    estado_conservacao,
    prioridade_manutencao,
    demanda_construcao_rural,
    latitude_referencia,
    longitude_referencia,
    status_ativo,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    upper(trim(p_codigo_ativo_estrutural)),
    trim(p_nome_ativo_estrutural),
    trim(p_tipo_ativo_estrutural),
    nullif(trim(coalesce(p_categoria_ativo, '')), ''),
    upper(nullif(trim(coalesce(p_codigo_area_relacionada, '')), '')),
    nullif(trim(coalesce(p_localizacao_descritiva, '')), ''),
    nullif(trim(coalesce(p_finalidade_uso, '')), ''),
    nullif(trim(coalesce(p_material_predominante, '')), ''),
    p_area_construida_m2,
    nullif(trim(coalesce(p_capacidade_operacional, '')), ''),
    nullif(trim(coalesce(p_estado_conservacao, '')), ''),
    nullif(trim(coalesce(p_prioridade_manutencao, '')), ''),
    coalesce(p_demanda_construcao_rural, false),
    p_latitude_referencia,
    p_longitude_referencia,
    coalesce(nullif(trim(coalesce(p_status_ativo, '')), ''), 'Ativo'),
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_ativo_estrutural) do update set
    nome_ativo_estrutural = excluded.nome_ativo_estrutural,
    tipo_ativo_estrutural = excluded.tipo_ativo_estrutural,
    categoria_ativo = excluded.categoria_ativo,
    codigo_area_relacionada = excluded.codigo_area_relacionada,
    localizacao_descritiva = excluded.localizacao_descritiva,
    finalidade_uso = excluded.finalidade_uso,
    material_predominante = excluded.material_predominante,
    area_construida_m2 = excluded.area_construida_m2,
    capacidade_operacional = excluded.capacidade_operacional,
    estado_conservacao = excluded.estado_conservacao,
    prioridade_manutencao = excluded.prioridade_manutencao,
    demanda_construcao_rural = excluded.demanda_construcao_rural,
    latitude_referencia = excluded.latitude_referencia,
    longitude_referencia = excluded.longitude_referencia,
    status_ativo = excluded.status_ativo,
    observacoes = excluded.observacoes,
    payload = ae.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning ae.id_ativo_estrutural into v_id_ativo;

  insert into unidade_agricola.fractal_estruturas_existentes (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub07:' || v_id_ativo::text,
    'validado',
    jsonb_build_object(
      'id_ativo_estrutural', v_id_ativo,
      'codigo_ativo_estrutural', upper(trim(p_codigo_ativo_estrutural)),
      'nome_ativo_estrutural', p_nome_ativo_estrutural,
      'tipo_ativo_estrutural', p_tipo_ativo_estrutural
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_estruturas_existentes.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '07_sub_base_ativos_estruturais_unidade',
    '01_fractal_estruturas_existentes',
    'validado',
    jsonb_build_object('id_ativo_estrutural', v_id_ativo)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_benfeitorias_instalacoes_fixas (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub07:' || v_id_ativo::text,
    'validado',
    jsonb_build_object(
      'id_ativo_estrutural', v_id_ativo,
      'codigo_ativo_estrutural', upper(trim(p_codigo_ativo_estrutural)),
      'categoria_ativo', p_categoria_ativo,
      'material_predominante', p_material_predominante,
      'area_construida_m2', p_area_construida_m2
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_benfeitorias_instalacoes_fixas.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '07_sub_base_ativos_estruturais_unidade',
    '02_fractal_benfeitorias_instalacoes_fixas',
    'validado',
    jsonb_build_object('id_ativo_estrutural', v_id_ativo)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_equipamentos_fixos_unidade (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub07:' || v_id_ativo::text,
    'validado',
    jsonb_build_object(
      'id_ativo_estrutural', v_id_ativo,
      'codigo_ativo_estrutural', upper(trim(p_codigo_ativo_estrutural)),
      'tipo_ativo_estrutural', p_tipo_ativo_estrutural,
      'capacidade_operacional', p_capacidade_operacional,
      'aplicavel_como_equipamento_fixo',
        coalesce(p_tipo_ativo_estrutural, '') ilike '%equip%' or
        coalesce(p_categoria_ativo, '') ilike '%equip%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_equipamentos_fixos_unidade.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '07_sub_base_ativos_estruturais_unidade',
    '03_fractal_equipamentos_fixos_unidade',
    'validado',
    jsonb_build_object('id_ativo_estrutural', v_id_ativo)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_estado_conservacao (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub07:' || v_id_ativo::text,
    'validado',
    jsonb_build_object(
      'id_ativo_estrutural', v_id_ativo,
      'codigo_ativo_estrutural', upper(trim(p_codigo_ativo_estrutural)),
      'estado_conservacao', p_estado_conservacao,
      'prioridade_manutencao', p_prioridade_manutencao,
      'status_ativo', p_status_ativo
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_estado_conservacao.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '07_sub_base_ativos_estruturais_unidade',
    '04_fractal_estado_conservacao',
    'validado',
    jsonb_build_object('id_ativo_estrutural', v_id_ativo, 'estado_conservacao', p_estado_conservacao)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_relacao_areas_uso_operacional (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub07:' || v_id_ativo::text,
    'validado',
    jsonb_build_object(
      'id_ativo_estrutural', v_id_ativo,
      'codigo_ativo_estrutural', upper(trim(p_codigo_ativo_estrutural)),
      'codigo_area_relacionada', p_codigo_area_relacionada,
      'localizacao_descritiva', p_localizacao_descritiva,
      'finalidade_uso', p_finalidade_uso
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_relacao_areas_uso_operacional.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '07_sub_base_ativos_estruturais_unidade',
    '05_fractal_relacao_areas_uso_operacional',
    'validado',
    jsonb_build_object('id_ativo_estrutural', v_id_ativo, 'codigo_area_relacionada', p_codigo_area_relacionada)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_construcoes_manutencao (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub07:' || v_id_ativo::text,
    'validado',
    jsonb_build_object(
      'id_ativo_estrutural', v_id_ativo,
      'codigo_ativo_estrutural', upper(trim(p_codigo_ativo_estrutural)),
      'demanda_construcao_rural', coalesce(p_demanda_construcao_rural, false),
      'integrar_construcoes_rurais', true,
      'integrar_manutencao', true,
      'integrar_patrimonio', true,
      'papel_no_modulo_construcoes_rurais', 'base_cadastral_do_ativo_existente',
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Construcoes_Rurais',
        'Mod_Gestao_Manutencao',
        'Mod_Gestao_Patrimonial',
        'Mod_Gestao_Georreferenciamento',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_construcoes_manutencao.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '07_sub_base_ativos_estruturais_unidade',
    '06_fractal_integracao_construcoes_manutencao',
    'validado',
    jsonb_build_object('id_ativo_estrutural', v_id_ativo, 'integrar_construcoes_rurais', true)
  );
  v_eventos := v_eventos + 1;

  return query
  select
    ae.id_ativo_estrutural,
    ae.id_unidade_agricola,
    ae.codigo_unidade,
    ae.codigo_ativo_estrutural,
    ae.nome_ativo_estrutural,
    ae.tipo_ativo_estrutural,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub07_ativos_estruturais ae
  where ae.id_ativo_estrutural = v_id_ativo;
end;
$$;

create or replace view unidade_agricola.vw_sub07_validacao_ativos_estruturais as
select
  ae.id_ativo_estrutural,
  ae.id_unidade_agricola,
  ae.codigo_unidade,
  ae.codigo_ativo_estrutural,
  ae.nome_ativo_estrutural,
  ae.tipo_ativo_estrutural,
  ae.codigo_area_relacionada,
  ae.estado_conservacao,
  ae.prioridade_manutencao,
  (coalesce(trim(ae.codigo_ativo_estrutural), '') <> '') as possui_codigo_ativo,
  (coalesce(trim(ae.nome_ativo_estrutural), '') <> '') as possui_nome_ativo,
  (coalesce(trim(coalesce(ae.tipo_ativo_estrutural, '')), '') <> '') as possui_tipo_ativo,
  (ae.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  (coalesce(trim(coalesce(ae.estado_conservacao, '')), '') <> '') as possui_estado_conservacao,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(ae.codigo_ativo_estrutural), '') = '' then 'erro'
    when coalesce(trim(ae.nome_ativo_estrutural), '') = '' then 'erro'
    when coalesce(trim(coalesce(ae.tipo_ativo_estrutural, '')), '') = '' then 'erro'
    when coalesce(trim(coalesce(ae.estado_conservacao, '')), '') = '' then 'atencao'
    else 'saudavel'
  end as status_validacao,
  ae.updated_at
from unidade_agricola.sub07_ativos_estruturais ae
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = ae.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub07_fractais_status_ativo as
select
  ae.id_ativo_estrutural,
  ae.codigo_ativo_estrutural,
  ae.codigo_unidade,
  ae.nome_ativo_estrutural,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub07_ativos_estruturais ae
cross join lateral (
  values
    (1, '01_fractal_estruturas_existentes', 'Estruturas existentes', (select f.status from unidade_agricola.fractal_estruturas_existentes f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_estruturas_existentes f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_estruturas_existentes f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_benfeitorias_instalacoes_fixas', 'Benfeitorias e instalacoes fixas', (select f.status from unidade_agricola.fractal_benfeitorias_instalacoes_fixas f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_benfeitorias_instalacoes_fixas f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_benfeitorias_instalacoes_fixas f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_equipamentos_fixos_unidade', 'Equipamentos fixos da unidade', (select f.status from unidade_agricola.fractal_equipamentos_fixos_unidade f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_equipamentos_fixos_unidade f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_equipamentos_fixos_unidade f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_estado_conservacao', 'Estado de conservacao', (select f.status from unidade_agricola.fractal_estado_conservacao f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_estado_conservacao f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_estado_conservacao f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_relacao_areas_uso_operacional', 'Relacao com areas e uso operacional', (select f.status from unidade_agricola.fractal_relacao_areas_uso_operacional f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_relacao_areas_uso_operacional f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_relacao_areas_uso_operacional f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_construcoes_manutencao', 'Integracao construcoes e manutencao', (select f.status from unidade_agricola.fractal_integracao_construcoes_manutencao f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_construcoes_manutencao f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_construcoes_manutencao f where f.id_origem = 'sub07:' || ae.id_ativo_estrutural::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub07_ativos_estruturais_operacional as
select
  ae.id_ativo_estrutural,
  ae.id_unidade_agricola,
  ae.codigo_unidade,
  u.nome_unidade,
  ae.codigo_ativo_estrutural,
  ae.nome_ativo_estrutural,
  ae.tipo_ativo_estrutural,
  ae.categoria_ativo,
  ae.codigo_area_relacionada,
  ae.localizacao_descritiva,
  ae.finalidade_uso,
  ae.area_construida_m2,
  ae.estado_conservacao,
  ae.prioridade_manutencao,
  ae.demanda_construcao_rural,
  ae.status_ativo,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub07,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  ae.sync_status,
  ae.updated_at
from unidade_agricola.sub07_ativos_estruturais ae
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = ae.id_unidade_agricola
left join unidade_agricola.vw_sub07_validacao_ativos_estruturais v
  on v.id_ativo_estrutural = ae.id_ativo_estrutural
left join unidade_agricola.vw_sub07_fractais_status_ativo fs
  on fs.id_ativo_estrutural = ae.id_ativo_estrutural
group by
  ae.id_ativo_estrutural,
  ae.id_unidade_agricola,
  ae.codigo_unidade,
  u.nome_unidade,
  ae.codigo_ativo_estrutural,
  ae.nome_ativo_estrutural,
  ae.tipo_ativo_estrutural,
  ae.categoria_ativo,
  ae.codigo_area_relacionada,
  ae.localizacao_descritiva,
  ae.finalidade_uso,
  ae.area_construida_m2,
  ae.estado_conservacao,
  ae.prioridade_manutencao,
  ae.demanda_construcao_rural,
  ae.status_ativo,
  v.status_validacao,
  ae.sync_status,
  ae.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '07_sub_base_ativos_estruturais_unidade',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'complementa', jsonb_build_array('04_sub_territorios_areas_producao', 'Mod_Construcoes_Rurais', 'Mod_Gestao_Manutencao'),
    'nao_compete_com', jsonb_build_array('Mod_Construcoes_Rurais'),
    'papel_do_submodulo', 'base_cadastral_e_operacional_dos_ativos_existentes_da_unidade',
    'papel_do_modulo_construcoes_rurais', 'projetos_obras_reformas_orcamentos_execucao_tecnica_e_engenharia',
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_ativo_estrutural', 'codigo_area_relacionada'),
    'entrada_principal', 'unidade_agricola.salvar_sub07_ativo_estrutural',
    'views_publicadas', jsonb_build_array(
      'vw_sub07_ativos_estruturais_operacional',
      'vw_sub07_fractais_status_ativo',
      'vw_sub07_validacao_ativos_estruturais'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_estruturas_existentes.validado',
      'unidade_agricola.fractal_benfeitorias_instalacoes_fixas.validado',
      'unidade_agricola.fractal_equipamentos_fixos_unidade.validado',
      'unidade_agricola.fractal_estado_conservacao.validado',
      'unidade_agricola.fractal_relacao_areas_uso_operacional.validado',
      'unidade_agricola.fractal_integracao_construcoes_manutencao.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Construcoes_Rurais',
      'Mod_Gestao_Manutencao',
      'Mod_Gestao_Patrimonial',
      'Mod_Gestao_Georreferenciamento',
      'Mod_Gestao_Genius_Hub'
    )
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub07_contrato_backend as
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
  and submodulo = '07_sub_base_ativos_estruturais_unidade'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub07_ativos_estruturais,
  unidade_agricola.vw_sub07_ativos_estruturais_operacional,
  unidade_agricola.vw_sub07_fractais_status_ativo,
  unidade_agricola.vw_sub07_validacao_ativos_estruturais,
  unidade_agricola.vw_sub07_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub07_ativo_estrutural(
  text, text, text, text, text, text, text, text, text, numeric, text, text, text, boolean, numeric, numeric, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub07_ativo_estrutural(
  text, text, text, text, text, text, text, text, text, numeric, text, text, text, boolean, numeric, numeric, text, text, text, jsonb
) to authenticated;
