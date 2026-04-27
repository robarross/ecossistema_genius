-- TESTES_VIEW_LIBERACAO_PLUG_PLAY_ECOSSISTEMA.sql
-- Teste manual da matriz de liberacao plug and play do modulo.

select
  codigo_unidade,
  modulo_consumidor,
  categoria_consumo,
  liberado,
  motivo,
  status_origem
from unidade_agricola.vw_modulo_unidade_agricola_liberacao_ecossistema
where codigo_unidade = 'PA-SUB01-TESTE-001'
order by ordem_consumo;

select
  codigo_unidade,
  count(*) as total_modulos_consumidores,
  count(*) filter (where liberado) as total_liberados,
  count(*) filter (where not liberado) as total_bloqueados
from unidade_agricola.vw_modulo_unidade_agricola_liberacao_ecossistema
where codigo_unidade = 'PA-SUB01-TESTE-001'
group by codigo_unidade;

select
  codigo_unidade,
  modulo_consumidor,
  submodulos_chave
from unidade_agricola.vw_modulo_unidade_agricola_liberacao_ecossistema
where codigo_unidade = 'PA-SUB01-TESTE-001'
  and modulo_consumidor in (
    'Mod_Construcoes_Rurais',
    'Mod_Gestao_Financeira',
    'Mod_Gestao_Cowork_Workspace',
    'Mod_Gestao_Dashboards_BI'
  )
order by ordem_consumo;
