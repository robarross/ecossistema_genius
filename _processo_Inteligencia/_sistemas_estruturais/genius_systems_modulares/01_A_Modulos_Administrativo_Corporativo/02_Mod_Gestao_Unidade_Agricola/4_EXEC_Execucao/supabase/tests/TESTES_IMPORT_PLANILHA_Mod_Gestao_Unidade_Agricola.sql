-- TESTES_IMPORT_PLANILHA_Mod_Gestao_Unidade_Agricola.sql

select 'staging_import_planilha' as teste, count(*) as total
from unidade_agricola.import_planilha_unidades_agricolas;

select 'status_importacao' as teste, *
from unidade_agricola.vw_importacao_planilha_unidades_status
order by lote_importacao, status_importacao;

select 'unidades_importadas' as teste, codigo_unidade, nome_unidade, status_cadastro, sync_status
from unidade_agricola.unidades_agricolas
where codigo_unidade like 'PA-IMP-%'
order by codigo_unidade;

select 'eventos_importacao_planilha' as teste, count(*) as total
from unidade_agricola.fractal_eventos_log
where payload->>'origem' = 'planilha';
