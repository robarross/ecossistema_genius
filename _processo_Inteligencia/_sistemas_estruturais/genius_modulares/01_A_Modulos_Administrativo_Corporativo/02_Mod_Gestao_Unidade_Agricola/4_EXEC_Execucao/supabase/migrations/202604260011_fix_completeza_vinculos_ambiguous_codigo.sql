-- 202604260011_fix_completeza_vinculos_ambiguous_codigo.sql
-- Corrige ambiguidade de codigo_unidade na rotina em lote de completeza.

create or replace function unidade_agricola.completar_vinculos_basicos_unidades_pendentes()
returns table (
  codigo_unidade text,
  proprietario_criado boolean,
  responsavel_criado boolean,
  area_criada boolean,
  eventos_criados integer
)
language plpgsql
as $$
declare
  r record;
begin
  for r in
    select v.codigo_unidade
    from unidade_agricola.vw_auditoria_unidades_sem_vinculos v
    order by v.codigo_unidade
  loop
    return query
    select *
    from unidade_agricola.completar_vinculos_basicos_unidade(r.codigo_unidade);
  end loop;
end;
$$;
