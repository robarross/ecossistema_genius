-- TESTES_UNIDADES_PRONTAS_ECOSSISTEMA_Mod_Gestao_Unidade_Agricola.sql

select *
from unidade_agricola.vw_resumo_liberacao_ecossistema;

select
  codigo_unidade,
  nome_unidade,
  pronta_ecossistema,
  motivos_bloqueio,
  cardinality(modulos_consumidores_liberados) as total_modulos_liberados
from unidade_agricola.vw_unidades_agricolas_prontas_ecossistema
order by codigo_unidade;

select 'bloqueadas' as teste, count(*) as total
from unidade_agricola.vw_unidades_bloqueadas_ecossistema;

select
  modulo_consumidor,
  count(*) as total_unidades_liberadas
from unidade_agricola.vw_matriz_consumo_modulos_unidade_agricola
group by modulo_consumidor
order by modulo_consumidor;
