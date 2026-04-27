-- TESTES_VIEWS_RELACIONAIS_Mod_Gestao_Unidade_Agricola.sql

select 'vw_unidade_proprietarios' as view_name, count(*) as total
from unidade_agricola.vw_unidade_proprietarios;

select 'vw_unidade_responsaveis' as view_name, count(*) as total
from unidade_agricola.vw_unidade_responsaveis;

select 'vw_unidade_areas_produtivas' as view_name, count(*) as total
from unidade_agricola.vw_unidade_areas_produtivas;

select 'vw_unidade_eventos_timeline' as view_name, count(*) as total
from unidade_agricola.vw_unidade_eventos_timeline;

select
  codigo_unidade,
  nome_unidade,
  total_proprietarios_possuidores,
  total_responsaveis_gestores,
  total_areas_produtivas,
  area_produtiva_importada_ha,
  total_eventos,
  eventos_validados,
  eventos_com_erro
from unidade_agricola.vw_unidade_relacional_resumo
where codigo_unidade in ('PA-IMP-0002', 'PA-IMP-0003')
order by codigo_unidade;

select
  codigo_unidade,
  nome_unidade,
  fractal_origem,
  nome_evento,
  status,
  published_at
from unidade_agricola.vw_unidade_eventos_timeline
where codigo_unidade in ('PA-IMP-0002', 'PA-IMP-0003')
order by codigo_unidade, published_at;
