-- 202604260008_views_relacionais_unidade_agricola.sql
-- Views relacionais por unidade agrícola.

create or replace view unidade_agricola.vw_unidade_proprietarios as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  f.id_fractal_registro,
  f.status,
  f.sync_status,
  f.payload->>'nome_titular' as nome_titular,
  f.payload->>'documento_titular' as documento_titular,
  f.payload->>'tipo_titular' as tipo_titular,
  f.payload->>'tipo_vinculo' as tipo_vinculo,
  f.payload->>'percentual_participacao' as percentual_participacao,
  f.payload->>'telefone' as telefone,
  f.payload->>'email' as email,
  f.payload->>'observacoes' as observacoes,
  f.created_at,
  f.updated_at
from unidade_agricola.fractal_cadastro_proprietarios f
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = f.id_unidade_agricola;

comment on view unidade_agricola.vw_unidade_proprietarios is
'Proprietários/possuidores vinculados a cada unidade agrícola.';

create or replace view unidade_agricola.vw_unidade_responsaveis as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  f.id_fractal_registro,
  f.status,
  f.sync_status,
  f.payload->>'nome_responsavel' as nome_responsavel,
  f.payload->>'documento_responsavel' as documento_responsavel,
  f.payload->>'tipo_responsabilidade' as tipo_responsabilidade,
  f.payload->>'cargo_funcao' as cargo_funcao,
  f.payload->>'telefone' as telefone,
  f.payload->>'email' as email,
  f.payload->>'nivel_autorizacao' as nivel_autorizacao,
  f.payload->>'principal' as principal,
  f.payload->>'observacoes' as observacoes,
  f.created_at,
  f.updated_at
from unidade_agricola.fractal_cadastro_responsaveis f
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = f.id_unidade_agricola;

comment on view unidade_agricola.vw_unidade_responsaveis is
'Responsáveis e gestores vinculados a cada unidade agrícola.';

create or replace view unidade_agricola.vw_unidade_areas_produtivas as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  f.id_fractal_registro,
  f.status,
  f.sync_status,
  f.payload->>'codigo_area' as codigo_area,
  f.payload->>'nome_area' as nome_area,
  f.payload->>'tipo_area' as tipo_area,
  nullif(f.payload->>'area_ha', '')::numeric as area_ha,
  f.payload->>'uso_atual' as uso_atual,
  f.payload->>'cultura_atividade' as cultura_atividade,
  nullif(f.payload->>'latitude_centroide', '')::numeric as latitude_centroide,
  nullif(f.payload->>'longitude_centroide', '')::numeric as longitude_centroide,
  f.payload->>'status_area' as status_area,
  f.payload->>'observacoes' as observacoes,
  f.created_at,
  f.updated_at
from unidade_agricola.fractal_areas_produtivas f
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = f.id_unidade_agricola;

comment on view unidade_agricola.vw_unidade_areas_produtivas is
'Áreas, glebas e talhões produtivos vinculados a cada unidade agrícola.';

create or replace view unidade_agricola.vw_unidade_eventos_timeline as
select
  u.id_unidade_agricola,
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
join unidade_agricola.unidades_agricolas u
  on u.id_unidade_agricola = e.id_unidade_agricola;

comment on view unidade_agricola.vw_unidade_eventos_timeline is
'Linha do tempo de eventos por unidade agrícola.';

create or replace view unidade_agricola.vw_unidade_relacional_resumo as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.tipo_unidade,
  u.status_cadastro,
  u.situacao_operacional,
  u.uf,
  u.municipio,
  u.area_total_ha,
  u.sync_status,
  count(distinct p.id_fractal_registro) as total_proprietarios_possuidores,
  count(distinct r.id_fractal_registro) as total_responsaveis_gestores,
  count(distinct a.id_fractal_registro) as total_areas_produtivas,
  coalesce(sum(distinct a.area_ha), 0) as area_produtiva_importada_ha,
  count(distinct e.id_evento) as total_eventos,
  count(distinct e.id_evento) filter (where e.status = 'validado') as eventos_validados,
  count(distinct e.id_evento) filter (where e.status = 'erro') as eventos_com_erro,
  max(e.published_at) as ultimo_evento_em
from unidade_agricola.unidades_agricolas u
left join unidade_agricola.vw_unidade_proprietarios p
  on p.id_unidade_agricola = u.id_unidade_agricola
left join unidade_agricola.vw_unidade_responsaveis r
  on r.id_unidade_agricola = u.id_unidade_agricola
left join unidade_agricola.vw_unidade_areas_produtivas a
  on a.id_unidade_agricola = u.id_unidade_agricola
left join unidade_agricola.fractal_eventos_log e
  on e.id_unidade_agricola = u.id_unidade_agricola
group by
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.tipo_unidade,
  u.status_cadastro,
  u.situacao_operacional,
  u.uf,
  u.municipio,
  u.area_total_ha,
  u.sync_status;

comment on view unidade_agricola.vw_unidade_relacional_resumo is
'Resumo relacional por unidade com proprietários, responsáveis, áreas e eventos.';
