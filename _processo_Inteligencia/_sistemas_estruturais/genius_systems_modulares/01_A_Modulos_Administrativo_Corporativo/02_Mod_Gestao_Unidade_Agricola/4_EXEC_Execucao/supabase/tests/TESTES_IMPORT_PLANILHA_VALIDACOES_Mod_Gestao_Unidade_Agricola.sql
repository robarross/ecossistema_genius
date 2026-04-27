-- TESTES_IMPORT_PLANILHA_VALIDACOES_Mod_Gestao_Unidade_Agricola.sql

select *
from unidade_agricola.prevalidar_lote_importacao_planilha_unidades();

select *
from unidade_agricola.vw_importacao_planilha_unidades_prevalidacao
order by created_at desc
limit 20;

select *
from unidade_agricola.vw_importacao_planilha_unidades_erros
order by created_at desc
limit 20;

select *
from unidade_agricola.vw_importacao_planilha_unidades_status
order by lote_importacao, status_importacao;
