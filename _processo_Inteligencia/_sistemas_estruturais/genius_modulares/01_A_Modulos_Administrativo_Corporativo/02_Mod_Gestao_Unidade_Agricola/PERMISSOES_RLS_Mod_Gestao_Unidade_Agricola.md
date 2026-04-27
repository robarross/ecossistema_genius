# PERMISSOES_RLS_Mod_Gestao_Unidade_Agricola

Este documento define a diretriz de permissao e Row Level Security para o modulo Gestão da Unidade Agrícola.

## Perfis sugeridos

- `admin_ecossistema`: administra todas as unidades e fractais.
- `gestor_unidade_agricola`: administra unidades sob sua responsabilidade.
- `responsavel_tecnico`: acessa fractais tecnicos, documentais, produtivos e territoriais.
- `operador_campo`: cria e atualiza registros operacionais autorizados.
- `auditor_consulta`: consulta dados, historicos, evidencias e eventos.
- `integracao_api`: usuario tecnico para APIs, Hub, DataLake e automacoes.

## Regra RLS base

Toda tabela deve filtrar por:

- organizacao/tenant, quando este campo for introduzido;
- `id_unidade_agricola`;
- papel/perfil do usuario;
- vinculo do usuario com a unidade;
- status do registro quando houver restricao operacional.

## Tabelas/fractais cobertos

- `fractal_identidade_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_relacionamentos_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_governanca_permissoes`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_documental_juridico`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_operacional_status`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_ecossistema`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_indicadores_dashboards`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_inteligencia_automacoes`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_dados_basicos_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_localizacao_referencia_territorial`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_classificacao_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_situacao_cadastral`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_validacao_campos_obrigatorios`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_datalake_mapas_modulos`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_cadastro_proprietarios`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_cadastro_possuidores`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_documentos_titulares`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_vinculos_unidade_agricola`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_historico_titularidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_contratos_juridico_permissoes`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_cadastro_responsaveis`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_funcoes_papeis_operacionais`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_responsabilidade_tecnica`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_responsabilidade_administrativa`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_niveis_autorizacao`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_tarefas_projetos_cowork`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_areas_produtivas`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_glebas_talhoes`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_uso_atual_area`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_potencial_produtivo`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_historico_ocupacao_uso`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_producao_geo_precisao`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_limites_fisicos_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_acessos_internos_externos`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_estradas_ramais_porteiras`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_pontos_criticos_acesso`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_controle_circulacao`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_seguranca_logistica_manutencao`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_documentos_fundiarios`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_documentos_ambientais`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_documentos_fiscais_cadastrais`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_validades_vencimentos`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_uploads_evidencias`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_regularizacao_fiscal_storage`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_estruturas_existentes`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_benfeitorias_instalacoes_fixas`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_equipamentos_fixos_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_estado_conservacao`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_relacao_areas_uso_operacional`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_construcoes_manutencao`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_chaves_fisicas`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_acessos_digitais`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_perfis_operacionais`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_autorizacoes_area_funcao`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_historico_acesso`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_seguranca_cowork_workspace`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_status_geral_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_status_produtivo`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_status_documental`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_status_estrutural`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_status_risco_pendencia`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_dashboards_alertas_planejamento`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_resumo_operacional_unidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_evidencias_suporte`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_indicadores_conformidade`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_pendencias_abertas`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_historico_atualizacoes`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.
- `fractal_integracao_financeiro_admin_auditoria`: acesso por `id_unidade_agricola`, perfil do usuario e vinculo com unidade.

## Politicas sugeridas

```sql
alter table unidade_agricola.unidades_agricolas enable row level security;

create policy unidades_select_vinculados
on unidade_agricola.unidades_agricolas
for select
using (
  auth.uid() = created_by
  or exists (
    select 1
    from unidade_agricola.usuario_unidade_vinculos v
    where v.id_unidade_agricola = unidades_agricolas.id_unidade_agricola
      and v.id_usuario = auth.uid()
      and v.ativo = true
  )
);
```

## Observacao

Antes de ativar RLS em producao, criar a tabela de vinculos `usuario_unidade_vinculos` e integrar com Genius Hub, Workspace, Cowork e Segurança da Informação.
