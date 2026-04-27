-- 202604260018_sub05_backend.sql
-- Camada executavel do submodulo 05_sub_limites_acessos.
-- Registra limites fisicos, acessos, estradas, ramais, porteiras, pontos criticos e circulacao.

create table if not exists unidade_agricola.sub05_limites_acessos (
  id_limite_acesso uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_limite_acesso text not null unique,
  nome_limite_acesso text not null,
  tipo_registro text not null default 'Acesso',
  categoria_acesso text,
  descricao_local text,
  codigo_area_relacionada text,
  tipo_via text,
  condicao_acesso text,
  controle_circulacao text,
  ponto_critico boolean not null default false,
  risco_observado text,
  latitude_referencia numeric,
  longitude_referencia numeric,
  status_registro text not null default 'Ativo',
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub05_limites_acessos is
'Tabela operacional do submodulo 05. Registra limites, acessos, estradas, ramais, porteiras, pontos criticos e controle de circulacao.';

create index if not exists idx_sub05_limites_id_unidade
on unidade_agricola.sub05_limites_acessos(id_unidade_agricola);

create index if not exists idx_sub05_limites_codigo_unidade
on unidade_agricola.sub05_limites_acessos(codigo_unidade);

create index if not exists idx_sub05_limites_codigo_area
on unidade_agricola.sub05_limites_acessos(codigo_area_relacionada);

create index if not exists idx_sub05_limites_tipo_status
on unidade_agricola.sub05_limites_acessos(tipo_registro, status_registro);

create index if not exists idx_sub05_limites_payload_gin
on unidade_agricola.sub05_limites_acessos using gin(payload);

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

create or replace function unidade_agricola.salvar_sub05_limite_acesso(
  p_codigo_unidade text,
  p_codigo_limite_acesso text,
  p_nome_limite_acesso text,
  p_tipo_registro text default 'Acesso',
  p_categoria_acesso text default null,
  p_descricao_local text default null,
  p_codigo_area_relacionada text default null,
  p_tipo_via text default null,
  p_condicao_acesso text default null,
  p_controle_circulacao text default null,
  p_ponto_critico boolean default false,
  p_risco_observado text default null,
  p_latitude_referencia numeric default null,
  p_longitude_referencia numeric default null,
  p_status_registro text default 'Ativo',
  p_observacoes text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_limite_acesso uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_limite_acesso text,
  nome_limite_acesso text,
  tipo_registro text,
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
  v_id_limite uuid;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_codigo_limite_acesso), '') = '' then
    raise exception 'codigo_limite_acesso obrigatorio';
  end if;

  if coalesce(trim(p_nome_limite_acesso), '') = '' then
    raise exception 'nome_limite_acesso obrigatorio';
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
    'categoria_acesso', p_categoria_acesso,
    'descricao_local', p_descricao_local,
    'codigo_area_relacionada', p_codigo_area_relacionada,
    'tipo_via', p_tipo_via,
    'condicao_acesso', p_condicao_acesso,
    'controle_circulacao', p_controle_circulacao,
    'ponto_critico', coalesce(p_ponto_critico, false),
    'risco_observado', p_risco_observado,
    'referencia_geografica_informada', p_latitude_referencia is not null and p_longitude_referencia is not null,
    'submodulo_01_validado', true
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub05_limites_acessos as la (
    id_unidade_agricola,
    codigo_unidade,
    codigo_limite_acesso,
    nome_limite_acesso,
    tipo_registro,
    categoria_acesso,
    descricao_local,
    codigo_area_relacionada,
    tipo_via,
    condicao_acesso,
    controle_circulacao,
    ponto_critico,
    risco_observado,
    latitude_referencia,
    longitude_referencia,
    status_registro,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    upper(trim(p_codigo_limite_acesso)),
    trim(p_nome_limite_acesso),
    coalesce(nullif(trim(coalesce(p_tipo_registro, '')), ''), 'Acesso'),
    nullif(trim(coalesce(p_categoria_acesso, '')), ''),
    nullif(trim(coalesce(p_descricao_local, '')), ''),
    upper(nullif(trim(coalesce(p_codigo_area_relacionada, '')), '')),
    nullif(trim(coalesce(p_tipo_via, '')), ''),
    nullif(trim(coalesce(p_condicao_acesso, '')), ''),
    nullif(trim(coalesce(p_controle_circulacao, '')), ''),
    coalesce(p_ponto_critico, false),
    nullif(trim(coalesce(p_risco_observado, '')), ''),
    p_latitude_referencia,
    p_longitude_referencia,
    coalesce(nullif(trim(coalesce(p_status_registro, '')), ''), 'Ativo'),
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_limite_acesso) do update set
    nome_limite_acesso = excluded.nome_limite_acesso,
    tipo_registro = excluded.tipo_registro,
    categoria_acesso = excluded.categoria_acesso,
    descricao_local = excluded.descricao_local,
    codigo_area_relacionada = excluded.codigo_area_relacionada,
    tipo_via = excluded.tipo_via,
    condicao_acesso = excluded.condicao_acesso,
    controle_circulacao = excluded.controle_circulacao,
    ponto_critico = excluded.ponto_critico,
    risco_observado = excluded.risco_observado,
    latitude_referencia = excluded.latitude_referencia,
    longitude_referencia = excluded.longitude_referencia,
    status_registro = excluded.status_registro,
    observacoes = excluded.observacoes,
    payload = la.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning la.id_limite_acesso into v_id_limite;

  insert into unidade_agricola.fractal_limites_fisicos_unidade (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub05:' || v_id_limite::text,
    'validado',
    jsonb_build_object(
      'id_limite_acesso', v_id_limite,
      'codigo_limite_acesso', upper(trim(p_codigo_limite_acesso)),
      'tipo_registro', p_tipo_registro,
      'aplicavel_como_limite', coalesce(p_tipo_registro, '') ilike '%limit%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_limites_fisicos_unidade.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '05_sub_limites_acessos',
    '01_fractal_limites_fisicos_unidade',
    'validado',
    jsonb_build_object('id_limite_acesso', v_id_limite)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_acessos_internos_externos (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub05:' || v_id_limite::text,
    'validado',
    jsonb_build_object(
      'id_limite_acesso', v_id_limite,
      'codigo_limite_acesso', upper(trim(p_codigo_limite_acesso)),
      'categoria_acesso', p_categoria_acesso,
      'descricao_local', p_descricao_local
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_acessos_internos_externos.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '05_sub_limites_acessos',
    '02_fractal_acessos_internos_externos',
    'validado',
    jsonb_build_object('id_limite_acesso', v_id_limite, 'categoria_acesso', p_categoria_acesso)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_estradas_ramais_porteiras (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub05:' || v_id_limite::text,
    'validado',
    jsonb_build_object(
      'id_limite_acesso', v_id_limite,
      'codigo_limite_acesso', upper(trim(p_codigo_limite_acesso)),
      'tipo_via', p_tipo_via,
      'condicao_acesso', p_condicao_acesso,
      'aplicavel_como_via_ou_porteira',
        coalesce(p_tipo_registro, '') ilike '%estrada%' or
        coalesce(p_tipo_registro, '') ilike '%ramal%' or
        coalesce(p_tipo_registro, '') ilike '%porteira%' or
        coalesce(p_tipo_via, '') <> ''
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_estradas_ramais_porteiras.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '05_sub_limites_acessos',
    '03_fractal_estradas_ramais_porteiras',
    'validado',
    jsonb_build_object('id_limite_acesso', v_id_limite, 'tipo_via', p_tipo_via)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_pontos_criticos_acesso (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub05:' || v_id_limite::text,
    'validado',
    jsonb_build_object(
      'id_limite_acesso', v_id_limite,
      'codigo_limite_acesso', upper(trim(p_codigo_limite_acesso)),
      'ponto_critico', coalesce(p_ponto_critico, false),
      'risco_observado', p_risco_observado,
      'condicao_acesso', p_condicao_acesso
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_pontos_criticos_acesso.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '05_sub_limites_acessos',
    '04_fractal_pontos_criticos_acesso',
    'validado',
    jsonb_build_object('id_limite_acesso', v_id_limite, 'ponto_critico', coalesce(p_ponto_critico, false))
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_controle_circulacao (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub05:' || v_id_limite::text,
    'validado',
    jsonb_build_object(
      'id_limite_acesso', v_id_limite,
      'codigo_limite_acesso', upper(trim(p_codigo_limite_acesso)),
      'controle_circulacao', p_controle_circulacao,
      'status_registro', p_status_registro
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_controle_circulacao.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '05_sub_limites_acessos',
    '05_fractal_controle_circulacao',
    'validado',
    jsonb_build_object('id_limite_acesso', v_id_limite, 'controle_circulacao', p_controle_circulacao)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_seguranca_logistica_manutencao (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub05:' || v_id_limite::text,
    'validado',
    jsonb_build_object(
      'id_limite_acesso', v_id_limite,
      'codigo_limite_acesso', upper(trim(p_codigo_limite_acesso)),
      'integrar_seguranca', true,
      'integrar_logistica', true,
      'integrar_manutencao', true,
      'integrar_georreferenciamento', true,
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Gestao_Seguranca_Patrimonial',
        'Mod_Gestao_Logistica',
        'Mod_Gestao_Manutencao',
        'Mod_Gestao_Georreferenciamento',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '05_sub_limites_acessos',
    '06_fractal_integracao_seguranca_logistica_manutencao',
    'validado',
    jsonb_build_object('id_limite_acesso', v_id_limite)
  );
  v_eventos := v_eventos + 1;

  return query
  select
    la.id_limite_acesso,
    la.id_unidade_agricola,
    la.codigo_unidade,
    la.codigo_limite_acesso,
    la.nome_limite_acesso,
    la.tipo_registro,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub05_limites_acessos la
  where la.id_limite_acesso = v_id_limite;
end;
$$;

create or replace view unidade_agricola.vw_sub05_validacao_limites_acessos as
select
  la.id_limite_acesso,
  la.id_unidade_agricola,
  la.codigo_unidade,
  la.codigo_limite_acesso,
  la.nome_limite_acesso,
  la.tipo_registro,
  la.categoria_acesso,
  la.condicao_acesso,
  la.controle_circulacao,
  (coalesce(trim(la.codigo_limite_acesso), '') <> '') as possui_codigo_limite_acesso,
  (coalesce(trim(la.nome_limite_acesso), '') <> '') as possui_nome_limite_acesso,
  (la.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  (coalesce(trim(coalesce(la.tipo_registro, '')), '') <> '') as possui_tipo_registro,
  (coalesce(trim(coalesce(la.condicao_acesso, '')), '') <> '') as possui_condicao_acesso,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(la.codigo_limite_acesso), '') = '' then 'erro'
    when coalesce(trim(la.nome_limite_acesso), '') = '' then 'erro'
    when coalesce(trim(coalesce(la.tipo_registro, '')), '') = '' then 'atencao'
    when coalesce(trim(coalesce(la.condicao_acesso, '')), '') = '' then 'atencao'
    else 'saudavel'
  end as status_validacao,
  la.updated_at
from unidade_agricola.sub05_limites_acessos la
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = la.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub05_fractais_status_limite_acesso as
select
  la.id_limite_acesso,
  la.codigo_limite_acesso,
  la.codigo_unidade,
  la.nome_limite_acesso,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub05_limites_acessos la
cross join lateral (
  values
    (1, '01_fractal_limites_fisicos_unidade', 'Limites fisicos da unidade', (select f.status from unidade_agricola.fractal_limites_fisicos_unidade f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_limites_fisicos_unidade f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_limites_fisicos_unidade f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_acessos_internos_externos', 'Acessos internos e externos', (select f.status from unidade_agricola.fractal_acessos_internos_externos f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_acessos_internos_externos f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_acessos_internos_externos f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_estradas_ramais_porteiras', 'Estradas, ramais e porteiras', (select f.status from unidade_agricola.fractal_estradas_ramais_porteiras f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_estradas_ramais_porteiras f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_estradas_ramais_porteiras f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_pontos_criticos_acesso', 'Pontos criticos de acesso', (select f.status from unidade_agricola.fractal_pontos_criticos_acesso f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_pontos_criticos_acesso f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_pontos_criticos_acesso f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_controle_circulacao', 'Controle de circulacao', (select f.status from unidade_agricola.fractal_controle_circulacao f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_controle_circulacao f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_controle_circulacao f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_seguranca_logistica_manutencao', 'Integracao seguranca, logistica e manutencao', (select f.status from unidade_agricola.fractal_integracao_seguranca_logistica_manutencao f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_seguranca_logistica_manutencao f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_seguranca_logistica_manutencao f where f.id_origem = 'sub05:' || la.id_limite_acesso::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub05_limites_acessos_operacional as
select
  la.id_limite_acesso,
  la.id_unidade_agricola,
  la.codigo_unidade,
  u.nome_unidade,
  la.codigo_limite_acesso,
  la.nome_limite_acesso,
  la.tipo_registro,
  la.categoria_acesso,
  la.descricao_local,
  la.codigo_area_relacionada,
  la.tipo_via,
  la.condicao_acesso,
  la.controle_circulacao,
  la.ponto_critico,
  la.risco_observado,
  la.latitude_referencia,
  la.longitude_referencia,
  la.status_registro,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub05,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  la.sync_status,
  la.updated_at
from unidade_agricola.sub05_limites_acessos la
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = la.id_unidade_agricola
left join unidade_agricola.vw_sub05_validacao_limites_acessos v
  on v.id_limite_acesso = la.id_limite_acesso
left join unidade_agricola.vw_sub05_fractais_status_limite_acesso fs
  on fs.id_limite_acesso = la.id_limite_acesso
group by
  la.id_limite_acesso,
  la.id_unidade_agricola,
  la.codigo_unidade,
  u.nome_unidade,
  la.codigo_limite_acesso,
  la.nome_limite_acesso,
  la.tipo_registro,
  la.categoria_acesso,
  la.descricao_local,
  la.codigo_area_relacionada,
  la.tipo_via,
  la.condicao_acesso,
  la.controle_circulacao,
  la.ponto_critico,
  la.risco_observado,
  la.latitude_referencia,
  la.longitude_referencia,
  la.status_registro,
  v.status_validacao,
  la.sync_status,
  la.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '05_sub_limites_acessos',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'complementa', jsonb_build_array('04_sub_territorios_areas_producao', 'Mod_Gestao_Georreferenciamento'),
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_limite_acesso', 'codigo_area_relacionada'),
    'entrada_principal', 'unidade_agricola.salvar_sub05_limite_acesso',
    'views_publicadas', jsonb_build_array(
      'vw_sub05_limites_acessos_operacional',
      'vw_sub05_fractais_status_limite_acesso',
      'vw_sub05_validacao_limites_acessos'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_limites_fisicos_unidade.validado',
      'unidade_agricola.fractal_acessos_internos_externos.validado',
      'unidade_agricola.fractal_estradas_ramais_porteiras.validado',
      'unidade_agricola.fractal_pontos_criticos_acesso.validado',
      'unidade_agricola.fractal_controle_circulacao.validado',
      'unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Gestao_Seguranca_Patrimonial',
      'Mod_Gestao_Logistica',
      'Mod_Gestao_Manutencao',
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

create or replace view unidade_agricola.vw_sub05_contrato_backend as
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
  and submodulo = '05_sub_limites_acessos'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub05_limites_acessos,
  unidade_agricola.vw_sub05_limites_acessos_operacional,
  unidade_agricola.vw_sub05_fractais_status_limite_acesso,
  unidade_agricola.vw_sub05_validacao_limites_acessos,
  unidade_agricola.vw_sub05_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub05_limite_acesso(
  text, text, text, text, text, text, text, text, text, text, boolean, text, numeric, numeric, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub05_limite_acesso(
  text, text, text, text, text, text, text, text, text, text, boolean, text, numeric, numeric, text, text, text, jsonb
) to authenticated;
