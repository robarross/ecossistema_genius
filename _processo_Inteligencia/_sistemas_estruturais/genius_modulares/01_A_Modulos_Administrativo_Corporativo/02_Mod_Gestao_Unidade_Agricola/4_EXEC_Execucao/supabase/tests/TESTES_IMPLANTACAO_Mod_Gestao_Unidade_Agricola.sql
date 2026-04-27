-- TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql
-- Consultas rápidas para validar se a migration e o seed foram aplicados.

select 'schemas' as teste, count(*) as total
from information_schema.schemata
where schema_name = 'unidade_agricola';

select 'tabelas_unidade_agricola' as teste, count(*) as total
from information_schema.tables
where table_schema = 'unidade_agricola';

select 'eventos_catalogados' as teste, count(*) as total
from unidade_agricola.fractal_eventos_catalogo;

select 'unidades_seed' as teste, count(*) as total
from unidade_agricola.unidades_agricolas
where codigo_unidade = 'PA-SEED-0001';

select 'eventos_seed' as teste, count(*) as total
from unidade_agricola.fractal_eventos_log
where payload->>'origem' = 'seed';

select
  u.codigo_unidade,
  u.nome_unidade,
  u.status_cadastro,
  f.status as status_fractal_identidade,
  f.sync_status
from unidade_agricola.unidades_agricolas u
left join unidade_agricola.fractal_identidade_unidade f
  on f.id_unidade_agricola = u.id_unidade_agricola
where u.codigo_unidade = 'PA-SEED-0001';
