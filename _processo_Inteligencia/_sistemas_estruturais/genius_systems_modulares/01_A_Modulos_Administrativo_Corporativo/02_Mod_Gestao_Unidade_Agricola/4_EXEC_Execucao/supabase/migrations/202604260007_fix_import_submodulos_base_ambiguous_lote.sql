-- 202604260007_fix_import_submodulos_base_ambiguous_lote.sql
-- Corrige ambiguidade de lote_importacao nas funções de importação dos submódulos base.

create or replace function unidade_agricola.processar_importacao_proprietarios_possuidores(p_lote_importacao text default null)
returns table (lote_importacao text, total_processado integer, total_importado integer, total_erro integer)
language plpgsql
as $$
declare
  r record;
  v_id_unidade uuid;
  v_id_fractal uuid;
  v_total_processado integer := 0;
  v_total_importado integer := 0;
  v_total_erro integer := 0;
begin
  for r in
    select imp.* from unidade_agricola.import_planilha_proprietarios_possuidores imp
    where imp.status_importacao in ('pendente', 'erro')
      and (p_lote_importacao is null or imp.lote_importacao = p_lote_importacao)
    order by imp.created_at, imp.linha_origem nulls last
  loop
    v_total_processado := v_total_processado + 1;
    begin
      select u.id_unidade_agricola into v_id_unidade
      from unidade_agricola.unidades_agricolas u
      where u.codigo_unidade = r.codigo_unidade;

      if v_id_unidade is null then
        raise exception 'codigo_unidade não encontrado: %', r.codigo_unidade;
      end if;

      if coalesce(trim(r.nome_titular), '') = '' then
        raise exception 'nome_titular obrigatório';
      end if;

      insert into unidade_agricola.fractal_cadastro_proprietarios (
        id_unidade_agricola, id_origem, status, payload, sync_status
      ) values (
        v_id_unidade,
        'planilha_proprietarios:' || r.id_importacao::text,
        'validado',
        jsonb_build_object(
          'nome_titular', r.nome_titular,
          'documento_titular', r.documento_titular,
          'tipo_titular', r.tipo_titular,
          'tipo_vinculo', r.tipo_vinculo,
          'percentual_participacao', r.percentual_participacao,
          'telefone', r.telefone,
          'email', r.email,
          'observacoes', r.observacoes,
          'origem', 'planilha',
          'lote_importacao', r.lote_importacao
        ),
        'validado'
      )
      returning id_fractal_registro into v_id_fractal;

      insert into unidade_agricola.fractal_eventos_log (
        nome_evento, id_unidade_agricola, id_fractal_registro, modulo_origem,
        submodulo_origem, fractal_origem, status, payload
      ) values (
        'unidade_agricola.fractal_cadastro_proprietarios.validado',
        v_id_unidade,
        v_id_fractal,
        'Mod_Gestao_Unidade_Agricola',
        '02_sub_proprietarios_possuidores',
        '01_fractal_cadastro_proprietarios',
        'validado',
        jsonb_build_object('origem','planilha','lote_importacao',r.lote_importacao,'id_importacao',r.id_importacao)
      );

      update unidade_agricola.import_planilha_proprietarios_possuidores imp
      set status_importacao = 'importado',
          mensagem_importacao = 'Importado com sucesso',
          id_unidade_agricola = v_id_unidade,
          id_fractal_registro = v_id_fractal,
          processed_at = now()
      where imp.id_importacao = r.id_importacao;

      v_total_importado := v_total_importado + 1;
    exception when others then
      update unidade_agricola.import_planilha_proprietarios_possuidores imp
      set status_importacao = 'erro',
          mensagem_importacao = sqlerrm,
          processed_at = now()
      where imp.id_importacao = r.id_importacao;
      v_total_erro := v_total_erro + 1;
    end;
  end loop;

  return query select coalesce(p_lote_importacao, 'todos')::text, v_total_processado, v_total_importado, v_total_erro;
end;
$$;

create or replace function unidade_agricola.processar_importacao_responsaveis_gestores(p_lote_importacao text default null)
returns table (lote_importacao text, total_processado integer, total_importado integer, total_erro integer)
language plpgsql
as $$
declare
  r record;
  v_id_unidade uuid;
  v_id_fractal uuid;
  v_total_processado integer := 0;
  v_total_importado integer := 0;
  v_total_erro integer := 0;
