-- 202604260023_sub10_backend.sql
-- Camada executavel do submodulo 10_sub_prestacao_contas_unidade.
-- Fecha o processo do modulo com resumo operacional, evidencias, conformidade, pendencias, historico e integracao financeiro/admin/auditoria.

create table if not exists unidade_agricola.sub10_prestacao_contas_unidade (
  id_prestacao_contas uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid not null references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  codigo_unidade text not null,
  codigo_prestacao_contas text not null unique,
  nome_prestacao_contas text not null,
  periodo_inicio date not null,
  periodo_fim date not null,
  codigo_status_operacional text,
  resumo_operacional text,
  total_evidencias integer not null default 0,
  url_pasta_evidencias text,
  conformidade_percentual numeric,
  status_conformidade text,
  pendencias_abertas integer not null default 0,
  pendencias_resolvidas integer not null default 0,
  valor_referenciado numeric,
  moeda text default 'BRL',
  responsavel_prestacao text,
  status_prestacao text not null default 'Em preparacao',
  data_fechamento date,
  observacoes text,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.sub10_prestacao_contas_unidade is
'Tabela operacional do submodulo 10. Fecha o processo da unidade com resumo operacional, evidencias, indicadores de conformidade, pendencias, historico e integracao financeiro/admin/auditoria.';

create index if not exists idx_sub10_prestacao_unidade
on unidade_agricola.sub10_prestacao_contas_unidade(id_unidade_agricola);

create index if not exists idx_sub10_prestacao_codigo_unidade
on unidade_agricola.sub10_prestacao_contas_unidade(codigo_unidade);

create index if not exists idx_sub10_prestacao_periodo
on unidade_agricola.sub10_prestacao_contas_unidade(periodo_inicio, periodo_fim);

create index if not exists idx_sub10_prestacao_status
on unidade_agricola.sub10_prestacao_contas_unidade(status_prestacao, status_conformidade);

create index if not exists idx_sub10_prestacao_payload_gin
on unidade_agricola.sub10_prestacao_contas_unidade using gin(payload);

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

create or replace function unidade_agricola.salvar_sub10_prestacao_contas_unidade(
  p_codigo_unidade text,
  p_codigo_prestacao_contas text,
  p_nome_prestacao_contas text,
  p_periodo_inicio date,
  p_periodo_fim date,
  p_codigo_status_operacional text default null,
  p_resumo_operacional text default null,
  p_total_evidencias integer default 0,
  p_url_pasta_evidencias text default null,
  p_conformidade_percentual numeric default null,
  p_status_conformidade text default null,
  p_pendencias_abertas integer default 0,
  p_pendencias_resolvidas integer default 0,
  p_valor_referenciado numeric default null,
  p_moeda text default 'BRL',
  p_responsavel_prestacao text default null,
  p_status_prestacao text default 'Em preparacao',
  p_data_fechamento date default null,
  p_observacoes text default null,
  p_origem_registro text default 'frontend',
  p_payload_extra jsonb default '{}'::jsonb
)
returns table (
  id_prestacao_contas uuid,
  id_unidade_agricola uuid,
  codigo_unidade text,
  codigo_prestacao_contas text,
  nome_prestacao_contas text,
  status_prestacao text,
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
  v_id_prestacao uuid;
  v_id_fractal uuid;
  v_eventos integer := 0;
  v_status_fractais text := 'validado';
  v_payload_base jsonb;
  v_unidade_pronta boolean;
begin
  if coalesce(trim(p_codigo_unidade), '') = '' then
    raise exception 'codigo_unidade obrigatorio';
  end if;

  if coalesce(trim(p_codigo_prestacao_contas), '') = '' then
    raise exception 'codigo_prestacao_contas obrigatorio';
  end if;

  if coalesce(trim(p_nome_prestacao_contas), '') = '' then
    raise exception 'nome_prestacao_contas obrigatorio';
  end if;

  if p_periodo_inicio is null or p_periodo_fim is null then
    raise exception 'periodo_inicio e periodo_fim sao obrigatorios';
  end if;

  if p_periodo_fim < p_periodo_inicio then
    raise exception 'periodo_fim nao pode ser anterior ao periodo_inicio';
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
    'codigo_status_operacional', p_codigo_status_operacional,
    'periodo_inicio', p_periodo_inicio,
    'periodo_fim', p_periodo_fim,
    'total_evidencias', greatest(coalesce(p_total_evidencias, 0), 0),
    'conformidade_percentual', p_conformidade_percentual,
    'status_conformidade', p_status_conformidade,
    'pendencias_abertas', greatest(coalesce(p_pendencias_abertas, 0), 0),
    'pendencias_resolvidas', greatest(coalesce(p_pendencias_resolvidas, 0), 0),
    'valor_referenciado', p_valor_referenciado,
    'moeda', coalesce(nullif(trim(coalesce(p_moeda, '')), ''), 'BRL'),
    'integrar_financeiro_admin_auditoria', true,
    'submodulo_01_validado', true
  ) || coalesce(p_payload_extra, '{}'::jsonb);

  insert into unidade_agricola.sub10_prestacao_contas_unidade as pc (
    id_unidade_agricola,
    codigo_unidade,
    codigo_prestacao_contas,
    nome_prestacao_contas,
    periodo_inicio,
    periodo_fim,
    codigo_status_operacional,
    resumo_operacional,
    total_evidencias,
    url_pasta_evidencias,
    conformidade_percentual,
    status_conformidade,
    pendencias_abertas,
    pendencias_resolvidas,
    valor_referenciado,
    moeda,
    responsavel_prestacao,
    status_prestacao,
    data_fechamento,
    observacoes,
    payload,
    sync_status
  ) values (
    v_id_unidade,
    v_codigo_unidade,
    upper(trim(p_codigo_prestacao_contas)),
    trim(p_nome_prestacao_contas),
    p_periodo_inicio,
    p_periodo_fim,
    upper(nullif(trim(coalesce(p_codigo_status_operacional, '')), '')),
    nullif(trim(coalesce(p_resumo_operacional, '')), ''),
    greatest(coalesce(p_total_evidencias, 0), 0),
    nullif(trim(coalesce(p_url_pasta_evidencias, '')), ''),
    p_conformidade_percentual,
    nullif(trim(coalesce(p_status_conformidade, '')), ''),
    greatest(coalesce(p_pendencias_abertas, 0), 0),
    greatest(coalesce(p_pendencias_resolvidas, 0), 0),
    p_valor_referenciado,
    coalesce(nullif(trim(coalesce(p_moeda, '')), ''), 'BRL'),
    nullif(trim(coalesce(p_responsavel_prestacao, '')), ''),
    coalesce(nullif(trim(coalesce(p_status_prestacao, '')), ''), 'Em preparacao'),
    p_data_fechamento,
    nullif(trim(coalesce(p_observacoes, '')), ''),
    v_payload_base,
    'validado'
  )
  on conflict (codigo_prestacao_contas) do update set
    nome_prestacao_contas = excluded.nome_prestacao_contas,
    periodo_inicio = excluded.periodo_inicio,
    periodo_fim = excluded.periodo_fim,
    codigo_status_operacional = excluded.codigo_status_operacional,
    resumo_operacional = excluded.resumo_operacional,
    total_evidencias = excluded.total_evidencias,
    url_pasta_evidencias = excluded.url_pasta_evidencias,
    conformidade_percentual = excluded.conformidade_percentual,
    status_conformidade = excluded.status_conformidade,
    pendencias_abertas = excluded.pendencias_abertas,
    pendencias_resolvidas = excluded.pendencias_resolvidas,
    valor_referenciado = excluded.valor_referenciado,
    moeda = excluded.moeda,
    responsavel_prestacao = excluded.responsavel_prestacao,
    status_prestacao = excluded.status_prestacao,
    data_fechamento = excluded.data_fechamento,
    observacoes = excluded.observacoes,
    payload = pc.payload || excluded.payload,
    sync_status = 'validado',
    updated_at = now()
  returning pc.id_prestacao_contas into v_id_prestacao;

  insert into unidade_agricola.fractal_resumo_operacional_unidade (id_unidade_agricola, id_origem, status, payload, sync_status)
  values (
    v_id_unidade,
    'sub10:' || v_id_prestacao::text,
    'validado',
    jsonb_build_object('id_prestacao_contas', v_id_prestacao, 'resumo_operacional', p_resumo_operacional, 'periodo_inicio', p_periodo_inicio, 'periodo_fim', p_periodo_fim),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_resumo_operacional_unidade.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '01_fractal_resumo_operacional_unidade', 'validado', jsonb_build_object('id_prestacao_contas', v_id_prestacao));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_evidencias_suporte (id_unidade_agricola, id_origem, status, payload, sync_status)
  values (
    v_id_unidade,
    'sub10:' || v_id_prestacao::text,
    'validado',
    jsonb_build_object('id_prestacao_contas', v_id_prestacao, 'total_evidencias', greatest(coalesce(p_total_evidencias, 0), 0), 'url_pasta_evidencias', p_url_pasta_evidencias),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_evidencias_suporte.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '02_fractal_evidencias_suporte', 'validado', jsonb_build_object('id_prestacao_contas', v_id_prestacao));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_indicadores_conformidade (id_unidade_agricola, id_origem, status, payload, sync_status)
  values (
    v_id_unidade,
    'sub10:' || v_id_prestacao::text,
    'validado',
    jsonb_build_object('id_prestacao_contas', v_id_prestacao, 'conformidade_percentual', p_conformidade_percentual, 'status_conformidade', p_status_conformidade),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_indicadores_conformidade.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '03_fractal_indicadores_conformidade', 'validado', jsonb_build_object('id_prestacao_contas', v_id_prestacao));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_pendencias_abertas (id_unidade_agricola, id_origem, status, payload, sync_status)
  values (
    v_id_unidade,
    'sub10:' || v_id_prestacao::text,
    'validado',
    jsonb_build_object('id_prestacao_contas', v_id_prestacao, 'pendencias_abertas', greatest(coalesce(p_pendencias_abertas, 0), 0), 'pendencias_resolvidas', greatest(coalesce(p_pendencias_resolvidas, 0), 0)),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_pendencias_abertas.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '04_fractal_pendencias_abertas', 'validado', jsonb_build_object('id_prestacao_contas', v_id_prestacao));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_historico_atualizacoes (id_unidade_agricola, id_origem, status, payload, sync_status)
  values (
    v_id_unidade,
    'sub10:' || v_id_prestacao::text,
    'validado',
    jsonb_build_object('id_prestacao_contas', v_id_prestacao, 'status_prestacao', p_status_prestacao, 'data_fechamento', p_data_fechamento, 'registrado_em', now()),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_historico_atualizacoes.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '05_fractal_historico_atualizacoes', 'validado', jsonb_build_object('id_prestacao_contas', v_id_prestacao));
  v_eventos := v_eventos + 1;

  insert into unidade_agricola.fractal_integracao_financeiro_admin_auditoria (id_unidade_agricola, id_origem, status, payload, sync_status)
  values (
    v_id_unidade,
    'sub10:' || v_id_prestacao::text,
    'validado',
    jsonb_build_object(
      'id_prestacao_contas', v_id_prestacao,
      'valor_referenciado', p_valor_referenciado,
      'moeda', coalesce(nullif(trim(coalesce(p_moeda, '')), ''), 'BRL'),
      'integrar_financeiro', true,
      'integrar_administrativo', true,
      'integrar_auditoria', true,
      'integrar_datalake', true,
      'modulos_consumidores_base', jsonb_build_array('Mod_Gestao_Financeira', 'Mod_Gestao_Administrativa', 'Mod_Gestao_Auditoria_Conformidade', 'Mod_Gestao_Dados_DataLake', 'Mod_Gestao_Genius_Hub')
    ),
    'validado'
  )
  returning id_fractal_registro into v_id_fractal;

  perform unidade_agricola.registrar_evento_fractal('unidade_agricola.fractal_integracao_financeiro_admin_auditoria.validado', v_id_unidade, v_id_fractal, 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '06_fractal_integracao_financeiro_admin_auditoria', 'validado', jsonb_build_object('id_prestacao_contas', v_id_prestacao, 'integrar_auditoria', true));
  v_eventos := v_eventos + 1;

  return query
  select
    pc.id_prestacao_contas,
    pc.id_unidade_agricola,
    pc.codigo_unidade,
    pc.codigo_prestacao_contas,
    pc.nome_prestacao_contas,
    pc.status_prestacao,
    v_status_fractais,
    v_eventos
  from unidade_agricola.sub10_prestacao_contas_unidade pc
  where pc.id_prestacao_contas = v_id_prestacao;
end;
$$;

create or replace view unidade_agricola.vw_sub10_validacao_prestacao_contas as
select
  pc.id_prestacao_contas,
  pc.id_unidade_agricola,
  pc.codigo_unidade,
  pc.codigo_prestacao_contas,
  pc.nome_prestacao_contas,
  pc.periodo_inicio,
  pc.periodo_fim,
  pc.status_prestacao,
  pc.status_conformidade,
  pc.conformidade_percentual,
  pc.total_evidencias,
  pc.pendencias_abertas,
  (coalesce(trim(pc.codigo_prestacao_contas), '') <> '') as possui_codigo_prestacao,
  (coalesce(trim(pc.nome_prestacao_contas), '') <> '') as possui_nome_prestacao,
  (pc.periodo_inicio is not null and pc.periodo_fim is not null and pc.periodo_fim >= pc.periodo_inicio) as possui_periodo_valido,
  (pc.id_unidade_agricola is not null and u.id_unidade_agricola is not null) as possui_unidade_vinculada,
  (coalesce(pc.total_evidencias, 0) > 0 or coalesce(trim(coalesce(pc.url_pasta_evidencias, '')), '') <> '') as possui_evidencia_suporte,
  case
    when u.id_unidade_agricola is null then 'erro'
    when coalesce(trim(pc.codigo_prestacao_contas), '') = '' then 'erro'
    when coalesce(trim(pc.nome_prestacao_contas), '') = '' then 'erro'
    when pc.periodo_inicio is null or pc.periodo_fim is null or pc.periodo_fim < pc.periodo_inicio then 'erro'
    when coalesce(pc.pendencias_abertas, 0) > 0 then 'atencao'
    when pc.conformidade_percentual is not null and pc.conformidade_percentual < 80 then 'atencao'
    else 'saudavel'
  end as status_validacao,
  pc.updated_at
from unidade_agricola.sub10_prestacao_contas_unidade pc
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = pc.id_unidade_agricola;

create or replace view unidade_agricola.vw_sub10_fractais_status_prestacao as
select
  pc.id_prestacao_contas,
  pc.codigo_prestacao_contas,
  pc.codigo_unidade,
  pc.nome_prestacao_contas,
  x.ordem_fractal,
  x.fractal,
  x.nome_fractal,
  x.status,
  x.sync_status,
  x.updated_at
from unidade_agricola.sub10_prestacao_contas_unidade pc
cross join lateral (
  values
    (1, '01_fractal_resumo_operacional_unidade', 'Resumo operacional da unidade', (select f.status from unidade_agricola.fractal_resumo_operacional_unidade f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_resumo_operacional_unidade f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_resumo_operacional_unidade f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1)),
    (2, '02_fractal_evidencias_suporte', 'Evidencias e suporte', (select f.status from unidade_agricola.fractal_evidencias_suporte f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_evidencias_suporte f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_evidencias_suporte f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1)),
    (3, '03_fractal_indicadores_conformidade', 'Indicadores de conformidade', (select f.status from unidade_agricola.fractal_indicadores_conformidade f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_indicadores_conformidade f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_indicadores_conformidade f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1)),
    (4, '04_fractal_pendencias_abertas', 'Pendencias abertas', (select f.status from unidade_agricola.fractal_pendencias_abertas f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_pendencias_abertas f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_pendencias_abertas f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1)),
    (5, '05_fractal_historico_atualizacoes', 'Historico de atualizacoes', (select f.status from unidade_agricola.fractal_historico_atualizacoes f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_historico_atualizacoes f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_historico_atualizacoes f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1)),
    (6, '06_fractal_integracao_financeiro_admin_auditoria', 'Integracao financeiro admin auditoria', (select f.status from unidade_agricola.fractal_integracao_financeiro_admin_auditoria f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.sync_status from unidade_agricola.fractal_integracao_financeiro_admin_auditoria f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1), (select f.updated_at from unidade_agricola.fractal_integracao_financeiro_admin_auditoria f where f.id_origem = 'sub10:' || pc.id_prestacao_contas::text order by f.updated_at desc limit 1))
) as x(ordem_fractal, fractal, nome_fractal, status, sync_status, updated_at);

create or replace view unidade_agricola.vw_sub10_prestacao_contas_operacional as
select
  pc.id_prestacao_contas,
  pc.id_unidade_agricola,
  pc.codigo_unidade,
  u.nome_unidade,
  pc.codigo_prestacao_contas,
  pc.nome_prestacao_contas,
  pc.periodo_inicio,
  pc.periodo_fim,
  pc.codigo_status_operacional,
  pc.total_evidencias,
  pc.conformidade_percentual,
  pc.status_conformidade,
  pc.pendencias_abertas,
  pc.pendencias_resolvidas,
  pc.valor_referenciado,
  pc.moeda,
  pc.responsavel_prestacao,
  pc.status_prestacao,
  pc.data_fechamento,
  v.status_validacao,
  count(fs.fractal) filter (where fs.status = 'validado') as fractais_validados,
  count(fs.fractal) as total_fractais_sub10,
  case
    when count(fs.fractal) filter (where fs.status = 'validado') = 6
     and v.status_validacao in ('saudavel', 'atencao')
    then true
    else false
  end as pronto_para_modulos_dependentes,
  pc.sync_status,
  pc.updated_at
from unidade_agricola.sub10_prestacao_contas_unidade pc
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = pc.id_unidade_agricola
left join unidade_agricola.vw_sub10_validacao_prestacao_contas v
  on v.id_prestacao_contas = pc.id_prestacao_contas
left join unidade_agricola.vw_sub10_fractais_status_prestacao fs
  on fs.id_prestacao_contas = pc.id_prestacao_contas
group by
  pc.id_prestacao_contas,
  pc.id_unidade_agricola,
  pc.codigo_unidade,
  u.nome_unidade,
  pc.codigo_prestacao_contas,
  pc.nome_prestacao_contas,
  pc.periodo_inicio,
  pc.periodo_fim,
  pc.codigo_status_operacional,
  pc.total_evidencias,
  pc.conformidade_percentual,
  pc.status_conformidade,
  pc.pendencias_abertas,
  pc.pendencias_resolvidas,
  pc.valor_referenciado,
  pc.moeda,
  pc.responsavel_prestacao,
  pc.status_prestacao,
  pc.data_fechamento,
  v.status_validacao,
  pc.sync_status,
  pc.updated_at;

insert into unidade_agricola.contratos_operacionais_modulo (
  modulo,
  submodulo,
  fractal,
  tipo_contrato,
  versao,
  contrato
) values (
  'Mod_Gestao_Unidade_Agricola',
  '10_sub_prestacao_contas_unidade',
  null,
  'backend_submodulo',
  '0.1.0',
  jsonb_build_object(
    'depende_de', jsonb_build_array('01_sub_cadastro_unidades_agricolas', '09_sub_status_operacional_unidade'),
    'fecha_processo_do_modulo', true,
    'nao_substitui_relatorios_dos_submodulos', true,
    'chaves_integracao', jsonb_build_array('id_unidade_agricola', 'codigo_unidade', 'codigo_prestacao_contas', 'codigo_status_operacional'),
    'entrada_principal', 'unidade_agricola.salvar_sub10_prestacao_contas_unidade',
    'views_publicadas', jsonb_build_array('vw_sub10_prestacao_contas_operacional', 'vw_sub10_fractais_status_prestacao', 'vw_sub10_validacao_prestacao_contas'),
    'eventos_publicados', jsonb_build_array(
      'unidade_agricola.fractal_resumo_operacional_unidade.validado',
      'unidade_agricola.fractal_evidencias_suporte.validado',
      'unidade_agricola.fractal_indicadores_conformidade.validado',
      'unidade_agricola.fractal_pendencias_abertas.validado',
      'unidade_agricola.fractal_historico_atualizacoes.validado',
      'unidade_agricola.fractal_integracao_financeiro_admin_auditoria.validado'
    ),
    'modulos_consumidores_preferenciais', jsonb_build_array('Mod_Gestao_Financeira', 'Mod_Gestao_Administrativa', 'Mod_Gestao_Auditoria_Conformidade', 'Mod_Gestao_Dados_DataLake', 'Mod_Gestao_Dashboards_BI', 'Mod_Gestao_Genius_Hub')
  )
)
on conflict (modulo, submodulo, (coalesce(fractal, '')), tipo_contrato) do update set
  versao = excluded.versao,
  contrato = excluded.contrato,
  ativo = true,
  updated_at = now();

create or replace view unidade_agricola.vw_sub10_contrato_backend as
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
  and submodulo = '10_sub_prestacao_contas_unidade'
  and tipo_contrato = 'backend_submodulo';

grant usage on schema unidade_agricola to anon, authenticated;

grant select on
  unidade_agricola.sub10_prestacao_contas_unidade,
  unidade_agricola.vw_sub10_prestacao_contas_operacional,
  unidade_agricola.vw_sub10_fractais_status_prestacao,
  unidade_agricola.vw_sub10_validacao_prestacao_contas,
  unidade_agricola.vw_sub10_contrato_backend
to anon, authenticated;

revoke execute on function unidade_agricola.salvar_sub10_prestacao_contas_unidade(
  text, text, text, date, date, text, text, integer, text, numeric, text, integer, integer, numeric, text, text, text, date, text, text, jsonb
) from public, anon;

grant execute on function unidade_agricola.salvar_sub10_prestacao_contas_unidade(
  text, text, text, date, date, text, text, integer, text, numeric, text, integer, integer, numeric, text, text, text, date, text, text, jsonb
) to authenticated;
