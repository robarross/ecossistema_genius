-- 202604260002_views_operacionais_unidade_agricola.sql
-- Views operacionais para dashboards, testes, agentes e consultas rápidas.

create or replace view unidade_agricola.vw_unidades_agricolas_resumo as
select
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.tipo_unidade,
  u.status_cadastro,
  u.situacao_operacional,
  u.uf,
  u.municipio,
  u.latitude_sede,
  u.longitude_sede,
  u.area_total_ha,
  u.sync_status,
  u.created_at,
  u.updated_at,
  count(distinct e.id_evento) as total_eventos,
  count(distinct e.id_evento) filter (where e.status = 'validado') as eventos_validados,
  count(distinct e.id_evento) filter (where e.status = 'erro') as eventos_com_erro,
  max(e.published_at) as ultimo_evento_em
from unidade_agricola.unidades_agricolas u
left join unidade_agricola.fractal_eventos_log e
  on e.id_unidade_agricola = u.id_unidade_agricola
group by
  u.id_unidade_agricola,
  u.codigo_unidade,
  u.nome_unidade,
  u.tipo_unidade,
  u.status_cadastro,
  u.situacao_operacional,
  u.uf,
  u.municipio,
  u.latitude_sede,
  u.longitude_sede,
  u.area_total_ha,
  u.sync_status,
  u.created_at,
  u.updated_at;

comment on view unidade_agricola.vw_unidades_agricolas_resumo is
'Resumo operacional por unidade agrícola, com status, localização, área e eventos vinculados.';

create or replace view unidade_agricola.vw_eventos_fractais_resumo as
select
  c.nome_evento,
  c.modulo_origem,
  c.submodulo_origem,
  c.fractal_origem,
  c.tabela_origem,
  c.acao,
  c.ativo,
  count(l.id_evento) as total_publicado,
  count(l.id_evento) filter (where l.status = 'pendente') as pendentes,
  count(l.id_evento) filter (where l.status = 'validado') as validados,
  count(l.id_evento) filter (where l.status = 'erro') as com_erro,
  max(l.published_at) as ultimo_publicado_em
from unidade_agricola.fractal_eventos_catalogo c
left join unidade_agricola.fractal_eventos_log l
  on l.nome_evento = c.nome_evento
group by
  c.nome_evento,
  c.modulo_origem,
  c.submodulo_origem,
  c.fractal_origem,
  c.tabela_origem,
  c.acao,
  c.ativo;

comment on view unidade_agricola.vw_eventos_fractais_resumo is
'Resumo do catálogo de eventos dos fractais com totais publicados e status de processamento.';

create or replace view unidade_agricola.vw_status_modulo_unidade_agricola as
select
  (select count(*) from unidade_agricola.unidades_agricolas) as total_unidades,
  (select count(*) from unidade_agricola.unidades_agricolas where status_cadastro = 'Ativo') as unidades_ativas,
  (select count(*) from unidade_agricola.unidades_agricolas where status_cadastro in ('Pendente', 'Em validacao', 'pendente')) as unidades_pendentes,
  (select coalesce(sum(area_total_ha), 0) from unidade_agricola.unidades_agricolas) as area_total_ha,
  (select count(*) from unidade_agricola.fractal_eventos_catalogo) as eventos_catalogados,
  (select count(*) from unidade_agricola.fractal_eventos_log) as eventos_publicados,
  (select count(*) from unidade_agricola.fractal_eventos_log where status = 'validado') as eventos_validados,
  (select count(*) from unidade_agricola.fractal_eventos_log where status = 'erro') as eventos_com_erro,
  (select count(*) from unidade_agricola.unidades_agricolas where sync_status in ('pendente', 'erro')) as unidades_sync_pendente_erro,
  now() as atualizado_em;

comment on view unidade_agricola.vw_status_modulo_unidade_agricola is
'Visão executiva de status do módulo Gestão da Unidade Agrícola.';

create or replace view unidade_agricola.vw_fractais_catalogo_operacional as
select
  fractal_origem,
  submodulo_origem,
  tabela_origem,
  count(*) as eventos_previstos,
  bool_or(acao = 'criado') as possui_evento_criado,
  bool_or(acao = 'atualizado') as possui_evento_atualizado,
  bool_or(acao = 'validado') as possui_evento_validado,
  bool_or(acao = 'sincronizado') as possui_evento_sincronizado
from unidade_agricola.fractal_eventos_catalogo
group by
  fractal_origem,
  submodulo_origem,
  tabela_origem;

comment on view unidade_agricola.vw_fractais_catalogo_operacional is
'Catálogo operacional dos fractais com conferência dos quatro eventos padrão.';
