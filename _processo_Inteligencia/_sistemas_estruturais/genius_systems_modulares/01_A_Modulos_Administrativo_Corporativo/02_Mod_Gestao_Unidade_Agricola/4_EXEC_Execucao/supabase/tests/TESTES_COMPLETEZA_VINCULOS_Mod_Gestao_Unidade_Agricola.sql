-- TESTES_COMPLETEZA_VINCULOS_Mod_Gestao_Unidade_Agricola.sql

select *
from unidade_agricola.vw_auditoria_qualidade_resumo;

select *
from unidade_agricola.vw_auditoria_unidades_sem_vinculos
order by codigo_unidade;

select
  codigo_unidade,
  nome_unidade,
  total_proprietarios_possuidores,
  total_responsaveis_gestores,
  total_areas_produtivas,
  total_eventos,
  eventos_validados,
  eventos_com_erro
from unidade_agricola.vw_unidade_relacional_resumo
order by codigo_unidade;

select
  payload->>'origem' as origem,
  count(*) as total_eventos
from unidade_agricola.fractal_eventos_log
where payload->>'origem' = 'completeza_vinculos'
group by payload->>'origem';
