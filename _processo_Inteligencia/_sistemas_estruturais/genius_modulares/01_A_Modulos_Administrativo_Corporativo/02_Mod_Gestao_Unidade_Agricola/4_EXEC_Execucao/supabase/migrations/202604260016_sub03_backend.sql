-- 202604260016_sub03_backend.sql
-- Camada executavel do submodulo 03_sub_responsaveis_gestores.
-- Conecta responsaveis/gestores ao submodulo 01 por id_unidade_agricola/codigo_unidade
-- e complementa o submodulo 02 por codigo_titular quando o responsavel tambem for titular.

create table if not exists unidade_agricola.sub03_responsaveis_gestores (
  id_responsavel uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  id_titular uuid references unidade_agricola.sub02_titulares_unidade(id_titular) on delete set null,
  codigo_titular text,
  codigo_responsavel text not null unique,
  nome_responsavel text not null,
  documento_responsavel text,
  tipo_responsabilidade text,
  cargo_funcao text,
  papel_operacional text,
  area_responsabilidade text,
  nivel_autorizacao text,
  principal boolean not null default false,
  telefone text,
  email text,
  status_responsavel text not null default 'Ativo',
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub03_responsaveis_gestores is
'Tabela operacional do submodulo 03. Registra responsaveis administrativos, gestores, tecnicos e operadores da unidade agricola.';

create index if not exists idx_sub03_responsaveis_id_unidade
on unidade_agricola.sub03_responsaveis_gestores(id_unidade_agricola);

create index if not exists idx_sub03_responsaveis_codigo_unidade
on unidade_agricola.sub03_responsaveis_gestores(codigo_unidade);

create index if not exists idx_sub03_responsaveis_codigo_titular
on unidade_agricola.sub03_responsaveis_gestores(codigo_titular);

create index if not exists idx_sub03_responsaveis_status
on unidade_agricola.sub03_responsaveis_gestores(status_responsavel);

create index if not exists idx_sub03_responsaveis_payload_gin
on unidade_agricola.sub03_responsaveis_gestores using gin(payload);

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

create or replace function unidade_agricola.salvar_sub03_responsavel_gestor(
  p_codigo_unidade text,
  p_nome_responsavel text,
  p_documento_responsavel text default null,
  p_tipo_responsabilidade text default 'Gestor',
  p_cargo_funcao text default null,
  p_papel_operacional text default null,
  p_area_responsabilidade text default null,
  p_nivel_autorizacao text default 'Operacional',
  p_principal boolean default false,
  p_telefone text default null,
  p_email text default null,
  p_status_responsavel text default 'Ativo',
  p_observacoes text default null,
  p_codigo_responsavel text default null,
  p_codigo_titular text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_responsavel uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_responsavel text,
  nome_responsavel text,
  tipo_responsabilidade text,
  codigo_titular text,
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
  v_id_titular uuid;
  v_codigo_titular text;
  v_id_responsavel uuid;
  v_codigo_responsavel text;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_nome_responsavel), '') = '' then
    raise exception 'nome_responsavel obrigatorio';
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

  if coalesce(trim(coalesce(p_codigo_titular, '')), '') <> '' then
    select t.id_titular, t.codigo_titular
      into v_id_titular, v_codigo_titular
    from unidade_agricola.sub02_titulares_unidade t
    where t.codigo_titular = trim(p_codigo_titular)
      and t.id_unidade_agricola = v_id_unidade
    limit 1;

    if v_id_titular is null then
      raise exception 'codigo_titular nao encontrado para esta unidade: %', p_codigo_titular;
    end if;
  end if;

  v_codigo_responsavel := coalesce(
    nullif(trim(coalesce(p_codigo_responsavel, '')), ''),
    'RESP-' || upper(trim(p_codigo_unidade)) || '-' ||
    substring(md5(
      upper(trim(p_codigo_unidade)) || '|' ||
      upper(trim(p_nome_responsavel)) || '|' ||
      upper(trim(coalesce(p_documento_responsavel, ''))) || '|' ||
      upper(trim(coalesce(p_tipo_responsabilidade, '')))
    ) from 1 for 10)
  );

  v_payload_base := jsonb_build_object(
    'origem_registro', p_origem_registro,
    'codigo_titular', v_codigo_titular,
    'documento_responsavel', p_documento_responsavel,
    'tipo_responsabilidade', p_tipo_responsabilidade,
    'cargo_funcao', p_cargo_funcao,
    'papel_operacional', p_papel_operacional,
    'area_responsabilidade', p_area_responsabilidade,
    'nivel_autorizacao', p_nivel_autorizacao,
    'principal', p_principal,
    'telefone', p_telefone,
    'email', p_email,
    'observacoes', p_observacoes,
    'submodulo_01_validado', true,
    'vinculo_submodulo_02', v_id_titular is not null
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub03_responsaveis_gestores as r (
    id_unidade_agricola,
    codigo_unidade,
    id_titular,
    codigo_titular,
    codigo_responsavel,
    nome_responsavel,
    documento_responsavel,
    tipo_responsabilidade,
    cargo_funcao,
    papel_operacional,
    area_responsabilidade,
    nivel_autorizacao,
    principal,
    telefone,
    email,
    status_responsavel,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    v_id_titular,
    v_codigo_titular,
    v_codigo_responsavel,
    trim(p_nome_responsavel),
    nullif(trim(coalesce(p_documento_responsavel, '')), ''),
    nullif(trim(coalesce(p_tipo_responsabilidade, '')), ''),
    nullif(trim(coalesce(p_cargo_funcao, '')), ''),
    nullif(trim(coalesce(p_papel_operacional, '')), ''),
    nullif(trim(coalesce(p_area_responsabilidade, '')), ''),
    nullif(trim(coalesce(p_nivel_autorizacao, '')), ''),
    coalesce(p_principal, false),
    nullif(trim(coalesce(p_telefone, '')), ''),
    nullif(trim(coalesce(p_email, '')), ''),
    coalesce(nullif(trim(coalesce(p_status_responsavel, '')), ''), 'Ativo'),
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_responsavel) do update set
    id_titular = excluded.id_titular,
    codigo_titular = excluded.codigo_titular,
    nome_responsavel = excluded.nome_responsavel,
    documento_responsavel = excluded.documento_responsavel,
    tipo_responsabilidade = excluded.tipo_responsabilidade,
    cargo_funcao = excluded.cargo_funcao,
    papel_operacional = excluded.papel_operacional,
    area_responsabilidade = excluded.area_responsabilidade,
    nivel_autorizacao = excluded.nivel_autorizacao,
    principal = excluded.principal,
    telefone = excluded.telefone,
    email = excluded.email,
    status_responsavel = excluded.status_responsavel,
    observacoes = excluded.observacoes,
    payload = r.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning r.id_responsavel into v_id_responsavel;

  insert into unidade_agricola.fractal_cadastro_responsaveis (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub03:' || v_id_responsavel::text,
    'validado',
    jsonb_build_object(
      'id_responsavel', v_id_responsavel,
      'codigo_responsavel', v_codigo_responsavel,
      'nome_responsavel', p_nome_responsavel,
      'documento_responsavel', p_documento_responsavel,
      'codigo_titular', v_codigo_titular
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_cadastro_responsaveis.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '03_sub_responsaveis_gestores',
    '01_fractal_cadastro_responsaveis',
    'validado',
    jsonb_build_object('id_responsavel', v_id_responsavel, 'codigo_responsavel', v_codigo_responsavel)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_funcoes_papeis_operacionais (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub03:' || v_id_responsavel::text,
    'validado',
    jsonb_build_object(
      'id_responsavel', v_id_responsavel,
      'codigo_responsavel', v_codigo_responsavel,
      'tipo_responsabilidade', p_tipo_responsabilidade,
      'cargo_funcao', p_cargo_funcao,
      'papel_operacional', p_papel_operacional,
      'area_responsabilidade', p_area_responsabilidade
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_funcoes_papeis_operacionais.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '03_sub_responsaveis_gestores',
    '02_fractal_funcoes_papeis_operacionais',
    'validado',
    jsonb_build_object('id_responsavel', v_id_responsavel, 'papel_operacional', p_papel_operacional)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_responsabilidade_tecnica (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub03:' || v_id_responsavel::text,
    'validado',
    jsonb_build_object(
      'id_responsavel', v_id_responsavel,
      'codigo_responsavel', v_codigo_responsavel,
      'tipo_responsabilidade', p_tipo_responsabilidade,
      'aplicavel_como_tecnico', coalesce(p_tipo_responsabilidade, '') ilike '%tecn%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_responsabilidade_tecnica.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '03_sub_responsaveis_gestores',
    '03_fractal_responsabilidade_tecnica',
    'validado',
    jsonb_build_object('id_responsavel', v_id_responsavel, 'aplicavel_como_tecnico', coalesce(p_tipo_responsabilidade, '') ilike '%tecn%')
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_responsabilidade_administrativa (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub03:' || v_id_responsavel::text,
    'validado',
    jsonb_build_object(
      'id_responsavel', v_id_responsavel,
      'codigo_responsavel', v_codigo_responsavel,
      'tipo_responsabilidade', p_tipo_responsabilidade,
      'principal', p_principal,
      'aplicavel_como_administrativo', coalesce(p_tipo_responsabilidade, '') ilike '%admin%' or coalesce(p_tipo_responsabilidade, '') ilike '%gest%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_responsabilidade_administrativa.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '03_sub_responsaveis_gestores',
    '04_fractal_responsabilidade_administrativa',
    'validado',
    jsonb_build_object('id_responsavel', v_id_responsavel, 'principal', p_principal)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_niveis_autorizacao (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub03:' || v_id_responsavel::text,
    'validado',
    jsonb_build_object(
      'id_responsavel', v_id_responsavel,
      'codigo_responsavel', v_codigo_responsavel,
      'nivel_autorizacao', p_nivel_autorizacao,
      'principal', p_principal
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_niveis_autorizacao.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '03_sub_responsaveis_gestores',
    '05_fractal_niveis_autorizacao',
    'validado',
    jsonb_build_object('id_responsavel', v_id_responsavel, 'nivel_autorizacao', p_nivel_autorizacao)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_tarefas_projetos_cowork (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub03:' || v_id_responsavel::text,
    'validado',
    jsonb_build_object(
      'id_responsavel', v_id_responsavel,
      'codigo_responsavel', v_codigo_responsavel,
      'integrar_tarefas', true,
      'integrar_projetos', true,
      'integrar_cowork_workspace', true,
      'integrar_permissoes', true,
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Gestao_Projetos',
        'Mod_Gestao_Tarefas_Processos',
        'Mod_Gestao_Cowork_Workspace',
        'Mod_Gestao_Chaves_Permissoes',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_tarefas_projetos_cowork.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '03_sub_responsaveis_gestores',
    '06_fractal_integracao_tarefas_projetos_cowork',
    'validado',
    jsonb_build_object('id_responsavel', v_id_responsavel, 'codigo_responsavel', v_codigo_responsavel)
  );
  v_eventos := v_eventos + 1;

  return query
  select
    r.id_responsavel,
    r.id_unidade_agricola,
    r.codigo_unidade,
    r.codigo_responsavel,
    r.nome_responsavel,
    r.tipo_responsabilidade,
    r.codigo_titular,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub03_responsaveis_gestores r
  where r.id_responsavel = v_id_responsavel;
end;
$$;

create or replace view unidade_agricola.vw_sub03_validacao_responsaveis as
select
  r.id_responsavel,
  r.id_unidade_agricola,
  r.codigo_unidade,
  r.codigo_responsavel,
  r.nome_responsavel,
  r.documento_responsavel,
  r.tipo_responsabilidade,
  r.cargo_funcao,
  r.nivel_autorizacao,
  r.codigo_titular,
  (coalesce(trim(r.nome_responsavel), '') <> '') as possui_nome_responsavel,
  (coalesce(trim(coalesce(r.tipo_responsabilidade, '')), '') <> '') as possui_tipo_responsabilidade,
  (coalesce(trim(coalesce(r.nivel_autorizacao, '')), '') <> '') as possui_nivel_autorizacao,
  (r.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(r.nome_responsavel), '') = '' then 'erro'
    when coalesce(trim(coalesce(r.tipo_responsabilidade, '')), '') = '' then 'atencao'
    when coalesce(trim(coalesce(r.nivel_autorizacao, '')), '') = '' then 'atencao'
    else 'saudavel'
  end as status_validacao,
  r.updated_at
from unidade_agricola.sub03_responsaveis_gestores r
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = r.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub03_fractais_status_responsavel as
select
  r.id_responsavel,
  r.codigo_responsavel,
  r.codigo_unidade,
  r.codigo_titular,
  r.nome_responsavel,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub03_responsaveis_gestores r
cross join lateral (
  values
    (1, '01_fractal_cadastro_responsaveis', 'Cadastro de responsaveis', (select f.status from unidade_agricola.fractal_cadastro_responsaveis f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_cadastro_responsaveis f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_cadastro_responsaveis f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_funcoes_papeis_operacionais', 'Funcoes e papeis operacionais', (select f.status from unidade_agricola.fractal_funcoes_papeis_operacionais f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_funcoes_papeis_operacionais f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_funcoes_papeis_operacionais f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_responsabilidade_tecnica', 'Responsabilidade tecnica', (select f.status from unidade_agricola.fractal_responsabilidade_tecnica f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_responsabilidade_tecnica f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_responsabilidade_tecnica f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_responsabilidade_administrativa', 'Responsabilidade administrativa', (select f.status from unidade_agricola.fractal_responsabilidade_administrativa f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_responsabilidade_administrativa f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_responsabilidade_administrativa f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_niveis_autorizacao', 'Niveis de autorizacao', (select f.status from unidade_agricola.fractal_niveis_autorizacao f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_niveis_autorizacao f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_niveis_autorizacao f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_tarefas_projetos_cowork', 'Integracao tarefas, projetos e cowork', (select f.status from unidade_agricola.fractal_integracao_tarefas_projetos_cowork f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_tarefas_projetos_cowork f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_tarefas_projetos_cowork f where f.id_origem = 'sub03:' || r.id_responsavel::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub03_responsaveis_gestores_operacional as
select
  r.id_responsavel,
  r.id_unidade_agricola,
  r.codigo_unidade,
  u.nome_unidade,
  r.codigo_titular,
  r.codigo_responsavel,
  r.nome_responsavel,
  r.documento_responsavel,
  r.tipo_responsabilidade,
  r.cargo_funcao,
  r.papel_operacional,
  r.area_responsabilidade,
  r.nivel_autorizacao,
  r.principal,
  r.telefone,
  r.email,
  r.status_responsavel,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub03,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  r.sync_status,
  r.updated_at
from unidade_agricola.sub03_responsaveis_gestores r
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = r.id_unidade_agricola
left join unidade_agricola.vw_sub03_validacao_responsaveis v
  on v.id_responsavel = r.id_responsavel
left join unidade_agricola.vw_sub03_fractais_status_responsavel fs
  on fs.id_responsavel = r.id_responsavel
group by
  r.id_responsavel,
  r.id_unidade_agricola,
  r.codigo_unidade,
  u.nome_unidade,
  r.codigo_titular,
  r.codigo_responsavel,
  r.nome_responsavel,
  r.documento_responsavel,
  r.tipo_responsabilidade,
  r.cargo_funcao,
  r.papel_operacional,
  r.area_responsabilidade,
  r.nivel_autorizacao,
  r.principal,
  r.telefone,
  r.email,
  r.status_responsavel,
  v.status_validacao,
  r.sync_status,
  r.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '03_sub_responsaveis_gestores',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'complementa', jsonb_build_array('02_sub_proprietarios_possuidores'),
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_responsavel', 'codigo_titular'),
    'entrada_principal', 'unidade_agricola.salvar_sub03_responsavel_gestor',
    'views_publicadas', jsonb_build_array(
      'vw_sub03_responsaveis_gestores_operacional',
      'vw_sub03_fractais_status_responsavel',
      'vw_sub03_validacao_responsaveis'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_cadastro_responsaveis.validado',
      'unidade_agricola.fractal_funcoes_papeis_operacionais.validado',
      'unidade_agricola.fractal_responsabilidade_tecnica.validado',
      'unidade_agricola.fractal_responsabilidade_administrativa.validado',
      'unidade_agricola.fractal_niveis_autorizacao.validado',
      'unidade_agricola.fractal_integracao_tarefas_projetos_cowork.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Gestao_Projetos',
      'Mod_Gestao_Tarefas_Processos',
      'Mod_Gestao_Cowork_Workspace',
      'Mod_Gestao_Chaves_Permissoes',
      'Mod_Gestao_Genius_Hub'
    )
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub03_contrato_backend as
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
  and submodulo = '03_sub_responsaveis_gestores'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub03_responsaveis_gestores,
  unidade_agricola.vw_sub03_responsaveis_gestores_operacional,
  unidade_agricola.vw_sub03_fractais_status_responsavel,
  unidade_agricola.vw_sub03_validacao_responsaveis,
  unidade_agricola.vw_sub03_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub03_responsavel_gestor(
  text, text, text, text, text, text, text, text, boolean, text, text, text, text, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub03_responsavel_gestor(
  text, text, text, text, text, text, text, text, boolean, text, text, text, text, text, text, text, jsonb
) to authenticated;
