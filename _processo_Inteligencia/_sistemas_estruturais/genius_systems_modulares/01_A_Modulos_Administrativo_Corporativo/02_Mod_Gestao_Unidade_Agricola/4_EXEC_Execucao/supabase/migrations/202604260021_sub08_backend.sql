-- 202604260021_sub08_backend.sql
-- Camada executavel do submodulo 08_sub_chaves_permissoes_operacionais.
-- Controla chaves fisicas, acessos digitais, perfis, autorizacoes, historico e integracao com seguranca/cowork/workspace.

create table if not exists unidade_agricola.sub08_chaves_permissoes_operacionais (
  id_chave_permissao uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_chave_permissao text not null unique,
  nome_chave_permissao text not null,
  tipo_acesso text not null,
  categoria_acesso text,
  codigo_responsavel text,
  codigo_titular text,
  codigo_area_relacionada text,
  codigo_ativo_estrutural text,
  recurso_controlado text,
  perfil_operacional text,
  nivel_permissao text,
  forma_credencial text,
  validade_inicio date,
  validade_fim date,
  status_permissao text not null default 'Ativa',
  historico_acao text,
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub08_chaves_permissoes_operacionais is
'Tabela operacional do submodulo 08. Registra chaves fisicas, acessos digitais, perfis operacionais, autorizacoes por area ou funcao e historico de acesso da unidade agricola.';

create index if not exists idx_sub08_chaves_permissoes_unidade
on unidade_agricola.sub08_chaves_permissoes_operacionais(id_unidade_agricola);

create index if not exists idx_sub08_chaves_permissoes_codigo_unidade
on unidade_agricola.sub08_chaves_permissoes_operacionais(codigo_unidade);

create index if not exists idx_sub08_chaves_permissoes_responsavel
on unidade_agricola.sub08_chaves_permissoes_operacionais(codigo_responsavel);

create index if not exists idx_sub08_chaves_permissoes_area_ativo
on unidade_agricola.sub08_chaves_permissoes_operacionais(codigo_area_relacionada, codigo_ativo_estrutural);

create index if not exists idx_sub08_chaves_permissoes_payload_gin
on unidade_agricola.sub08_chaves_permissoes_operacionais using gin(payload);

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

create or replace function unidade_agricola.salvar_sub08_chave_permissao_operacional(
  p_codigo_unidade text,
  p_codigo_chave_permissao text,
  p_nome_chave_permissao text,
  p_tipo_acesso text,
  p_categoria_acesso text default null,
  p_codigo_responsavel text default null,
  p_codigo_titular text default null,
  p_codigo_area_relacionada text default null,
  p_codigo_ativo_estrutural text default null,
  p_recurso_controlado text default null,
  p_perfil_operacional text default null,
  p_nivel_permissao text default null,
  p_forma_credencial text default null,
  p_validade_inicio date default null,
  p_validade_fim date default null,
  p_status_permissao text default 'Ativa',
  p_historico_acao text default null,
  p_observacoes text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_chave_permissao uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_chave_permissao text,
  nome_chave_permissao text,
  tipo_acesso text,
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
  v_id_chave uuid;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_codigo_chave_permissao), '') = '' then
    raise exception 'codigo_chave_permissao obrigatorio';
  end if;

  if coalesce(trim(p_nome_chave_permissao), '') = '' then
    raise exception 'nome_chave_permissao obrigatorio';
  end if;

  if coalesce(trim(p_tipo_acesso), '') = '' then
    raise exception 'tipo_acesso obrigatorio';
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
    'codigo_responsavel', p_codigo_responsavel,
    'codigo_titular', p_codigo_titular,
    'codigo_area_relacionada', p_codigo_area_relacionada,
    'codigo_ativo_estrutural', p_codigo_ativo_estrutural,
    'recurso_controlado', p_recurso_controlado,
    'perfil_operacional', p_perfil_operacional,
    'nivel_permissao', p_nivel_permissao,
    'forma_credencial', p_forma_credencial,
    'validade_inicio', p_validade_inicio,
    'validade_fim', p_validade_fim,
    'status_permissao', p_status_permissao,
    'integrar_seguranca_cowork_workspace', true,
    'submodulo_01_validado', true
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub08_chaves_permissoes_operacionais as cp (
    id_unidade_agricola,
    codigo_unidade,
    codigo_chave_permissao,
    nome_chave_permissao,
    tipo_acesso,
    categoria_acesso,
    codigo_responsavel,
    codigo_titular,
    codigo_area_relacionada,
    codigo_ativo_estrutural,
    recurso_controlado,
    perfil_operacional,
    nivel_permissao,
    forma_credencial,
    validade_inicio,
    validade_fim,
    status_permissao,
    historico_acao,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    upper(trim(p_codigo_chave_permissao)),
    trim(p_nome_chave_permissao),
    trim(p_tipo_acesso),
    nullif(trim(coalesce(p_categoria_acesso, '')), ''),
    upper(nullif(trim(coalesce(p_codigo_responsavel, '')), '')),
    upper(nullif(trim(coalesce(p_codigo_titular, '')), '')),
    upper(nullif(trim(coalesce(p_codigo_area_relacionada, '')), '')),
    upper(nullif(trim(coalesce(p_codigo_ativo_estrutural, '')), '')),
    nullif(trim(coalesce(p_recurso_controlado, '')), ''),
    nullif(trim(coalesce(p_perfil_operacional, '')), ''),
    nullif(trim(coalesce(p_nivel_permissao, '')), ''),
    nullif(trim(coalesce(p_forma_credencial, '')), ''),
    p_validade_inicio,
    p_validade_fim,
    coalesce(nullif(trim(coalesce(p_status_permissao, '')), ''), 'Ativa'),
    nullif(trim(coalesce(p_historico_acao, '')), ''),
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_chave_permissao) do update set
    nome_chave_permissao = excluded.nome_chave_permissao,
    tipo_acesso = excluded.tipo_acesso,
    categoria_acesso = excluded.categoria_acesso,
    codigo_responsavel = excluded.codigo_responsavel,
    codigo_titular = excluded.codigo_titular,
    codigo_area_relacionada = excluded.codigo_area_relacionada,
    codigo_ativo_estrutural = excluded.codigo_ativo_estrutural,
    recurso_controlado = excluded.recurso_controlado,
    perfil_operacional = excluded.perfil_operacional,
    nivel_permissao = excluded.nivel_permissao,
    forma_credencial = excluded.forma_credencial,
    validade_inicio = excluded.validade_inicio,
    validade_fim = excluded.validade_fim,
    status_permissao = excluded.status_permissao,
    historico_acao = excluded.historico_acao,
    observacoes = excluded.observacoes,
    payload = cp.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning cp.id_chave_permissao into v_id_chave;

  insert into unidade_agricola.fractal_chaves_fisicas (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub08:' || v_id_chave::text,
    'validado',
    jsonb_build_object(
      'id_chave_permissao', v_id_chave,
      'codigo_chave_permissao', upper(trim(p_codigo_chave_permissao)),
      'tipo_acesso', p_tipo_acesso,
      'aplicavel_chave_fisica', coalesce(p_tipo_acesso, '') ilike '%fisic%' or coalesce(p_categoria_acesso, '') ilike '%chave%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_chaves_fisicas.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '08_sub_chaves_permissoes_operacionais',
    '01_fractal_chaves_fisicas',
    'validado',
    jsonb_build_object('id_chave_permissao', v_id_chave)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_acessos_digitais (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub08:' || v_id_chave::text,
    'validado',
    jsonb_build_object(
      'id_chave_permissao', v_id_chave,
      'codigo_chave_permissao', upper(trim(p_codigo_chave_permissao)),
      'tipo_acesso', p_tipo_acesso,
      'forma_credencial', p_forma_credencial,
      'recurso_controlado', p_recurso_controlado
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_acessos_digitais.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '08_sub_chaves_permissoes_operacionais',
    '02_fractal_acessos_digitais',
    'validado',
    jsonb_build_object('id_chave_permissao', v_id_chave)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_perfis_operacionais (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub08:' || v_id_chave::text,
    'validado',
    jsonb_build_object(
      'id_chave_permissao', v_id_chave,
      'codigo_responsavel', p_codigo_responsavel,
      'perfil_operacional', p_perfil_operacional,
      'nivel_permissao', p_nivel_permissao
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_perfis_operacionais.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '08_sub_chaves_permissoes_operacionais',
    '03_fractal_perfis_operacionais',
    'validado',
    jsonb_build_object('id_chave_permissao', v_id_chave)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_autorizacoes_area_funcao (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub08:' || v_id_chave::text,
    'validado',
    jsonb_build_object(
      'id_chave_permissao', v_id_chave,
      'codigo_area_relacionada', p_codigo_area_relacionada,
      'codigo_ativo_estrutural', p_codigo_ativo_estrutural,
      'perfil_operacional', p_perfil_operacional,
      'nivel_permissao', p_nivel_permissao
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_autorizacoes_area_funcao.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '08_sub_chaves_permissoes_operacionais',
    '04_fractal_autorizacoes_area_funcao',
    'validado',
    jsonb_build_object('id_chave_permissao', v_id_chave)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_historico_acesso (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub08:' || v_id_chave::text,
    'validado',
    jsonb_build_object(
      'id_chave_permissao', v_id_chave,
      'codigo_chave_permissao', upper(trim(p_codigo_chave_permissao)),
      'historico_acao', p_historico_acao,
      'status_permissao', p_status_permissao,
      'registrado_em', now()
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_historico_acesso.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '08_sub_chaves_permissoes_operacionais',
    '05_fractal_historico_acesso',
    'validado',
    jsonb_build_object('id_chave_permissao', v_id_chave)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_seguranca_cowork_workspace (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub08:' || v_id_chave::text,
    'validado',
    jsonb_build_object(
      'id_chave_permissao', v_id_chave,
      'codigo_chave_permissao', upper(trim(p_codigo_chave_permissao)),
      'integrar_seguranca', true,
      'integrar_cowork', true,
      'integrar_workspace', true,
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Gestao_Seguranca_Patrimonial',
        'Mod_Gestao_Cowork_Workspace',
        'Mod_Gestao_Chaves_Permissoes',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_seguranca_cowork_workspace.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '08_sub_chaves_permissoes_operacionais',
    '06_fractal_integracao_seguranca_cowork_workspace',
    'validado',
    jsonb_build_object('id_chave_permissao', v_id_chave, 'integrar_workspace', true)
  );
  v_eventos := v_eventos + 1;

  return query
  select
    cp.id_chave_permissao,
    cp.id_unidade_agricola,
    cp.codigo_unidade,
    cp.codigo_chave_permissao,
    cp.nome_chave_permissao,
    cp.tipo_acesso,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub08_chaves_permissoes_operacionais cp
  where cp.id_chave_permissao = v_id_chave;
end;
$$;

create or replace view unidade_agricola.vw_sub08_validacao_chaves_permissoes as
select
  cp.id_chave_permissao,
  cp.id_unidade_agricola,
  cp.codigo_unidade,
  cp.codigo_chave_permissao,
  cp.nome_chave_permissao,
  cp.tipo_acesso,
  cp.codigo_responsavel,
  cp.perfil_operacional,
  cp.nivel_permissao,
  cp.status_permissao,
  (coalesce(trim(cp.codigo_chave_permissao), '') <> '') as possui_codigo_chave_permissao,
  (coalesce(trim(cp.nome_chave_permissao), '') <> '') as possui_nome_chave_permissao,
  (coalesce(trim(coalesce(cp.tipo_acesso, '')), '') <> '') as possui_tipo_acesso,
  (cp.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  (coalesce(trim(coalesce(cp.perfil_operacional, '')), '') <> '') as possui_perfil_operacional,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(cp.codigo_chave_permissao), '') = '' then 'erro'
    when coalesce(trim(cp.nome_chave_permissao), '') = '' then 'erro'
    when coalesce(trim(coalesce(cp.tipo_acesso, '')), '') = '' then 'erro'
    when cp.validade_fim is not null and cp.validade_fim < current_date then 'atencao'
    when coalesce(trim(coalesce(cp.perfil_operacional, '')), '') = '' then 'atencao'
    else 'saudavel'
  end as status_validacao,
  cp.updated_at
from unidade_agricola.sub08_chaves_permissoes_operacionais cp
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = cp.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub08_fractais_status_chave_permissao as
select
  cp.id_chave_permissao,
  cp.codigo_chave_permissao,
  cp.codigo_unidade,
  cp.nome_chave_permissao,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub08_chaves_permissoes_operacionais cp
cross join lateral (
  values
    (1, '01_fractal_chaves_fisicas', 'Chaves fisicas', (select f.status from unidade_agricola.fractal_chaves_fisicas f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_chaves_fisicas f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_chaves_fisicas f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_acessos_digitais', 'Acessos digitais', (select f.status from unidade_agricola.fractal_acessos_digitais f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_acessos_digitais f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_acessos_digitais f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_perfis_operacionais', 'Perfis operacionais', (select f.status from unidade_agricola.fractal_perfis_operacionais f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_perfis_operacionais f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_perfis_operacionais f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_autorizacoes_area_funcao', 'Autorizacoes por area ou funcao', (select f.status from unidade_agricola.fractal_autorizacoes_area_funcao f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_autorizacoes_area_funcao f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_autorizacoes_area_funcao f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_historico_acesso', 'Historico de acesso', (select f.status from unidade_agricola.fractal_historico_acesso f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_historico_acesso f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_historico_acesso f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_seguranca_cowork_workspace', 'Integracao seguranca cowork workspace', (select f.status from unidade_agricola.fractal_integracao_seguranca_cowork_workspace f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_seguranca_cowork_workspace f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_seguranca_cowork_workspace f where f.id_origem = 'sub08:' || cp.id_chave_permissao::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub08_chaves_permissoes_operacional as
select
  cp.id_chave_permissao,
  cp.id_unidade_agricola,
  cp.codigo_unidade,
  u.nome_unidade,
  cp.codigo_chave_permissao,
  cp.nome_chave_permissao,
  cp.tipo_acesso,
  cp.categoria_acesso,
  cp.codigo_responsavel,
  cp.codigo_area_relacionada,
  cp.codigo_ativo_estrutural,
  cp.recurso_controlado,
  cp.perfil_operacional,
  cp.nivel_permissao,
  cp.status_permissao,
  cp.validade_fim,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub08,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  cp.sync_status,
  cp.updated_at
from unidade_agricola.sub08_chaves_permissoes_operacionais cp
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = cp.id_unidade_agricola
left join unidade_agricola.vw_sub08_validacao_chaves_permissoes v
  on v.id_chave_permissao = cp.id_chave_permissao
left join unidade_agricola.vw_sub08_fractais_status_chave_permissao fs
  on fs.id_chave_permissao = cp.id_chave_permissao
group by
  cp.id_chave_permissao,
  cp.id_unidade_agricola,
  cp.codigo_unidade,
  u.nome_unidade,
  cp.codigo_chave_permissao,
  cp.nome_chave_permissao,
  cp.tipo_acesso,
  cp.categoria_acesso,
  cp.codigo_responsavel,
  cp.codigo_area_relacionada,
  cp.codigo_ativo_estrutural,
  cp.recurso_controlado,
  cp.perfil_operacional,
  cp.nivel_permissao,
  cp.status_permissao,
  cp.validade_fim,
  v.status_validacao,
  cp.sync_status,
  cp.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '08_sub_chaves_permissoes_operacionais',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'complementa', jsonb_build_array('03_sub_responsaveis_gestores', '04_sub_territorios_areas_producao', '07_sub_base_ativos_estruturais_unidade'),
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_chave_permissao', 'codigo_responsavel', 'codigo_area_relacionada', 'codigo_ativo_estrutural'),
    'entrada_principal', 'unidade_agricola.salvar_sub08_chave_permissao_operacional',
    'views_publicadas', jsonb_build_array(
      'vw_sub08_chaves_permissoes_operacional',
      'vw_sub08_fractais_status_chave_permissao',
      'vw_sub08_validacao_chaves_permissoes'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_chaves_fisicas.validado',
      'unidade_agricola.fractal_acessos_digitais.validado',
      'unidade_agricola.fractal_perfis_operacionais.validado',
      'unidade_agricola.fractal_autorizacoes_area_funcao.validado',
      'unidade_agricola.fractal_historico_acesso.validado',
      'unidade_agricola.fractal_integracao_seguranca_cowork_workspace.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Gestao_Seguranca_Patrimonial',
      'Mod_Gestao_Cowork_Workspace',
      'Mod_Gestao_Chaves_Permissoes',
      'Mod_Gestao_Genius_Hub',
      'Mod_Gestao_Projetos',
      'Mod_Gestao_Tarefas_Processos'
    )
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub08_contrato_backend as
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
  and submodulo = '08_sub_chaves_permissoes_operacionais'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub08_chaves_permissoes_operacionais,
  unidade_agricola.vw_sub08_chaves_permissoes_operacional,
  unidade_agricola.vw_sub08_fractais_status_chave_permissao,
  unidade_agricola.vw_sub08_validacao_chaves_permissoes,
  unidade_agricola.vw_sub08_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub08_chave_permissao_operacional(
  text, text, text, text, text, text, text, text, text, text, text, text, text, date, date, text, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub08_chave_permissao_operacional(
  text, text, text, text, text, text, text, text, text, text, text, text, text, date, date, text, text, text, text, jsonb
) to authenticated;
