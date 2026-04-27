-- 202604260015_sub02_backend.sql
-- Camada executavel do submodulo 02_sub_proprietarios_possuidores.
-- Conecta proprietarios/possuidores ao submodulo 01 por id_unidade_agricola e codigo_unidade.

create table if not exists unidade_agricola.sub02_titulares_unidade (
  id_titular uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_titular text not null unique,
  nome_titular text not null,
  documento_titular text,
  tipo_titular text,
  tipo_vinculo text,
  percentual_participacao numeric,
  telefone text,
  email text,
  status_vinculo text not null default 'Ativo',
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub02_titulares_unidade is
'Tabela operacional do submodulo 02. Registra proprietarios, possuidores e titulares vinculados a uma unidade agricola.';

create index if not exists idx_sub02_titulares_unidade_id_unidade
on unidade_agricola.sub02_titulares_unidade(id_unidade_agricola);

create index if not exists idx_sub02_titulares_unidade_codigo_unidade
on unidade_agricola.sub02_titulares_unidade(codigo_unidade);

create index if not exists idx_sub02_titulares_unidade_status
on unidade_agricola.sub02_titulares_unidade(status_vinculo);

create index if not exists idx_sub02_titulares_unidade_payload_gin
on unidade_agricola.sub02_titulares_unidade using gin(payload);

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

create or replace function unidade_agricola.salvar_sub02_proprietario_possuidor(
  p_codigo_unidade text,
  p_nome_titular text,
  p_documento_titular text default null,
  p_tipo_titular text default 'Pessoa fisica',
  p_tipo_vinculo text default 'Proprietario',
  p_percentual_participacao numeric default null,
  p_telefone text default null,
  p_email text default null,
  p_status_vinculo text default 'Ativo',
  p_observacoes text default null,
  p_codigo_titular text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_titular uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_titular text,
  nome_titular text,
  tipo_vinculo text,
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
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_nome_titular), '') = '' then
    raise exception 'nome_titular obrigatorio';
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

  v_codigo_titular := coalesce(
    nullif(trim(coalesce(p_codigo_titular, '')), ''),
    'TIT-' || upper(trim(p_codigo_unidade)) || '-' ||
    substring(md5(
      upper(trim(p_codigo_unidade)) || '|' ||
      upper(trim(p_nome_titular)) || '|' ||
      upper(trim(coalesce(p_documento_titular, ''))) || '|' ||
      upper(trim(coalesce(p_tipo_vinculo, '')))
    ) from 1 for 10)
  );

  v_payload_base := jsonb_build_object(
    'origem_registro', p_origem_registro,
    'documento_titular', p_documento_titular,
    'tipo_titular', p_tipo_titular,
    'tipo_vinculo', p_tipo_vinculo,
    'percentual_participacao', p_percentual_participacao,
    'telefone', p_telefone,
    'email', p_email,
    'observacoes', p_observacoes,
    'submodulo_base_validado', true
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub02_titulares_unidade as t (
    id_unidade_agricola,
    codigo_unidade,
    codigo_titular,
    nome_titular,
    documento_titular,
    tipo_titular,
    tipo_vinculo,
    percentual_participacao,
    telefone,
    email,
    status_vinculo,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    v_codigo_titular,
    trim(p_nome_titular),
    nullif(trim(coalesce(p_documento_titular, '')), ''),
    nullif(trim(coalesce(p_tipo_titular, '')), ''),
    nullif(trim(coalesce(p_tipo_vinculo, '')), ''),
    p_percentual_participacao,
    nullif(trim(coalesce(p_telefone, '')), ''),
    nullif(trim(coalesce(p_email, '')), ''),
    coalesce(nullif(trim(coalesce(p_status_vinculo, '')), ''), 'Ativo'),
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_titular) do update set
    nome_titular = excluded.nome_titular,
    documento_titular = excluded.documento_titular,
    tipo_titular = excluded.tipo_titular,
    tipo_vinculo = excluded.tipo_vinculo,
    percentual_participacao = excluded.percentual_participacao,
    telefone = excluded.telefone,
    email = excluded.email,
    status_vinculo = excluded.status_vinculo,
    observacoes = excluded.observacoes,
    payload = t.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning t.id_titular into v_id_titular;

  insert into unidade_agricola.fractal_cadastro_proprietarios (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub02:' || v_id_titular::text,
    'validado',
    jsonb_build_object(
      'id_titular', v_id_titular,
      'codigo_titular', v_codigo_titular,
      'nome_titular', p_nome_titular,
      'documento_titular', p_documento_titular,
      'tipo_vinculo', p_tipo_vinculo
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_cadastro_proprietarios.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '02_sub_proprietarios_possuidores',
    '01_fractal_cadastro_proprietarios',
    'validado',
    jsonb_build_object('id_titular', v_id_titular, 'codigo_titular', v_codigo_titular)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_cadastro_possuidores (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub02:' || v_id_titular::text,
    'validado',
    jsonb_build_object(
      'id_titular', v_id_titular,
      'codigo_titular', v_codigo_titular,
      'nome_titular', p_nome_titular,
      'documento_titular', p_documento_titular,
      'tipo_titular', p_tipo_titular,
      'tipo_vinculo', p_tipo_vinculo,
      'aplicavel_como_possuidor', coalesce(p_tipo_vinculo, '') not ilike '%propriet%'
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_cadastro_possuidores.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '02_sub_proprietarios_possuidores',
    '02_fractal_cadastro_possuidores',
    'validado',
    jsonb_build_object('id_titular', v_id_titular, 'codigo_titular', v_codigo_titular)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_documentos_titulares (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub02:' || v_id_titular::text,
    case when coalesce(trim(coalesce(p_documento_titular, '')), '') <> '' then 'validado' else 'pendente' end,
    jsonb_build_object(
      'id_titular', v_id_titular,
      'codigo_titular', v_codigo_titular,
      'documento_titular', p_documento_titular,
      'tipo_titular', p_tipo_titular
    ),
    case when coalesce(trim(coalesce(p_documento_titular, '')), '') <> '' then 'validado' else 'pendente' end
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_documentos_titulares.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '02_sub_proprietarios_possuidores',
    '03_fractal_documentos_titulares',
    'validado',
    jsonb_build_object('id_titular', v_id_titular, 'documento_informado', coalesce(trim(coalesce(p_documento_titular, '')), '') <> '')
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_vinculos_unidade_agricola (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub02:' || v_id_titular::text,
    'validado',
    jsonb_build_object(
      'id_titular', v_id_titular,
      'codigo_titular', v_codigo_titular,
      'tipo_vinculo', p_tipo_vinculo,
      'percentual_participacao', p_percentual_participacao,
      'status_vinculo', p_status_vinculo,
      'id_unidade_agricola', v_id_unidade,
      'codigo_unidade', v_codigo_unidade
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_vinculos_unidade_agricola.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '02_sub_proprietarios_possuidores',
    '04_fractal_vinculos_unidade_agricola',
    'validado',
    jsonb_build_object('id_titular', v_id_titular, 'codigo_unidade', v_codigo_unidade)
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_historico_titularidade (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub02:' || v_id_titular::text,
    'validado',
    jsonb_build_object(
      'id_titular', v_id_titular,
      'codigo_titular', v_codigo_titular,
      'acao', 'cadastro_ou_atualizacao_titular',
      'origem_registro', p_origem_registro,
      'registrado_em', now()
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_historico_titularidade.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '02_sub_proprietarios_possuidores',
    '05_fractal_historico_titularidade',
    'validado',
    jsonb_build_object('id_titular', v_id_titular, 'acao', 'cadastro_ou_atualizacao_titular')
  );
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_contratos_juridico_permissoes (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub02:' || v_id_titular::text,
    'validado',
    jsonb_build_object(
      'id_titular', v_id_titular,
      'codigo_titular', v_codigo_titular,
      'integrar_contratos', true,
      'integrar_juridico', true,
      'integrar_permissoes', true,
      'integrar_fiscal', true,
      'modulos_consumidores_base', jsonb_build_array(
        'Mod_Gestao_Contratos',
        'Mod_Gestao_Juridica',
        'Mod_Gestao_Fiscal_Tributaria',
        'Mod_Gestao_Cowork_Workspace',
        'Mod_Gestao_Genius_Hub'
      )
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal(
    'unidade_agricola.fractal_integracao_contratos_juridico_permissoes.validado',
    v_id_unidade, v_id_fractal,
    'Mod_Gestao_Unidade_Agricola',
    '02_sub_proprietarios_possuidores',
    '06_fractal_integracao_contratos_juridico_permissoes',
    'validado',
    jsonb_build_object('id_titular', v_id_titular, 'codigo_titular', v_codigo_titular)
  );
  v_eventos := v_eventos + 1;

  return query
  select
    t.id_titular,
    t.id_unidade_agricola,
    t.codigo_unidade,
    t.codigo_titular,
    t.nome_titular,
    t.tipo_vinculo,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub02_titulares_unidade t
  where t.id_titular = v_id_titular;
end;
$$;

create or replace view unidade_agricola.vw_sub02_validacao_titulares as
select
  t.id_titular,
  t.id_unidade_agricola,
  t.codigo_unidade,
  t.codigo_titular,
  t.nome_titular,
  t.documento_titular,
  t.tipo_titular,
  t.tipo_vinculo,
  (coalesce(trim(t.nome_titular), '') <> '') as possui_nome_titular,
  (coalesce(trim(coalesce(t.tipo_vinculo, '')), '') <> '') as possui_tipo_vinculo,
  (coalesce(trim(coalesce(t.documento_titular, '')), '') <> '') as possui_documento,
  (t.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(t.nome_titular), '') = '' then 'erro'
    when coalesce(trim(coalesce(t.tipo_vinculo, '')), '') = '' then 'atencao'
    when coalesce(trim(coalesce(t.documento_titular, '')), '') = '' then 'atencao'
    else 'saudavel'
  end as status_validacao,
  t.updated_at
from unidade_agricola.sub02_titulares_unidade t
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = t.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub02_fractais_status_titular as
select
  t.id_titular,
  t.codigo_titular,
  t.codigo_unidade,
  t.nome_titular,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub02_titulares_unidade t
cross join lateral (
  values
    (1, '01_fractal_cadastro_proprietarios', 'Cadastro de proprietarios', (select f.status from unidade_agricola.fractal_cadastro_proprietarios f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_cadastro_proprietarios f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_cadastro_proprietarios f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_cadastro_possuidores', 'Cadastro de possuidores', (select f.status from unidade_agricola.fractal_cadastro_possuidores f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_cadastro_possuidores f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_cadastro_possuidores f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_documentos_titulares', 'Documentos dos titulares', (select f.status from unidade_agricola.fractal_documentos_titulares f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_documentos_titulares f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_documentos_titulares f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_vinculos_unidade_agricola', 'Vinculos com unidade agricola', (select f.status from unidade_agricola.fractal_vinculos_unidade_agricola f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_vinculos_unidade_agricola f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_vinculos_unidade_agricola f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_historico_titularidade', 'Historico de titularidade', (select f.status from unidade_agricola.fractal_historico_titularidade f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_historico_titularidade f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_historico_titularidade f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_contratos_juridico_permissoes', 'Integracao contratos, juridico e permissoes', (select f.status from unidade_agricola.fractal_integracao_contratos_juridico_permissoes f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_contratos_juridico_permissoes f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_contratos_juridico_permissoes f where f.id_origem = 'sub02:' || t.id_titular::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub02_proprietarios_possuidores_operacional as
select
  t.id_titular,
  t.id_unidade_agricola,
  t.codigo_unidade,
  u.nome_unidade,
  t.codigo_titular,
  t.nome_titular,
  t.documento_titular,
  t.tipo_titular,
  t.tipo_vinculo,
  t.percentual_participacao,
  t.telefone,
  t.email,
  t.status_vinculo,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub02,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') >= 4
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  t.sync_status,
  t.updated_at
from unidade_agricola.sub02_titulares_unidade t
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = t.id_unidade_agricola
left join unidade_agricola.vw_sub02_validacao_titulares v
  on v.id_titular = t.id_titular
left join unidade_agricola.vw_sub02_fractais_status_titular fs
  on fs.id_titular = t.id_titular
group by
  t.id_titular,
  t.id_unidade_agricola,
  t.codigo_unidade,
  u.nome_unidade,
  t.codigo_titular,
  t.nome_titular,
  t.documento_titular,
  t.tipo_titular,
  t.tipo_vinculo,
  t.percentual_participacao,
  t.telefone,
  t.email,
  t.status_vinculo,
  v.status_validacao,
  t.sync_status,
  t.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '02_sub_proprietarios_possuidores',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_titular'),
    'entrada_principal', 'unidade_agricola.salvar_sub02_proprietario_possuidor',
    'views_publicadas', jsonb_build_array(
      'vw_sub02_proprietarios_possuidores_operacional',
      'vw_sub02_fractais_status_titular',
      'vw_sub02_validacao_titulares'
    ),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_cadastro_proprietarios.validado',
      'unidade_agricola.fractal_cadastro_possuidores.validado',
      'unidade_agricola.fractal_documentos_titulares.validado',
      'unidade_agricola.fractal_vinculos_unidade_agricola.validado',
      'unidade_agricola.fractal_historico_titularidade.validado',
      'unidade_agricola.fractal_integracao_contratos_juridico_permissoes.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array(
      'Mod_Gestao_Contratos',
      'Mod_Gestao_Juridica',
      'Mod_Gestao_Fiscal_Tributaria',
      'Mod_Gestao_Cowork_Workspace',
      'Mod_Gestao_Genius_Hub'
    )
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub02_contrato_backend as
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
  and submodulo = '02_sub_proprietarios_possuidores'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub02_titulares_unidade,
  unidade_agricola.vw_sub02_proprietarios_possuidores_operacional,
  unidade_agricola.vw_sub02_fractais_status_titular,
  unidade_agricola.vw_sub02_validacao_titulares,
  unidade_agricola.vw_sub02_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub02_proprietario_possuidor(
  text, text, text, text, text, numeric, text, text, text, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub02_proprietario_possuidor(
  text, text, text, text, text, numeric, text, text, text, text, text, text, jsonb
) to authenticated;
