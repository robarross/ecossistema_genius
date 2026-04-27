-- TESTES_AUDITORIA_QUALIDADE_Mod_Gestao_Unidade_Agricola.sql

select *
from unidade_agricola.vw_auditoria_qualidade_resumo;

select 'unidades_incompletas' as teste, count(*) as total
from unidade_agricola.vw_auditoria_unidades_incompletas;

select 'unidades_sem_vinculos' as teste, count(*) as total
from unidade_agricola.vw_auditoria_unidades_sem_vinculos;

select 'eventos_erros' as teste, count(*) as total
from unidade_agricola.vw_auditoria_eventos_erros;

select 'unidades_sem_identidade' as teste, count(*) as total
from unidade_agricola.vw_auditoria_unidades_sem_identidade;

select 'areas_inconsistentes' as teste, count(*) as total
from unidade_agricola.vw_auditoria_areas_inconsistentes;

select 'importacoes_pendentes' as teste, coalesce(sum(total), 0) as total
from unidade_agricola.vw_auditoria_importacoes_pendentes;

select *
from unidade_agricola.vw_auditoria_unidades_sem_vinculos
order by codigo_unidade;
