-- 202604260012_views_unidades_prontas_ecossistema.sql
-- Views de liberação das unidades agrícolas para consumo por outros módulos do ecossistema Genius.

create or replace view unidade_agricola.vw_unidades_agricolas_prontas_ecossistema as
select
  r.id_unidade_agricola,
  r.codigo_unidade,
  r.nome_unidade,
  r.tipo_unidade,
  r.status_cadastro,
  r.situacao_operacional,
  r.uf,
  r.municipio,
  r.area_total_ha,
  r.sync_status,
  r.total_proprietarios_possuidores,
  r.total_responsaveis_gestores,
  r.total_areas_produtivas,
  r.area_produtiva_importada_ha,
  r.total_eventos,
  r.eventos_validados,
  r.eventos_com_erro,
  case
    when r.status_cadastro <> 'Ativo' then false
    when r.sync_status <> 'validado' then false
    when r.total_proprietarios_possuidores = 0 then false
    when r.total_responsaveis_gestores = 0 then false
    when r.total_areas_produtivas = 0 then false
    when r.eventos_com_erro > 0 then false
    when exists (
      select 1
      from unidade_agricola.vw_auditoria_unidades_incompletas i
      where i.id_unidade_agricola = r.id_unidade_agricola
    ) then false
    when exists (
      select 1
      from unidade_agricola.vw_auditoria_areas_inconsistentes a
      where a.id_unidade_agricola = r.id_unidade_agricola
    ) then false
    else true
  end as pronta_ecossistema,
  array_remove(array[
    case when r.status_cadastro <> 'Ativo' then 'status_cadastro_nao_ativo' end,
    case when r.sync_status <> 'validado' then 'sync_status_nao_validado' end,
    case when r.total_proprietarios_possuidores = 0 then 'sem_proprietario_possuidor' end,
    case when r.total_responsaveis_gestores = 0 then 'sem_responsavel_gestor' end,
    case when r.total_areas_produtivas = 0 then 'sem_area_produtiva' end,
    case when r.eventos_com_erro > 0 then 'eventos_com_erro' end,
    case when exists (
      select 1
      from unidade_agricola.vw_auditoria_unidades_incompletas i
      where i.id_unidade_agricola = r.id_unidade_agricola
    ) then 'cadastro_incompleto' end,
    case when exists (
      select 1
      from unidade_agricola.vw_auditoria_areas_inconsistentes a
      where a.id_unidade_agricola = r.id_unidade_agricola
    ) then 'area_inconsistente' end
  ], null) as motivos_bloqueio,
  case
    when r.status_cadastro = 'Ativo'
      and r.sync_status = 'validado'
      and r.total_proprietarios_possuidores > 0
      and r.total_responsaveis_gestores > 0
      and r.total_areas_produtivas > 0
      and r.eventos_com_erro = 0
    then array[
      'Mod_Gestao_Producao_Vegetal',
      'Mod_Gestao_Producao_Animal_Pecuaria',
      'Mod_Gestao_Georreferenciamento',
      'Mod_Gestao_Regularizacao_Fundiaria',
      'Mod_Gestao_Financeira',
      'Mod_Gestao_Fiscal_Tributaria',
      'Mod_Gestao_Marketplace_Agricola',
      'Mod_Gestao_Dashboards_BI',
      'Mod_Gestao_Dados_DataLake',
      'Mod_Gestao_Genius_Hub'
    ]
    else array[]::text[]
  end as modulos_consumidores_liberados,
  now() as avaliado_em
from unidade_agricola.vw_unidade_relacional_resumo r;

comment on view unidade_agricola.vw_unidades_agricolas_prontas_ecossistema is
'Unidades agrícolas avaliadas para consumo por módulos do ecossistema Genius.';

create or replace view unidade_agricola.vw_unidades_bloqueadas_ecossistema as
select *
from unidade_agricola.vw_unidades_agricolas_prontas_ecossistema
where pronta_ecossistema = false;

comment on view unidade_agricola.vw_unidades_bloqueadas_ecossistema is
'Unidades agrícolas bloqueadas para consumo por outros módulos, com motivos.';

create or replace view unidade_agricola.vw_matriz_consumo_modulos_unidade_agricola as
select
  codigo_unidade,
  nome_unidade,
  unnest(modulos_consumidores_liberados) as modulo_consumidor,
  pronta_ecossistema,
  avaliado_em
from unidade_agricola.vw_unidades_agricolas_prontas_ecossistema
where pronta_ecossistema = true;

comment on view unidade_agricola.vw_matriz_consumo_modulos_unidade_agricola is
'Matriz unidade agrícola x módulos consumidores liberados.';

create or replace view unidade_agricola.vw_resumo_liberacao_ecossistema as
select
  count(*) as total_unidades,
  count(*) filter (where pronta_ecossistema) as unidades_prontas,
  count(*) filter (where not pronta_ecossistema) as unidades_bloqueadas,
  case
    when count(*) = 0 then 0
    else round((count(*) filter (where pronta_ecossistema)::numeric / count(*)::numeric) * 100, 2)
  end as perc_unidades_prontas,
  case
    when count(*) filter (where not pronta_ecossistema) = 0 then 'saudavel'
    else 'atencao'
  end as status_liberacao,
  now() as atualizado_em
from unidade_agricola.vw_unidades_agricolas_prontas_ecossistema;

comment on view unidade_agricola.vw_resumo_liberacao_ecossistema is
'Resumo de liberação das unidades agrícolas para consumo pelo ecossistema Genius.';
