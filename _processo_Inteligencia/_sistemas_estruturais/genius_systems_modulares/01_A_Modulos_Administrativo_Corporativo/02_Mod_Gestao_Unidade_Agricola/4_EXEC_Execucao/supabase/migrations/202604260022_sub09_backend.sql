-- 202604260022_sub09_backend.sql
-- Camada executavel do submodulo 09_sub_status_operacional_unidade.
-- Consolida status geral, produtivo, documental, estrutural, riscos/pendencias e alertas para dashboards/planejamento.

create table if not exists unidade_agricola.sub09_status_operacional_unidade (
  id_status_operacional uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_status_operacional text not null unique,
  nome_ciclo_status text not null,
  status_geral text not null,
  status_produtivo text,
  status_documental text,
  status_estrutural text,
  nivel_risco text,
  pendencias_abertas integer not null default 0,
  alertas_ativos integer not null default 0,
  prioridade_acao text,
  responsavel_acompanhamento text,
  data_referencia date not null default current_date,
  proxima_revisao date,
  resumo_operacional text,
  recomendacao_acao text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub09_status_operacional_unidade is
'Tabela operacional do submodulo 09. Consolida o status operacional oficial da unidade agricola para planejamento, alertas, dashboards, agentes e modulos consumidores.';

create index if not exists idx_sub09_status_unidade
on unidade_agricola.sub09_status_operacional_unidade(id_unidade_agricola);

create index if not exists idx_sub09_status_codigo_unidade
on unidade_agricola.sub09_status_operacional_unidade(codigo_unidade);

create index if not exists idx_sub09_status_geral_risco
on unidade_agricola.sub09_status_operacional_unidade(status_geral, nivel_risco);

create index if not exists idx_sub09_status_payload_gin
on unidade_agricola.sub09_status_operacional_unidade using gin(payload);

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

create or replace function unidade_agricola.salvar_sub09_status_operacional_unidade(
  p_codigo_unidade text,
  p_codigo_status_operacional text,
  p_nome_ciclo_status text,
  p_status_geral text,
  p_status_produtivo text default null,
  p_status_documental text default null,
  p_status_estrutural text default null,
  p_nivel_risco text default null,
  p_pendencias_abertas integer default 0,
  p_alertas_ativos integer default 0,
  p_prioridade_acao text default null,
  p_responsavel_acompanhamento text default null,
  p_data_referencia date default current_date,
  p_proxima_revisao date default null,
  p_resumo_operacional text default null,
  p_recomendacao_acao text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_status_operacional uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_status_operacional text,
  nome_ciclo_status text,
  status_geral text,
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
  v_id_status uuid;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_codigo_status_operacional), '') = '' then
    raise exception 'codigo_status_operacional obrigatorio';
  end if;

  if coalesce(trim(p_nome_ciclo_status), '') = '' then
    raise exception 'nome_ciclo_status obrigatorio';
  end if;

  if coalesce(trim(p_status_geral), '') = '' then
    raise exception 'status_geral obrigatorio';
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
    'status_geral', p_status_geral,
    'status_produtivo', p_status_produtivo,
    'status_documental', p_status_documental,
    'status_estrutural', p_status_estrutural,
    'nivel_risco', p_nivel_risco,
    'pendencias_abertas', coalesce(p_pendencias_abertas, 0),
    'alertas_ativos', coalesce(p_alertas_ativos, 0),
    'prioridade_acao', p_prioridade_acao,
    'responsavel_acompanhamento', p_responsavel_acompanhamento,
    'data_referencia', coalesce(p_data_referencia, current_date),
    'proxima_revisao', p_proxima_revisao,
    'integrar_dashboards_alertas_planejamento', true,
    'submodulo_01_validado', true
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub09_status_operacional_unidade as so (
    id_unidade_agricola,
    codigo_unidade,
    codigo_status_operacional,
    nome_ciclo_status,
    status_geral,
    status_produtivo,
    status_documental,
    status_estrutural,
    nivel_risco,
    pendencias_abertas,
    alertas_ativos,
    prioridade_acao,
    responsavel_acompanhamento,
    data_referencia,
    proxima_revisao,
    resumo_operacional,
    recomendacao_acao,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    upper(trim(p_codigo_status_operacional)),
    trim(p_nome_ciclo_status),
    trim(p_status_geral),
    nullif(trim(coalesce(p_status_produtivo, '')), ''),
    nullif(trim(coalesce(p_status_documental, '')), ''),
    nullif(trim(coalesce(p_status_estrutural, '')), ''),
    nullif(trim(coalesce(p_nivel_risco, '')), ''),
    greatest(coalesce(p_pendencias_abertas, 0), 0),
    greatest(coalesce(p_alertas_ativos, 0), 0),
    nullif(trim(coalesce(p_prioridade_acao, '')), ''),
    nullif(trim(coalesce(p_responsavel_acompanhamento, '')), ''),
    coalesce(p_data_referencia, current_date),
    p_proxima_revisao,
    nullif(trim(coalesce(p_resumo_operacional, '')), ''),
    nullif(trim(coalesce(p_recomendacao_acao, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_status_operacional) do update set
    nome_ciclo_status = excluded.nome_ciclo_status,
    status_geral = excluded.status_geral,
    status_produtivo = excluded.status_produtivo,
    status_documental = excluded.status_documental,
    status_estrutural = excluded.status_estrutural,
    nivel_risco = excluded.nivel_risco,
    pendencias_abertas = excluded.pendencias_abertas,
    alertas_ativos = excluded.alertas_ativos,
    prioridade_acao = excluded.prioridade_acao,
    responsavel_acompanhamento = excluded.responsavel_acompanhamento,
    data_referencia = excluded.data_referencia,
    proxima_revisao = excluded.proxima_revisao,
    resumo_operacional = excluded.resumo_operacional,
    recomendacao_acao = excluded.recomendacao_acao,
    payload = so.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning so.id_status_operacional into v_id_status;

  insert into unidade_agricola.fractal_status_geral_unidade (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub09:' || v_id_status::text,
    'validado',
    jsonb_build_object('id_status_operacional', v_id_status, 'status_geral', p_status_geral, 'nome_ciclo_status', p_nome_ciclo_status),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_status_geral_unidade.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '01_fractal_status_geral_unidade', 'validado', jsonb_build_object('id_status_operacional', v_id_status));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_status_produtivo (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub09:' || v_id_status::text,
    'validado',
    jsonb_build_object('id_status_operacional', v_id_status, 'status_produtivo', p_status_produtivo),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_status_produtivo.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '02_fractal_status_produtivo', 'validado', jsonb_build_object('id_status_operacional', v_id_status));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_status_documental (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub09:' || v_id_status::text,
    'validado',
    jsonb_build_object('id_status_operacional', v_id_status, 'status_documental', p_status_documental),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_status_documental.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '03_fractal_status_documental', 'validado', jsonb_build_object('id_status_operacional', v_id_status));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_status_estrutural (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub09:' || v_id_status::text,
    'validado',
    jsonb_build_object('id_status_operacional', v_id_status, 'status_estrutural', p_status_estrutural),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_status_estrutural.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '04_fractal_status_estrutural', 'validado', jsonb_build_object('id_status_operacional', v_id_status));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_status_risco_pendencia (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub09:' || v_id_status::text,
    'validado',
    jsonb_build_object('id_status_operacional', v_id_status, 'nivel_risco', p_nivel_risco, 'pendencias_abertas', coalesce(p_pendencias_abertas, 0), 'alertas_ativos', coalesce(p_alertas_ativos, 0)),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_status_risco_pendencia.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '05_fractal_status_risco_pendencia', 'validado', jsonb_build_object('id_status_operacional', v_id_status));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_dashboards_alertas_planejamento (
    id_unidade_agricola, id_origem, status, payload, sync_status
  ) values (
    v_id_unidade,
    'sub09:' || v_id_status::text,
    'validado',
    jsonb_build_object(
      'id_status_operacional', v_id_status,
      'integrar_dashboards', true,
      'integrar_alertas', true,
      'integrar_planejamento', true,
      'integrar_agentes', true,
      'modulos_consumidores_base', jsonb_build_array('Mod_Gestao_Dashboards_BI', 'Mod_Gestao_Projetos', 'Mod_Gestao_Tarefas_Processos', 'Mod_Gestao_Genius_Hub', 'Mod_Gestao_Agentes_IA')
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '06_fractal_integracao_dashboards_alertas_planejamento', 'validado', jsonb_build_object('id_status_operacional', v_id_status, 'integrar_dashboards', true));
  v_eventos := v_eventos + 1;

  return query
  select
    so.id_status_operacional,
    so.id_unidade_agricola,
    so.codigo_unidade,
    so.codigo_status_operacional,
    so.nome_ciclo_status,
    so.status_geral,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub09_status_operacional_unidade so
  where so.id_status_operacional = v_id_status;
end;
$$;

create or replace view unidade_agricola.vw_sub09_validacao_status_operacional as
select
  so.id_status_operacional,
  so.id_unidade_agricola,
  so.codigo_unidade,
  so.codigo_status_operacional,
  so.nome_ciclo_status,
  so.status_geral,
  so.nivel_risco,
  so.pendencias_abertas,
  so.alertas_ativos,
  (coalesce(trim(so.codigo_status_operacional), '') <> '') as possui_codigo_status,
  (coalesce(trim(so.nome_ciclo_status), '') <> '') as possui_nome_ciclo,
  (coalesce(trim(coalesce(so.status_geral, '')), '') <> '') as possui_status_geral,
  (so.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(so.codigo_status_operacional), '') = '' then 'erro'
    when coalesce(trim(so.nome_ciclo_status), '') = '' then 'erro'
    when coalesce(trim(coalesce(so.status_geral, '')), '') = '' then 'erro'
    when coalesce(so.pendencias_abertas, 0) > 0 or coalesce(so.alertas_ativos, 0) > 0 then 'atencao'
    else 'saudavel'
  end as status_validacao,
  so.updated_at
from unidade_agricola.sub09_status_operacional_unidade so
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = so.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub09_fractais_status_operacional as
select
  so.id_status_operacional,
  so.codigo_status_operacional,
  so.codigo_unidade,
  so.nome_ciclo_status,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub09_status_operacional_unidade so
cross join lateral (
  values
    (1, '01_fractal_status_geral_unidade', 'Status geral da unidade', (select f.status from unidade_agricola.fractal_status_geral_unidade f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_status_geral_unidade f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_status_geral_unidade f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_status_produtivo', 'Status produtivo', (select f.status from unidade_agricola.fractal_status_produtivo f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_status_produtivo f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_status_produtivo f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_status_documental', 'Status documental', (select f.status from unidade_agricola.fractal_status_documental f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_status_documental f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_status_documental f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_status_estrutural', 'Status estrutural', (select f.status from unidade_agricola.fractal_status_estrutural f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_status_estrutural f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_status_estrutural f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_status_risco_pendencia', 'Status de risco e pendencia', (select f.status from unidade_agricola.fractal_status_risco_pendencia f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_status_risco_pendencia f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_status_risco_pendencia f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_dashboards_alertas_planejamento', 'Integracao dashboards alertas planejamento', (select f.status from unidade_agricola.fractal_integracao_dashboards_alertas_planejamento f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_dashboards_alertas_planejamento f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_dashboards_alertas_planejamento f where f.id_origem = 'sub09:' || so.id_status_operacional::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub09_status_operacional_unidade as
select
  so.id_status_operacional,
  so.id_unidade_agricola,
  so.codigo_unidade,
  u.nome_unidade,
  so.codigo_status_operacional,
  so.nome_ciclo_status,
  so.status_geral,
  so.status_produtivo,
  so.status_documental,
  so.status_estrutural,
  so.nivel_risco,
  so.pendencias_abertas,
  so.alertas_ativos,
  so.prioridade_acao,
  so.responsavel_acompanhamento,
  so.data_referencia,
  so.proxima_revisao,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub09,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  so.sync_status,
  so.updated_at
from unidade_agricola.sub09_status_operacional_unidade so
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = so.id_unidade_agricola
left join unidade_agricola.vw_sub09_validacao_status_operacional v
  on v.id_status_operacional = so.id_status_operacional
left join unidade_agricola.vw_sub09_fractais_status_operacional fs
  on fs.id_status_operacional = so.id_status_operacional
group by
  so.id_status_operacional,
  so.id_unidade_agricola,
  so.codigo_unidade,
  u.nome_unidade,
  so.codigo_status_operacional,
  so.nome_ciclo_status,
  so.status_geral,
  so.status_produtivo,
  so.status_documental,
  so.status_estrutural,
  so.nivel_risco,
  so.pendencias_abertas,
  so.alertas_ativos,
  so.prioridade_acao,
  so.responsavel_acompanhamento,
  so.data_referencia,
  so.proxima_revisao,
  v.status_validacao,
  so.sync_status,
  so.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '09_sub_status_operacional_unidade',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas'),
    'consolida', jsonb_build_array('03_sub_responsaveis_gestores', '04_sub_territorios_areas_producao', '06_sub_documentacao_unidade', '07_sub_base_ativos_estruturais_unidade', '08_sub_chaves_permissoes_operacionais'),
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_status_operacional'),
    'entrada_principal', 'unidade_agricola.salvar_sub09_status_operacional_unidade',
    'views_publicadas', jsonb_build_array('vw_sub09_status_operacional_unidade', 'vw_sub09_fractais_status_operacional', 'vw_sub09_validacao_status_operacional'),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_status_geral_unidade.validado',
      'unidade_agricola.fractal_status_produtivo.validado',
      'unidade_agricola.fractal_status_documental.validado',
      'unidade_agricola.fractal_status_estrutural.validado',
      'unidade_agricola.fractal_status_risco_pendencia.validado',
      'unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array('Mod_Gestao_Dashboards_BI', 'Mod_Gestao_Projetos', 'Mod_Gestao_Tarefas_Processos', 'Mod_Gestao_Agentes_IA', 'Mod_Gestao_Genius_Hub')
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub09_contrato_backend as
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
  and submodulo = '09_sub_status_operacional_unidade'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub09_status_operacional_unidade,
  unidade_agricola.vw_sub09_status_operacional_unidade,
  unidade_agricola.vw_sub09_fractais_status_operacional,
  unidade_agricola.vw_sub09_validacao_status_operacional,
  unidade_agricola.vw_sub09_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub09_status_operacional_unidade(
  text, text, text, text, text, text, text, text, integer, integer, text, text, date, date, text, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub09_status_operacional_unidade(
  text, text, text, text, text, text, text, text, integer, integer, text, text, date, date, text, text, text, jsonb
) to authenticated;
