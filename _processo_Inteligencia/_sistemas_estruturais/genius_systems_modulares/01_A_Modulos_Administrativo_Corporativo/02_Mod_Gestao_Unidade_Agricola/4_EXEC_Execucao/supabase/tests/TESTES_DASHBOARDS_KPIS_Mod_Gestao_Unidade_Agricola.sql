-- TESTES_DASHBOARDS_KPIS_Mod_Gestao_Unidade_Agricola.sql

select 'vw_kpis_unidade_agricola' as view_name, total_unidades, unidades_ativas, area_total_ha
from unidade_agricola.vw_kpis_unidade_agricola;

select
  'vw_dashboard_executivo_unidade_agricola' as view_name,
  total_unidades,
  eventos_catalogados,
  eventos_publicados,
  perc_unidades_ativas,
  perc_eventos_validados,
  status_executivo
from unidade_agricola.vw_dashboard_executivo_unidade_agricola;

select 'vw_pendencias_unidade_agricola' as view_name, count(*) as total_pendencias
from unidade_agricola.vw_pendencias_unidade_agricola;

select 'vw_sync_unidade_agricola' as view_name, sync_status, total_unidades
from unidade_agricola.vw_sync_unidade_agricola
order by sync_status;

select 'vw_fractais_status_unidade_agricola' as view_name, count(*) as total
from unidade_agricola.vw_fractais_status_unidade_agricola;

select
  codigo_unidade,
  nome_unidade,
  fractal_origem,
  eventos_publicados,
  eventos_validados,
  status_fractal_na_unidade
from unidade_agricola.vw_fractais_status_unidade_agricola
where codigo_unidade = 'PA-SEED-0001'
  and fractal_origem = '01_fractal_identidade_unidade';
