-- 202604260024_view_consolidada_modulo_completo.sql
-- View consolidada do modulo completo de Gestao da Unidade Agricola.
-- Uma linha por unidade, consolidando prontidao dos 10 submodulos executaveis.

create or replace view unidade_agricola.vw_modulo_unidade_agricola_consolidado as
with
sub01 as (
  select
    id_unidade_agricola,
    codigo_unidade,
    nome_unidade,
    tipo_unidade,
    status_cadastro,
    situacao_operacional,
    uf,
    municipio,
    area_total_ha,
    1 as registros,
    coalesce(fractais_validados, 0)::integer as fractais_validados,
    coalesce(total_fractais_sub01, 0)::integer as total_fractais,
    coalesce(pronto_para_submodulos_dependentes, false) as pronto,
    status_validacao,
    updated_at
  from unidade_agricola.vw_sub01_cadastro_unidades_agricolas_operacional
),
sub02 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub02), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub02_proprietarios_possuidores_operacional
  group by id_unidade_agricola
),
sub03 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub03), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub03_responsaveis_gestores_operacional
  group by id_unidade_agricola
),
sub04 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub04), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub04_territorios_areas_operacional
  group by id_unidade_agricola
),
sub05 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub05), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub05_limites_acessos_operacional
  group by id_unidade_agricola
),
sub06 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub06), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub06_documentacao_operacional
  group by id_unidade_agricola
),
sub07 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub07), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub07_ativos_estruturais_operacional
  group by id_unidade_agricola
),
sub08 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub08), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub08_chaves_permissoes_operacional
  group by id_unidade_agricola
),
sub09 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub09), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub09_status_operacional_unidade
  group by id_unidade_agricola
),
sub10 as (
  select
    id_unidade_agricola,
    count(*)::integer as registros,
    coalesce(sum(fractais_validados), 0)::integer as fractais_validados,
    coalesce(sum(total_fractais_sub10), 0)::integer as total_fractais,
    bool_and(coalesce(pronto_para_modulos_dependentes, false)) as pronto,
    string_agg(distinct status_validacao, ', ' order by status_validacao) as status_validacao
  from unidade_agricola.vw_sub10_prestacao_contas_operacional
  group by id_unidade_agricola
),
base as (
  select
    s1.*,
    coalesce(s2.registros, 0) as sub02_registros,
    coalesce(s2.fractais_validados, 0) as sub02_fractais_validados,
    coalesce(s2.total_fractais, 0) as sub02_total_fractais,
    coalesce(s2.pronto, false) as sub02_pronto,
    coalesce(s2.status_validacao, 'sem_registro') as sub02_status_validacao,

    coalesce(s3.registros, 0) as sub03_registros,
    coalesce(s3.fractais_validados, 0) as sub03_fractais_validados,
    coalesce(s3.total_fractais, 0) as sub03_total_fractais,
    coalesce(s3.pronto, false) as sub03_pronto,
    coalesce(s3.status_validacao, 'sem_registro') as sub03_status_validacao,

    coalesce(s4.registros, 0) as sub04_registros,
    coalesce(s4.fractais_validados, 0) as sub04_fractais_validados,
    coalesce(s4.total_fractais, 0) as sub04_total_fractais,
    coalesce(s4.pronto, false) as sub04_pronto,
    coalesce(s4.status_validacao, 'sem_registro') as sub04_status_validacao,

    coalesce(s5.registros, 0) as sub05_registros,
    coalesce(s5.fractais_validados, 0) as sub05_fractais_validados,
    coalesce(s5.total_fractais, 0) as sub05_total_fractais,
    coalesce(s5.pronto, false) as sub05_pronto,
    coalesce(s5.status_validacao, 'sem_registro') as sub05_status_validacao,

    coalesce(s6.registros, 0) as sub06_registros,
    coalesce(s6.fractais_validados, 0) as sub06_fractais_validados,
    coalesce(s6.total_fractais, 0) as sub06_total_fractais,
    coalesce(s6.pronto, false) as sub06_pronto,
    coalesce(s6.status_validacao, 'sem_registro') as sub06_status_validacao,

    coalesce(s7.registros, 0) as sub07_registros,
    coalesce(s7.fractais_validados, 0) as sub07_fractais_validados,
    coalesce(s7.total_fractais, 0) as sub07_total_fractais,
    coalesce(s7.pronto, false) as sub07_pronto,
    coalesce(s7.status_validacao, 'sem_registro') as sub07_status_validacao,

    coalesce(s8.registros, 0) as sub08_registros,
    coalesce(s8.fractais_validados, 0) as sub08_fractais_validados,
    coalesce(s8.total_fractais, 0) as sub08_total_fractais,
    coalesce(s8.pronto, false) as sub08_pronto,
    coalesce(s8.status_validacao, 'sem_registro') as sub08_status_validacao,

    coalesce(s9.registros, 0) as sub09_registros,
    coalesce(s9.fractais_validados, 0) as sub09_fractais_validados,
    coalesce(s9.total_fractais, 0) as sub09_total_fractais,
    coalesce(s9.pronto, false) as sub09_pronto,
    coalesce(s9.status_validacao, 'sem_registro') as sub09_status_validacao,

    coalesce(s10.registros, 0) as sub10_registros,
    coalesce(s10.fractais_validados, 0) as sub10_fractais_validados,
    coalesce(s10.total_fractais, 0) as sub10_total_fractais,
    coalesce(s10.pronto, false) as sub10_pronto,
    coalesce(s10.status_validacao, 'sem_registro') as sub10_status_validacao
  from sub01 s1
  left join sub02 s2 on s2.id_unidade_agricola = s1.id_unidade_agricola
  left join sub03 s3 on s3.id_unidade_agricola = s1.id_unidade_agricola
  left join sub04 s4 on s4.id_unidade_agricola = s1.id_unidade_agricola
  left join sub05 s5 on s5.id_unidade_agricola = s1.id_unidade_agricola
  left join sub06 s6 on s6.id_unidade_agricola = s1.id_unidade_agricola
  left join sub07 s7 on s7.id_unidade_agricola = s1.id_unidade_agricola
  left join sub08 s8 on s8.id_unidade_agricola = s1.id_unidade_agricola
  left join sub09 s9 on s9.id_unidade_agricola = s1.id_unidade_agricola
  left join sub10 s10 on s10.id_unidade_agricola = s1.id_unidade_agricola
),
pontuado as (
  select
    b.*,
    (
      case when b.pronto then 1 else 0 end +
      case when b.sub02_pronto then 1 else 0 end +
      case when b.sub03_pronto then 1 else 0 end +
      case when b.sub04_pronto then 1 else 0 end +
      case when b.sub05_pronto then 1 else 0 end +
      case when b.sub06_pronto then 1 else 0 end +
      case when b.sub07_pronto then 1 else 0 end +
      case when b.sub08_pronto then 1 else 0 end +
      case when b.sub09_pronto then 1 else 0 end +
      case when b.sub10_pronto then 1 else 0 end
    ) as total_submodulos_prontos,
    (
      b.fractais_validados +
      b.sub02_fractais_validados +
      b.sub03_fractais_validados +
      b.sub04_fractais_validados +
      b.sub05_fractais_validados +
      b.sub06_fractais_validados +
      b.sub07_fractais_validados +
      b.sub08_fractais_validados +
      b.sub09_fractais_validados +
      b.sub10_fractais_validados
    ) as total_fractais_validados,
    (
      b.total_fractais +
      b.sub02_total_fractais +
      b.sub03_total_fractais +
      b.sub04_total_fractais +
      b.sub05_total_fractais +
      b.sub06_total_fractais +
      b.sub07_total_fractais +
      b.sub08_total_fractais +
      b.sub09_total_fractais +
      b.sub10_total_fractais
    ) as total_fractais_registrados
  from base b
)
select
  id_unidade_agricola,
  codigo_unidade,
  nome_unidade,
  tipo_unidade,
  status_cadastro,
  situacao_operacional,
  uf,
  municipio,
  area_total_ha,
  10 as total_submodulos_previstos,
  total_submodulos_prontos,
  (10 - total_submodulos_prontos) as total_submodulos_pendentes,
  round((total_submodulos_prontos::numeric / 10) * 100, 2) as percentual_submodulos_prontos,
  total_fractais_validados,
  total_fractais_registrados,
  case
    when total_fractais_registrados > 0 then round((total_fractais_validados::numeric / total_fractais_registrados) * 100, 2)
    else 0::numeric
  end as percentual_fractais_validados,
  (total_submodulos_prontos = 10) as pronto_para_ecossistema_genius,
  case
    when total_submodulos_prontos = 10 then 'saudavel'
    when total_submodulos_prontos >= 7 then 'atencao'
    when total_submodulos_prontos >= 1 then 'em_implantacao'
    else 'incompleto'
  end as status_modulo,
  pronto as sub01_cadastro_unidade_pronto,
  sub02_pronto as sub02_proprietarios_possuidores_pronto,
  sub03_pronto as sub03_responsaveis_gestores_pronto,
  sub04_pronto as sub04_territorios_areas_pronto,
  sub05_pronto as sub05_limites_acessos_pronto,
  sub06_pronto as sub06_documentacao_pronto,
  sub07_pronto as sub07_ativos_estruturais_pronto,
  sub08_pronto as sub08_chaves_permissoes_pronto,
  sub09_pronto as sub09_status_operacional_pronto,
  sub10_pronto as sub10_prestacao_contas_pronto,
  jsonb_build_object(
    '01_sub_cadastro_unidades_agricolas', jsonb_build_object('pronto', pronto, 'registros', registros, 'status', status_validacao, 'fractais_validados', fractais_validados, 'total_fractais', total_fractais),
    '02_sub_proprietarios_possuidores', jsonb_build_object('pronto', sub02_pronto, 'registros', sub02_registros, 'status', sub02_status_validacao, 'fractais_validados', sub02_fractais_validados, 'total_fractais', sub02_total_fractais),
    '03_sub_responsaveis_gestores', jsonb_build_object('pronto', sub03_pronto, 'registros', sub03_registros, 'status', sub03_status_validacao, 'fractais_validados', sub03_fractais_validados, 'total_fractais', sub03_total_fractais),
    '04_sub_territorios_areas_producao', jsonb_build_object('pronto', sub04_pronto, 'registros', sub04_registros, 'status', sub04_status_validacao, 'fractais_validados', sub04_fractais_validados, 'total_fractais', sub04_total_fractais),
    '05_sub_limites_acessos', jsonb_build_object('pronto', sub05_pronto, 'registros', sub05_registros, 'status', sub05_status_validacao, 'fractais_validados', sub05_fractais_validados, 'total_fractais', sub05_total_fractais),
    '06_sub_documentacao_unidade', jsonb_build_object('pronto', sub06_pronto, 'registros', sub06_registros, 'status', sub06_status_validacao, 'fractais_validados', sub06_fractais_validados, 'total_fractais', sub06_total_fractais),
    '07_sub_base_ativos_estruturais_unidade', jsonb_build_object('pronto', sub07_pronto, 'registros', sub07_registros, 'status', sub07_status_validacao, 'fractais_validados', sub07_fractais_validados, 'total_fractais', sub07_total_fractais),
    '08_sub_chaves_permissoes_operacionais', jsonb_build_object('pronto', sub08_pronto, 'registros', sub08_registros, 'status', sub08_status_validacao, 'fractais_validados', sub08_fractais_validados, 'total_fractais', sub08_total_fractais),
    '09_sub_status_operacional_unidade', jsonb_build_object('pronto', sub09_pronto, 'registros', sub09_registros, 'status', sub09_status_validacao, 'fractais_validados', sub09_fractais_validados, 'total_fractais', sub09_total_fractais),
    '10_sub_prestacao_contas_unidade', jsonb_build_object('pronto', sub10_pronto, 'registros', sub10_registros, 'status', sub10_status_validacao, 'fractais_validados', sub10_fractais_validados, 'total_fractais', sub10_total_fractais)
  ) as resumo_submodulos,
  now() as atualizado_em
from pontuado;

comment on view unidade_agricola.vw_modulo_unidade_agricola_consolidado is
'View consolidada do Mod_Gestao_Unidade_Agricola. Mostra uma linha por unidade com prontidao dos 10 submodulos, fractais validados, status geral e encaixe com o Ecossistema Genius.';

grant select on unidade_agricola.vw_modulo_unidade_agricola_consolidado to anon, authenticated;
