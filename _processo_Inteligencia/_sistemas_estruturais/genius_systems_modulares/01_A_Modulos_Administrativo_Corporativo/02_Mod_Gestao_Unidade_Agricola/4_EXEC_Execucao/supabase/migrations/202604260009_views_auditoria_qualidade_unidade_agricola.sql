-- 202604260009_views_auditoria_qualidade_unidade_agricola.sql
-- Views de auditoria e qualidade dos dados do Mod_Gestao_Unidade_Agricola.

create or replace view unidade_agricola.vw_auditoria_unidades_incompletas as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.status_cadastro,
  u.sync_status,
  array_remove(array[
    case when coalesce(trim(u.codigo_unidade), '') = '' then 'codigo_unidade' end,
    case when coalesce(trim(u.nome_unidade), '') = '' then 'nome_unidade' end,
    case when coalesce(trim(u.status_cadastro), '') = '' then 'status_cadastro' end,
    case when coalesce(trim(u.uf), '') = '' then 'uf' end,
    case when coalesce(trim(u.municipio), '') = '' then 'municipio' end,
    case when u.area_total_ha is null then 'area_total_ha' end
  ], null) as campos_pendentes,
  cardinality(array_remove(array[
    case when coalesce(trim(u.codigo_unidade), '') = '' then 'codigo_unidade' end,
    case when coalesce(trim(u.nome_unidade), '') = '' then 'nome_unidade' end,
    case when coalesce(trim(u.status_cadastro), '') = '' then 'status_cadastro' end,
    case when coalesce(trim(u.uf), '') = '' then 'uf' end,
    case when coalesce(trim(u.municipio), '') = '' then 'municipio' end,
    case when u.area_total_ha is null then 'area_total_ha' end
  ], null)) as total_campos_pendentes
from unidade_agricola.unidades_agricolas u
where
  coalesce(trim(u.codigo_unidade), '') = ''
  or coalesce(trim(u.nome_unidade), '') = ''
  or coalesce(trim(u.status_cadastro), '') = ''
  or coalesce(trim(u.uf), '') = ''
  or coalesce(trim(u.municipio), '') = ''
  or u.area_total_ha is null;

comment on view unidade_agricola.vw_auditoria_unidades_incompletas is
'Unidades agrícolas com campos cadastrais mínimos ausentes.';

create or replace view unidade_agricola.vw_auditoria_unidades_sem_vinculos as
select
  r.id_unidade_agricola,
  r.codigo_unidade,
  r.nome_unidade,
  r.total_proprietarios_possuidores,
  r.total_responsaveis_gestores,
  r.total_areas_produtivas,
  case when r.total_proprietarios_possuidores = 0 then true else false end as sem_proprietario_possuidor,
  case when r.total_responsaveis_gestores = 0 then true else false end as sem_responsavel_gestor,
  case when r.total_areas_produtivas = 0 then true else false end as sem_area_produtiva
from unidade_agricola.vw_unidade_relacional_resumo r
where
  r.total_proprietarios_possuidores = 0
  or r.total_responsaveis_gestores = 0
  or r.total_areas_produtivas = 0;

comment on view unidade_agricola.vw_auditoria_unidades_sem_vinculos is
'Unidades sem proprietário/possuidor, responsável/gestor ou área produtiva vinculada.';

create or replace view unidade_agricola.vw_auditoria_eventos_erros as
select
  u.codigo_unidade,
  u.nome_unidade,
  e.id_evento,
  e.nome_evento,
  e.submodulo_origem,
  e.fractal_origem,
  e.status,
  e.payload,
  e.published_at
from unidade_agricola.fractal_eventos_log e
left join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = e.id_unidade_agricola
where e.status = 'erro';

comment on view unidade_agricola.vw_auditoria_eventos_erros is
'Eventos de fractais com status de erro.';

create or replace view unidade_agricola.vw_auditoria_unidades_sem_identidade as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.status_cadastro,
  u.sync_status
from unidade_agricola.unidades_agricolas u
left join unidade_agricola.fractal_eventos_log e
  on e.id_unidade_agricola = u.id_unidade_agricola
  and e.fractal_origem = '01_fractal_identidade_unidade'
  and e.status = 'validado'
where e.id_evento is null;

comment on view unidade_agricola.vw_auditoria_unidades_sem_identidade is
'Unidades sem evento validado do fractal de identidade.';

create or replace view unidade_agricola.vw_auditoria_areas_inconsistentes as
select
  r.id_unidade_agricola,
  r.codigo_unidade,
  r.nome_unidade,
  r.area_total_ha,
  r.area_produtiva_importada_ha,
  case
    when r.area_produtiva_importada_ha > r.area_total_ha then 'area_produtiva_maior_que_area_total'
    when r.area_produtiva_importada_ha = 0 and r.total_areas_produtivas > 0 then 'areas_sem_area_ha'
    else null
  end as tipo_inconsistencia
from unidade_agricola.vw_unidade_relacional_resumo r
where
  r.area_produtiva_importada_ha > r.area_total_ha
  or (r.area_produtiva_importada_ha = 0 and r.total_areas_produtivas > 0);

comment on view unidade_agricola.vw_auditoria_areas_inconsistentes is
'Inconsistências entre área total da unidade e áreas produtivas importadas.';

create or replace view unidade_agricola.vw_auditoria_importacoes_pendentes as
select
  'unidades_agricolas' as origem,
  lote_importacao,
  status_importacao,
  count(*) as total
from unidade_agricola.import_planilha_unidades_agricolas
where status_importacao in ('pendente', 'erro')
group by lote_importacao, status_importacao
union all
select
  origem,
  lote_importacao,
  status_importacao,
  total
from unidade_agricola.vw_importacao_submodulos_base_status
where status_importacao in ('pendente', 'erro');

comment on view unidade_agricola.vw_auditoria_importacoes_pendentes is
'Lotes de importação ainda pendentes ou com erro.';

create or replace view unidade_agricola.vw_auditoria_qualidade_resumo as
select
  (select count(*) from unidade_agricola.vw_auditoria_unidades_incompletas) as unidades_incompletas,
  (select count(*) from unidade_agricola.vw_auditoria_unidades_sem_vinculos) as unidades_sem_vinculos,
  (select count(*) from unidade_agricola.vw_auditoria_eventos_erros) as eventos_com_erro,
  (select count(*) from unidade_agricola.vw_auditoria_unidades_sem_identidade) as unidades_sem_identidade,
  (select count(*) from unidade_agricola.vw_auditoria_areas_inconsistentes) as areas_inconsistentes,
  (select coalesce(sum(total), 0) from unidade_agricola.vw_auditoria_importacoes_pendentes) as importacoes_pendentes_erro,
  case
    when (select count(*) from unidade_agricola.vw_auditoria_eventos_erros) > 0 then 'erro'
    when (select count(*) from unidade_agricola.vw_auditoria_unidades_incompletas) > 0 then 'atencao'
    when (select count(*) from unidade_agricola.vw_auditoria_unidades_sem_vinculos) > 0 then 'atencao'
    when (select count(*) from unidade_agricola.vw_auditoria_areas_inconsistentes) > 0 then 'atencao'
    when (select coalesce(sum(total), 0) from unidade_agricola.vw_auditoria_importacoes_pendentes) > 0 then 'atencao'
    else 'saudavel'
  end as status_qualidade,
  now() as atualizado_em;

comment on view unidade_agricola.vw_auditoria_qualidade_resumo is
'Resumo executivo de qualidade e auditoria dos dados do módulo.';
