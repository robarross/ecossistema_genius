-- TESTES_IMPORT_SUBMODULOS_BASE_Mod_Gestao_Unidade_Agricola.sql

select *
from unidade_agricola.vw_importacao_submodulos_base_status
order by origem, lote_importacao, status_importacao;

select 'proprietarios_importados' as teste, count(*) as total
from unidade_agricola.fractal_cadastro_proprietarios
where payload->>'lote_importacao' = 'lote_submodulos_base_001';

select 'responsaveis_importados' as teste, count(*) as total
from unidade_agricola.fractal_cadastro_responsaveis
where payload->>'lote_importacao' = 'lote_submodulos_base_001';

select 'areas_importadas' as teste, count(*) as total
from unidade_agricola.fractal_areas_produtivas
where payload->>'lote_importacao' = 'lote_submodulos_base_001';

select 'eventos_submodulos_base' as teste, count(*) as total
from unidade_agricola.fractal_eventos_log
where payload->>'lote_importacao' = 'lote_submodulos_base_001';

select *
from unidade_agricola.vw_dashboard_executivo_unidade_agricola;