begin
  for r in
    select imp.* from unidade_agricola.import_planilha_responsaveis_gestores imp
    where imp.status_importacao in ('pendente', 'erro')
      and (p_lote_importacao is null or imp.lote_importacao = p_lote_importacao)
    order by imp.created_at, imp.linha_origem nulls last
  loop
    v_total_processado := v_total_processado + 1;
    begin
      select u.id_unidade_agricola into v_id_unidade
      from unidade_agricola.unidades_agricolas u
      where u.codigo_unidade = r.codigo_unidade;

      if v_id_unidade is null then
        raise exception 'codigo_unidade não encontrado: %', r.codigo_unidade;
      end if;

      if coalesce(trim(r.nome_responsavel), '') = '' then
        raise exception 'nome_responsavel obrigatório';
      end if;

      insert into unidade_agricola.fractal_cadastro_responsaveis (
        id_unidade_agricola, id_origem, status, payload, sync_status
      ) values (
        v_id_unidade,
        'planilha_responsaveis:' || r.id_importacao::text,
        'validado',
        jsonb_build_object(
          'nome_responsavel', r.nome_responsavel,
          'documento_responsavel', r.documento_responsavel,
          'tipo_responsabilidade', r.tipo_responsabilidade,
          'cargo_funcao', r.cargo_funcao,
          'telefone', r.telefone,
          'email', r.email,
          'nivel_autorizacao', r.nivel_autorizacao,
          'principal', r.principal,
          'observacoes', r.observacoes,
          'origem', 'planilha',
          'lote_importacao', r.lote_importacao
        ),
        'validado'
      )
      returning id_fractal_registro into v_id_fractal;

      insert into unidade_agricola.fractal_eventos_log (
        nome_evento, id_unidade_agricola, id_fractal_registro, modulo_origem,
        submodulo_origem, fractal_origem, status, payload
      ) values (
        'unidade_agricola.fractal_cadastro_responsaveis.validado',
        v_id_unidade,
        v_id_fractal,
        'Mod_Gestao_Unidade_Agricola',
        '03_sub_responsaveis_gestores',
        '01_fractal_cadastro_responsaveis',
        'validado',
        jsonb_build_object('origem','planilha','lote_importacao',r.lote_importacao,'id_importacao',r.id_importacao)
      );

      update unidade_agricola.import_planilha_responsaveis_gestores imp
      set status_importacao = 'importado',
          mensagem_importacao = 'Importado com sucesso',
          id_unidade_agricola = v_id_unidade,
          id_fractal_registro = v_id_fractal,
          processed_at = now()
      where imp.id_importacao = r.id_importacao;

      v_total_importado := v_total_importado + 1;
    exception when others then
      update unidade_agricola.import_planilha_responsaveis_gestores imp
      set status_importacao = 'erro',
          mensagem_importacao = sqlerrm,
          processed_at = now()
      where imp.id_importacao = r.id_importacao;
      v_total_erro := v_total_erro + 1;
    end;
  end loop;

  return query select coalesce(p_lote_importacao, 'todos')::text, v_total_processado, v_total_importado, v_total_erro;
end;
$$;

create or replace function unidade_agricola.processar_importacao_territorios_areas(p_lote_importacao text default null)
returns table (lote_importacao text, total_processado integer, total_importado integer, total_erro integer)
language plpgsql
as $$
declare
  r record;
  v_id_unidade uuid;
  v_id_fractal uuid;
  v_total_processado integer := 0;
  v_total_importado integer := 0;
  v_total_erro integer := 0;
begin
  for r in
    select imp.* from unidade_agricola.import_planilha_territorios_areas imp
    where imp.status_importacao in ('pendente', 'erro')
      and (p_lote_importacao is null or imp.lote_importacao = p_lote_importacao)
    order by imp.created_at, imp.linha_origem nulls last
  loop
    v_total_processado := v_total_processado + 1;
    begin
      select u.id_unidade_agricola into v_id_unidade
      from unidade_agricola.unidades_agricolas u
      where u.codigo_unidade = r.codigo_unidade;

      if v_id_unidade is null then
        raise exception 'codigo_unidade não encontrado: %', r.codigo_unidade;
      end if;

      if coalesce(trim(r.codigo_area), '') = '' or coalesce(trim(r.nome_area), '') = '' then
        raise exception 'codigo_area e nome_area são obrigatórios';
      end if;

      insert into unidade_agricola.fractal_areas_produtivas (
        id_unidade_agricola, id_origem, status, payload, sync_status
      ) values (
        v_id_unidade,
        'planilha_areas:' || r.id_importacao::text,
        'validado',
        jsonb_build_object(
          'codigo_area', r.codigo_area,
          'nome_area', r.nome_area,
          'tipo_area', r.tipo_area,
          'area_ha', nullif(trim(coalesce(r.area_ha, '')), ''),
          'uso_atual', r.uso_atual,
          'cultura_atividade', r.cultura_atividade,
          'latitude_centroide', nullif(trim(coalesce(r.latitude_centroide, '')), ''),
          'longitude_centroide', nullif(trim(coalesce(r.longitude_centroide, '')), ''),
          'status_area', r.status_area,
          'observacoes', r.observacoes,
          'origem', 'planilha',
          'lote_importacao', r.lote_importacao
        ),
        'validado'
      )
      returning id_fractal_registro into v_id_fractal;

      insert into unidade_agricola.fractal_eventos_log (
        nome_evento, id_unidade_agricola, id_fractal_registro, modulo_origem,
        submodulo_origem, fractal_origem, status, payload
      ) values (
        'unidade_agricola.fractal_areas_produtivas.validado',
        v_id_unidade,
        v_id_fractal,
        'Mod_Gestao_Unidade_Agricola',
        '04_sub_territorios_areas_producao',
        '01_fractal_areas_produtivas',
        'validado',
        jsonb_build_object('origem','planilha','lote_importacao',r.lote_importacao,'id_importacao',r.id_importacao)
      );

      update unidade_agricola.import_planilha_territorios_areas imp
      set status_importacao = 'importado',
          mensagem_importacao = 'Importado com sucesso',
          id_unidade_agricola = v_id_unidade,
          id_fractal_registro = v_id_fractal,
          processed_at = now()
      where imp.id_importacao = r.id_importacao;

      v_total_importado := v_total_importado + 1;
    exception when others then
      update unidade_agricola.import_planilha_territorios_areas imp
      set status_importacao = 'erro',
          mensagem_importacao = sqlerrm,
          processed_at = now()
      where imp.id_importacao = r.id_importacao;
      v_total_erro := v_total_erro + 1;
    end;
  end loop;

  return query select coalesce(p_lote_importacao, 'todos')::text, v_total_processado, v_total_importado, v_total_erro;
end;
$$;
