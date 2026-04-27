-- 202604260026_view_liberacao_plug_play_ecossistema.sql
-- View de liberacao plug and play do Mod_Gestao_Unidade_Agricola para consumidores do Ecossistema Genius.

create or replace view unidade_agricola.vw_modulo_unidade_agricola_liberacao_ecossistema as
select
  c.id_unidade_agricola,
  c.codigo_unidade,
  c.nome_unidade,
  m.ordem_consumo,
  m.modulo_consumidor,
  m.categoria_consumo,
  m.submodulos_chave,
  m.liberado,
  case
    when m.liberado then m.motivo_liberacao
    else m.motivo_bloqueio
  end as motivo,
  c.status_modulo as status_origem,
  c.pronto_para_ecossistema_genius,
  c.total_submodulos_prontos,
  c.total_submodulos_pendentes,
  c.percentual_submodulos_prontos,
  c.total_fractais_validados,
  c.total_fractais_registrados,
  c.percentual_fractais_validados,
  c.atualizado_em
from unidade_agricola.vw_modulo_unidade_agricola_consolidado c
cross join lateral (
  values
    (
      1,
      'Mod_Gestao_Dados_DataLake',
      'dados_base',
      jsonb_build_array('01_sub_cadastro_unidades_agricolas', '09_sub_status_operacional_unidade', '10_sub_prestacao_contas_unidade'),
      c.pronto_para_ecossistema_genius,
      'Unidade completa e auditada, pronta para ingestao no DataLake.',
      'Unidade ainda nao completou os 10 submodulos executaveis.'
    ),
    (
      2,
      'Mod_Gestao_Dashboards_BI',
      'visualizacao_analitica',
      jsonb_build_array('09_sub_status_operacional_unidade', '10_sub_prestacao_contas_unidade'),
      c.pronto_para_ecossistema_genius and c.sub09_status_operacional_pronto and c.sub10_prestacao_contas_pronto,
      'Status operacional e prestacao de contas validados para consumo por dashboards e BI.',
      'Dashboards dependem do status operacional e do fechamento de prestacao de contas.'
    ),
    (
      3,
      'Mod_Gestao_Genius_Hub',
      'orquestracao_ecossistema',
      jsonb_build_array('01_sub_cadastro_unidades_agricolas', '09_sub_status_operacional_unidade'),
      c.pronto_para_ecossistema_genius,
      'Unidade completa e auditada, pronta para orquestracao pelo Genius Hub.',
      'Genius Hub consome somente unidades completas e auditadas.'
    ),
    (
      4,
      'Mod_Gestao_Georreferenciamento',
      'territorio_mapas',
      jsonb_build_array('01_sub_cadastro_unidades_agricolas', '04_sub_territorios_areas_producao', '05_sub_limites_acessos', '07_sub_base_ativos_estruturais_unidade'),
      c.sub01_cadastro_unidade_pronto and c.sub04_territorios_areas_pronto and c.sub05_limites_acessos_pronto and c.sub07_ativos_estruturais_pronto,
      'Cadastro, areas, limites e ativos estruturais validados para georreferenciamento.',
      'Georreferenciamento exige unidade, areas, limites/acessos e ativos estruturais validados.'
    ),
    (
      5,
      'Mod_Gestao_Financeira',
      'financeiro',
      jsonb_build_array('10_sub_prestacao_contas_unidade'),
      c.pronto_para_ecossistema_genius and c.sub10_prestacao_contas_pronto,
      'Prestacao de contas validada para consumo financeiro.',
      'Financeiro depende do fechamento da prestacao de contas da unidade.'
    ),
    (
      6,
      'Mod_Gestao_Administrativa',
      'administrativo',
      jsonb_build_array('01_sub_cadastro_unidades_agricolas', '03_sub_responsaveis_gestores', '10_sub_prestacao_contas_unidade'),
      c.sub01_cadastro_unidade_pronto and c.sub03_responsaveis_gestores_pronto and c.sub10_prestacao_contas_pronto,
      'Cadastro, responsaveis e prestacao de contas prontos para gestao administrativa.',
      'Administrativo exige cadastro, responsaveis e fechamento operacional.'
    ),
    (
      7,
      'Mod_Gestao_Auditoria_Conformidade',
      'auditoria_conformidade',
      jsonb_build_array('06_sub_documentacao_unidade', '09_sub_status_operacional_unidade', '10_sub_prestacao_contas_unidade'),
      c.sub06_documentacao_pronto and c.sub09_status_operacional_pronto and c.sub10_prestacao_contas_pronto,
      'Documentacao, status operacional e prestacao de contas prontos para auditoria.',
      'Auditoria exige documentacao, status operacional e fechamento auditavel.'
    ),
    (
      8,
      'Mod_Gestao_Producao_Vegetal',
      'producao',
      jsonb_build_array('01_sub_cadastro_unidades_agricolas', '04_sub_territorios_areas_producao', '09_sub_status_operacional_unidade'),
      c.sub01_cadastro_unidade_pronto and c.sub04_territorios_areas_pronto and c.sub09_status_operacional_pronto,
      'Unidade, areas produtivas e status operacional liberados para producao vegetal.',
      'Producao vegetal exige unidade, areas produtivas e status operacional.'
    ),
    (
      9,
      'Mod_Gestao_Producao_Animal_Pecuaria',
      'producao',
      jsonb_build_array('01_sub_cadastro_unidades_agricolas', '04_sub_territorios_areas_producao', '09_sub_status_operacional_unidade'),
      c.sub01_cadastro_unidade_pronto and c.sub04_territorios_areas_pronto and c.sub09_status_operacional_pronto,
      'Unidade, areas e status operacional liberados para producao animal/pecuaria.',
      'Producao animal exige unidade, areas e status operacional.'
    ),
    (
      10,
      'Mod_Construcoes_Rurais',
      'construcoes_ativos',
      jsonb_build_array('07_sub_base_ativos_estruturais_unidade', '05_sub_limites_acessos', '04_sub_territorios_areas_producao'),
      c.sub07_ativos_estruturais_pronto and c.sub05_limites_acessos_pronto and c.sub04_territorios_areas_pronto,
      'Ativos estruturais, limites/acessos e areas validados como base para Construcoes Rurais.',
      'Construcoes Rurais exige base de ativos estruturais, limites/acessos e areas.'
    ),
    (
      11,
      'Mod_Gestao_Manutencao',
      'manutencao',
      jsonb_build_array('05_sub_limites_acessos', '07_sub_base_ativos_estruturais_unidade', '08_sub_chaves_permissoes_operacionais'),
      c.sub05_limites_acessos_pronto and c.sub07_ativos_estruturais_pronto and c.sub08_chaves_permissoes_pronto,
      'Limites/acessos, ativos estruturais e permissoes prontos para manutencao.',
      'Manutencao exige acessos, ativos estruturais e permissoes operacionais.'
    ),
    (
      12,
      'Mod_Gestao_Cowork_Workspace',
      'workspace_permissoes',
      jsonb_build_array('03_sub_responsaveis_gestores', '08_sub_chaves_permissoes_operacionais'),
      c.sub03_responsaveis_gestores_pronto and c.sub08_chaves_permissoes_pronto,
      'Responsaveis e permissoes operacionais liberados para Cowork/Workspace.',
      'Cowork/Workspace exige responsaveis e permissoes operacionais.'
    ),
    (
      13,
      'Mod_Gestao_Seguranca_Patrimonial',
      'seguranca',
      jsonb_build_array('05_sub_limites_acessos', '08_sub_chaves_permissoes_operacionais'),
      c.sub05_limites_acessos_pronto and c.sub08_chaves_permissoes_pronto,
      'Limites, acessos, chaves e permissoes prontos para seguranca patrimonial.',
      'Seguranca patrimonial exige limites/acessos e chaves/permissoes.'
    ),
    (
      14,
      'Mod_Gestao_Projetos',
      'projetos_planejamento',
      jsonb_build_array('03_sub_responsaveis_gestores', '09_sub_status_operacional_unidade'),
      c.sub03_responsaveis_gestores_pronto and c.sub09_status_operacional_pronto,
      'Responsaveis e status operacional liberados para projetos.',
      'Projetos exigem responsaveis/gestores e status operacional.'
    ),
    (
      15,
      'Mod_Gestao_Tarefas_Processos',
      'tarefas_processos',
      jsonb_build_array('03_sub_responsaveis_gestores', '08_sub_chaves_permissoes_operacionais', '09_sub_status_operacional_unidade'),
      c.sub03_responsaveis_gestores_pronto and c.sub08_chaves_permissoes_pronto and c.sub09_status_operacional_pronto,
      'Responsaveis, permissoes e status operacional liberados para tarefas/processos.',
      'Tarefas/processos exigem responsaveis, permissoes e status operacional.'
    ),
    (
      16,
      'Mod_Gestao_Agentes_IA',
      'agentes_ia',
      jsonb_build_array('09_sub_status_operacional_unidade', '10_sub_prestacao_contas_unidade'),
      c.pronto_para_ecossistema_genius and c.sub09_status_operacional_pronto and c.sub10_prestacao_contas_pronto,
      'Modulo completo com status e fechamento auditavel para agentes de IA.',
      'Agentes de IA exigem modulo completo, status operacional e fechamento auditavel.'
    )
) as m(
  ordem_consumo,
  modulo_consumidor,
  categoria_consumo,
  submodulos_chave,
  liberado,
  motivo_liberacao,
  motivo_bloqueio
);

comment on view unidade_agricola.vw_modulo_unidade_agricola_liberacao_ecossistema is
'Matriz plug and play do Mod_Gestao_Unidade_Agricola. Informa, por unidade e modulo consumidor, se os dados estao liberados para consumo no Ecossistema Genius.';

grant select on unidade_agricola.vw_modulo_unidade_agricola_liberacao_ecossistema to anon, authenticated;
