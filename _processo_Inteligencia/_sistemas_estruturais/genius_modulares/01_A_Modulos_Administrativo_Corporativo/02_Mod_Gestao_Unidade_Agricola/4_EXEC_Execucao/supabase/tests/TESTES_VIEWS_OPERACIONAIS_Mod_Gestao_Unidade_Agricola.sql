-- TESTES_VIEWS_OPERACIONAIS_Mod_Gestao_Unidade_Agricola.sql

select 'vw_unidades_agricolas_resumo' as view_name, count(*) as total
from unidade_agricola.vw_unidades_agricolas_resumo;

select 'vw_eventos_fractais_resumo' as view_name, count(*) as total
from unidade_agricola.vw_eventos_fractais_resumo;

select 'vw_status_modulo_unidade_agricola' as view_name, total_unidades, eventos_catalogados, eventos_publicados
from unidade_agricola.vw_status_modulo_unidade_agricola;

select 'vw_fractais_catalogo_operacional' as view_name, count(*) as total
from unidade_agricola.vw_fractais_catalogo_operacional;

select
  codigo_unidade,
  nome_unidade,
  status_cadastro,
  sync_status,
  total_eventos,
  eventos_validados
from unidade_agricola.vw_unidades_agricolas_resumo
where codigo_unidade = 'PA-SEED-0001';

select
  fractal_origem,
  eventos_previstos,
  possui_evento_criado,
  possui_evento_atualizado,
  possui_evento_validado,
  possui_evento_sincronizado
from unidade_agricola.vw_fractais_catalogo_operacional
where fractal_origem = '01_fractal_identidade_unidade';
