-- 202604260025_funcao_auditoria_geral_modulo.sql
-- Funcao de auditoria geral do Mod_Gestao_Unidade_Agricola.
-- Le a view consolidada e retorna diagnostico automatico da unidade.

create or replace function unidade_agricola.auditar_modulo_unidade_agricola(
  p_codigo_unidade text
)
returns table (
  codigo_unidade text,
  nome_unidade text,
  status_modulo text,
  pronto_para_ecossistema_genius boolean,
  total_submodulos_previstos integer,
  total_submodulos_prontos integer,
  total_submodulos_pendentes integer,
  percentual_submodulos_prontos numeric,
  total_fractais_validados integer,
  total_fractais_registrados integer,
  percentual_fractais_validados numeric,
  diagnostico text,
  pendencias jsonb,
  proximas_acoes jsonb,
  resumo_submodulos jsonb,
  auditado_em timestamptz
)
language sql
security definer
set search_path = unidade_agricola, public
as $$
  with consolidado as (
    select *
    from unidade_agricola.vw_modulo_unidade_agricola_consolidado
    where codigo_unidade = upper(trim(p_codigo_unidade))
    limit 1
  ),
  pendencias_submodulos as (
    select
      c.codigo_unidade,
      coalesce(
        jsonb_agg(
          jsonb_build_object(
            'submodulo', item.key,
            'pronto', coalesce((item.value ->> 'pronto')::boolean, false),
            'status', coalesce(item.value ->> 'status', 'sem_status'),
            'registros', coalesce((item.value ->> 'registros')::integer, 0),
            'fractais_validados', coalesce((item.value ->> 'fractais_validados')::integer, 0),
            'total_fractais', coalesce((item.value ->> 'total_fractais')::integer, 0)
          )
          order by item.key
        ) filter (
          where coalesce((item.value ->> 'pronto')::boolean, false) is not true
        ),
        '[]'::jsonb
      ) as pendencias
    from consolidado c
    cross join lateral jsonb_each(c.resumo_submodulos) as item(key, value)
    group by c.codigo_unidade
  )
  select
    c.codigo_unidade,
    c.nome_unidade,
    c.status_modulo,
    c.pronto_para_ecossistema_genius,
    c.total_submodulos_previstos,
    c.total_submodulos_prontos,
    c.total_submodulos_pendentes,
    c.percentual_submodulos_prontos,
    c.total_fractais_validados,
    c.total_fractais_registrados,
    c.percentual_fractais_validados,
    case
      when c.pronto_para_ecossistema_genius then
        'Modulo completo, saudavel e pronto para o Ecossistema Genius.'
      when c.total_submodulos_prontos >= 7 then
        'Modulo em atencao: maioria dos submodulos pronta, mas ainda existem pendencias de fechamento.'
      when c.total_submodulos_prontos >= 1 then
        'Modulo em implantacao: existem submodulos iniciados, mas a unidade ainda nao esta pronta para o ecossistema.'
      else
        'Modulo incompleto: nenhum submodulo foi validado para esta unidade.'
    end as diagnostico,
    p.pendencias,
    case
      when c.pronto_para_ecossistema_genius then
        jsonb_build_array(
          'Liberar unidade para consumidores do Ecossistema Genius',
          'Conectar dashboards, DataLake, Genius Hub e modulos dependentes',
          'Manter rotina periodica de auditoria'
        )
      else
        (
          select coalesce(
            jsonb_agg(
              'Completar ' || item.key || ' - status atual: ' || coalesce(item.value ->> 'status', 'sem_status')
              order by item.key
            ) filter (
              where coalesce((item.value ->> 'pronto')::boolean, false) is not true
            ),
            jsonb_build_array('Revisar submodulos pendentes')
          )
          from jsonb_each(c.resumo_submodulos) as item(key, value)
        )
    end as proximas_acoes,
    c.resumo_submodulos,
    now() as auditado_em
  from consolidado c
  left join pendencias_submodulos p
    on p.codigo_unidade = c.codigo_unidade;
$$;

comment on function unidade_agricola.auditar_modulo_unidade_agricola(text) is
'Audita o Mod_Gestao_Unidade_Agricola para uma unidade. Retorna diagnostico automatico, prontidao geral, pendencias por submodulo e proximas acoes.';

grant execute on function unidade_agricola.auditar_modulo_unidade_agricola(text) to anon, authenticated;
