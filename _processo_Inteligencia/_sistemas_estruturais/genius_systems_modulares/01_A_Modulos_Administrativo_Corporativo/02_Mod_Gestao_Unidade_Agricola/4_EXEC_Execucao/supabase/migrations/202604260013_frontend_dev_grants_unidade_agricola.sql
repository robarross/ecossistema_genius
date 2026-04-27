-- 202604260013_frontend_dev_grants_unidade_agricola.sql
-- Permissões temporárias para teste do frontend em desenvolvimento/homologação.
-- Não usar em produção sem revisar RLS e políticas por usuário/unidade.

grant usage on schema unidade_agricola to anon, authenticated;
grant select on all tables in schema unidade_agricola to anon, authenticated;
grant execute on all functions in schema unidade_agricola to authenticated;

alter default privileges in schema unidade_agricola
grant select on tables to anon, authenticated;
