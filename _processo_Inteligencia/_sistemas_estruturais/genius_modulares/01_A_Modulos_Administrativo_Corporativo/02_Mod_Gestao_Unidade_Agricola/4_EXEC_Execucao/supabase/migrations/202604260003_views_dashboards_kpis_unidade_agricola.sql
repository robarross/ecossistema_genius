-- 202604260003_views_dashboards_kpis_unidade_agricola.sql
-- Views de dashboards e KPIs para o Mod_Gestao_Unidade_Agricola.

create or replace view unidade_agricola.vw_kpis_unidade_agricola as
select
  count(*) as total_unidades,
  count(*) filter (where status_cadastro = 'Ativo') as unidades_ativas,
  count(*) filter (where status_cadastro in ('Pendente', 'Em validacao', 'pendente')) as unidades_pendentes,
  count(*) filter (where sync_status in ('pendente', 'erro')) as unidades_sync_pendente_erro,
  coalesce(sum(area_total_ha), 0) as area_total_ha,
  coalesce(avg(area_total_ha), 0) as area_media_ha,
  count(distinct uf) as total_ufs,
  count(distinct municipio) as total_municipios,
  now() as atualizado_em
from unidade_agricola.unidades_agricolas;

comment on view unidade_agricola.vw_kpis_unidade_agricola is
'KPIs gerais do módulo Gestão da Unidade Agrícola.';

create or replace view unidade_agricola.vw_dashboard_executivo_unidade_agricola as
select
  k.total_unidades,
  k.unidades_ativas,
  k.unidades_pendentes,
  k.unidades_sync_pendente_erro,
  k.area_total_ha,
  k.area_media_ha,
  k.total_ufs,
  k.total_municipios,
  s.eventos_catalogados,
  s.eventos_publicados,
  s.eventos_validados,
  s.eventos_com_erro,
  case
    when k.total_unidades = 0 then 0
    else round((k.unidades_ativas::numeric / k.total_unidades::numeric) * 100, 2)
  end as perc_unidades_ativas,
  case
    when s.eventos_publicados = 0 then 0
    else round((s.eventos_validados::numeric / s.eventos_publicados::numeric) * 100, 2)
  end as perc_eventos_validados,
  case
    when k.unidades_sync_pendente_erro = 0 and s.eventos_com_erro = 0 then 'saudavel'
    when s.eventos_com_erro > 0 then 'erro'
    else 'atencao'
  end as status_executivo,
  now() as atualizado_em
from unidade_agricola.vw_kpis_unidade_agricola k
cross join unidade_agricola.vw_status_modulo_unidade_agricola s;

comment on view unidade_agricola.vw_dashboard_executivo_unidade_agricola is
'Dashboard executivo consolidado do módulo Gestão da Unidade Agrícola.';

create or replace view unidade_agricola.vw_pendencias_unidade_agricola as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  'sync_status' as tipo_pendencia,
  u.sync_status as status_origem,
  case
    when u.sync_status = 'erro' then 'critica'
    when u.sync_status = 'pendente' then 'media'
    else 'baixa'
  end as prioridade,
  'Unidade com sincronização pendente ou erro.' as descricao,
  u.updated_at as referencia_em
from unidade_agricola.unidades_agricolas u
where u.sync_status in ('pendente', 'erro')

union all

select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  'evento_erro' as tipo_pendencia,
  e.status as status_origem,
  'critica' as prioridade,
  'Evento de fractal com status de erro.' as descricao,
  e.published_at as referencia_em
from unidade_agricola.fractal_eventos_log e
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = e.id_unidade_agricola
where e.status = 'erro'

union all

select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  'cadastro_pendente' as tipo_pendencia,
  u.status_cadastro as status_origem,
  'media' as prioridade,
  'Unidade com cadastro pendente ou em validação.' as descricao,
  u.updated_at as referencia_em
from unidade_agricola.unidades_agricolas u
where u.status_cadastro in ('Pendente', 'Em validacao', 'pendente');

comment on view unidade_agricola.vw_pendencias_unidade_agricola is
'Pendências operacionais consolidadas por unidade agrícola.';

create or replace view unidade_agricola.vw_sync_unidade_agricola as
select
  sync_status,
  count(*) as total_unidades,
  min(updated_at) as primeiro_registro_em,
  max(updated_at) as ultimo_registro_em
from unidade_agricola.unidades_agricolas
group by sync_status

union all

select
  'eventos_' || status as sync_status,
  count(*) as total_unidades,
  min(published_at) as primeiro_registro_em,
  max(published_at) as ultimo_registro_em
from unidade_agricola.fractal_eventos_log
group by status;

comment on view unidade_agricola.vw_sync_unidade_agricola is
'Resumo de sincronização das unidades e eventos dos fractais.';

create or replace view unidade_agricola.vw_fractais_status_unidade_agricola as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  c.fractal_origem,
  c.submodulo_origem,
  c.tabela_origem,
  count(e.id_evento) as eventos_publicados,
  count(e.id_evento) filter (where e.status = 'validado') as eventos_validados,
  count(e.id_evento) filter (where e.status = 'erro') as eventos_com_erro,
  max(e.published_at) as ultimo_evento_em,
  case
    when count(e.id_evento) filter (where e.status = 'erro') > 0 then 'erro'
    when count(e.id_evento) filter (where e.status = 'validado') > 0 then 'validado'
    when count(e.id_evento) > 0 then 'em_andamento'
    else 'sem_evento'
  end as status_fractal_na_unidade
from unidade_agricola.unidades_agricolas u
cross join (
  select distinct fractal_origem, submodulo_origem, tabela_origem
  from unidade_agricola.fractal_eventos_catalogo
) c
left join unidade_agricola.fractal_eventos_log e
  on e.id_unidade_agricola = u.id_unidade_agricola
  and e.fractal_origem = c.fractal_origem
group by
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  c.fractal_origem,
  c.submodulo_origem,
  c.tabela_origem;

comment on view unidade_agricola.vw_fractais_status_unidade_agricola is
'Status de cada fractal por unidade agrícola, útil para dashboard, agentes e auditoria.';
