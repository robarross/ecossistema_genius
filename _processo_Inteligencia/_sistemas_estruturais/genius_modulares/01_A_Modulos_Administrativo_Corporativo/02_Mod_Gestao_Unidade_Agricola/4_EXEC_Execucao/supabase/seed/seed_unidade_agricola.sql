-- seed_unidade_agricola.sql
-- Dados mínimos para testar o Mod_Gestao_Unidade_Agricola após executar a migration.

insert into unidade_agricola.unidades_agricolas (
  codigo_unidade,
  nome_unidade,
  tipo_unidade,
  status_cadastro,
  situacao_operacional,
  uf,
  municipio,
  latitude_sede,
  longitude_sede,
  area_total_ha,
  payload,
  sync_status
) values (
  'PA-SEED-0001',
  'Fazenda Piloto Genius',
  'Fazenda',
  'Ativo',
  'Em operacao',
  'AM',
  'Manaus',
  -3.1190,
  -60.0210,
  1250.50,
  '{"origem":"seed","modulo":"Mod_Gestao_Unidade_Agricola"}'::jsonb,
  'validado'
)
on conflict (codigo_unidade) do update set
  nome_unidade = excluded.nome_unidade,
  status_cadastro = excluded.status_cadastro,
  sync_status = excluded.sync_status,
  updated_at = now();

with unidade as (
  select id_unidade_agricola
  from unidade_agricola.unidades_agricolas
  where codigo_unidade = 'PA-SEED-0001'
  limit 1
), fractal as (
  insert into unidade_agricola.fractal_identidade_unidade (
    id_unidade_agricola,
    id_origem,
    status,
    payload,
    sync_status
  )
  select
    id_unidade_agricola,
    'seed_identidade_001',
    'validado',
    '{"codigo":"PA-SEED-0001","nome":"Fazenda Piloto Genius","tipo":"Fazenda"}'::jsonb,
    'validado'
  from unidade
  returning id_fractal_registro, id_unidade_agricola
)
insert into unidade_agricola.fractal_eventos_log (
  nome_evento,
  id_unidade_agricola,
  id_fractal_registro,
  modulo_origem,
  submodulo_origem,
  fractal_origem,
  status,
  payload
)
select
  'unidade_agricola.fractal_identidade_unidade.validado',
  id_unidade_agricola,
  id_fractal_registro,
  'Mod_Gestao_Unidade_Agricola',
  null,
  '01_fractal_identidade_unidade',
  'validado',
  '{"origem":"seed","acao":"validacao_inicial"}'::jsonb
from fractal;
