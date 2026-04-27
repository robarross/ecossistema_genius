-- 202604260006_import_submodulos_base_unidade_agricola.sql
-- Importação Planilha -> Supabase para submódulos base:
-- proprietários/possuidores, responsáveis/gestores e territórios/áreas de produção.

create table if not exists unidade_agricola.import_planilha_proprietarios_possuidores (
  id_importacao uuid primary key default gen_random_uuid(),
  lote_importacao text not null default 'lote_manual',
  linha_origem integer,
  codigo_unidade text not null,
  nome_titular text not null,
  documento_titular text,
  tipo_titular text,
  tipo_vinculo text,
  percentual_participacao text,
  telefone text,
  email text,
  observacoes text,
  status_importacao text not null default 'pendente',
  mensagem_importacao text,
  id_unidade_agricola uuid,
  id_fractal_registro uuid,
  created_at timestamptz not null default now(),
  processed_at timestamptz
);

create table if not exists unidade_agricola.import_planilha_responsaveis_gestores (
  id_importacao uuid primary key default gen_random_uuid(),
  lote_importacao text not null default 'lote_manual',
  linha_origem integer,
  codigo_unidade text not null,
  nome_responsavel text not null,
  documento_responsavel text,
  tipo_responsabilidade text,
  cargo_funcao text,
  telefone text,
  email text,
  nivel_autorizacao text,
  principal text,
  observacoes text,
  status_importacao text not null default 'pendente',
  mensagem_importacao text,
  id_unidade_agricola uuid,
  id_fractal_registro uuid,
  created_at timestamptz not null default now(),
  processed_at timestamptz
);

create table if not exists unidade_agricola.import_planilha_territorios_areas (
  id_importacao uuid primary key default gen_random_uuid(),
  lote_importacao text not null default 'lote_manual',
  linha_origem integer,
  codigo_unidade text not null,
  codigo_area text not null,
  nome_area text not null,
  tipo_area text,
  area_ha text,
  uso_atual text,
  cultura_atividade text,
  latitude_centroide text,
  longitude_centroide text,
  status_area text,
  observacoes text,
  status_importacao text not null default 'pendente',
  mensagem_importacao text,
  id_unidade_agricola uuid,
  id_fractal_registro uuid,
  created_at timestamptz not null default now(),
  processed_at timestamptz
);

create index if not exists idx_import_prop_lote on unidade_agricola.import_planilha_proprietarios_possuidores(lote_importacao);
create index if not exists idx_import_resp_lote on unidade_agricola.import_planilha_responsaveis_gestores(lote_importacao);
create index if not exists idx_import_area_lote on unidade_agricola.import_planilha_territorios_areas(lote_importacao);

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
    select * from unidade_agricola.import_planilha_proprietarios_possuidores
    where status_importacao in ('pendente', 'erro')
      and (p_lote_importacao is null or lote_importacao = p_lote_importacao)
    order by created_at, linha_origem nulls last
  loop
    v_total_processado := v_total_processado + 1;
    begin
      select id_unidade_agricola into v_id_unidade
      from unidade_agricola.unidades_agricolas
      where codigo_unidade = r.codigo_unidade;

      if v_id_unidade is null then
        raise exception 'codigo_unidade não encontrado: %', r.codigo_unidade;
      end if;

      if coalesce(trim(r.nome_titular), '') = '' then
        raise exception 'nome_titular obrigatório';
      end if;

      insert into unidade_agricola.fractal_cadastro_proprietarios (
        id_unidade_agricola,
        id_origem,
        status,
        payload,
        sync_status
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

      update unidade_agricola.import_planilha_proprietarios_possuidores
      set status_importacao = 'importado', mensagem_importacao = 'Importado com sucesso',
          id_unidade_agricola = v_id_unidade, id_fractal_registro = v_id_fractal, processed_at = now()
      where id_importacao = r.id_importacao;

      v_total_importado := v_total_importado + 1;
    exception when others then
      update unidade_agricola.import_planilha_proprietarios_possuidores
      set status_importacao = 'erro', mensagem_importacao = sqlerrm, processed_at = now()
      where id_importacao = r.id_importacao;
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
    select * from unidade_agricola.import_planilha_responsaveis_gestores
    where status_importacao in ('pendente', 'erro')
      and (p_lote_importacao is null or lote_importacao = p_lote_importacao)
    order by created_at, linha_origem nulls last
  loop
    v_total_processado := v_total_processado + 1;
    begin
      select id_unidade_agricola into v_id_unidade
      from unidade_agricola.unidades_agricolas
      where codigo_unidade = r.codigo_unidade;

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

      update unidade_agricola.import_planilha_responsaveis_gestores
      set status_importacao = 'importado', mensagem_importacao = 'Importado com sucesso',
          id_unidade_agricola = v_id_unidade, id_fractal_registro = v_id_fractal, processed_at = now()
      where id_importacao = r.id_importacao;

      v_total_importado := v_total_importado + 1;
    exception when others then
      update unidade_agricola.import_planilha_responsaveis_gestores
      set status_importacao = 'erro', mensagem_importacao = sqlerrm, processed_at = now()
      where id_importacao = r.id_importacao;
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
    select * from unidade_agricola.import_planilha_territorios_areas
    where status_importacao in ('pendente', 'erro')
      and (p_lote_importacao is null or lote_importacao = p_lote_importacao)
    order by created_at, linha_origem nulls last
  loop
    v_total_processado := v_total_processado + 1;
    begin
      select id_unidade_agricola into v_id_unidade
      from unidade_agricola.unidades_agricolas
      where codigo_unidade = r.codigo_unidade;

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

      update unidade_agricola.import_planilha_territorios_areas
      set status_importacao = 'importado', mensagem_importacao = 'Importado com sucesso',
          id_unidade_agricola = v_id_unidade, id_fractal_registro = v_id_fractal, processed_at = now()
      where id_importacao = r.id_importacao;

      v_total_importado := v_total_importado + 1;
    exception when others then
      update unidade_agricola.import_planilha_territorios_areas
      set status_importacao = 'erro', mensagem_importacao = sqlerrm, processed_at = now()
      where id_importacao = r.id_importacao;
      v_total_erro := v_total_erro + 1;
    end;
  end loop;

  return query select coalesce(p_lote_importacao, 'todos')::text, v_total_processado, v_total_importado, v_total_erro;
end;
$$;

create or replace view unidade_agricola.vw_importacao_submodulos_base_status as
select 'proprietarios_possuidores' as origem, lote_importacao, status_importacao, count(*) as total
from unidade_agricola.import_planilha_proprietarios_possuidores
group by lote_importacao, status_importacao
union all
select 'responsaveis_gestores' as origem, lote_importacao, status_importacao, count(*) as total
from unidade_agricola.import_planilha_responsaveis_gestores
group by lote_importacao, status_importacao
union all
select 'territorios_areas' as origem, lote_importacao, status_importacao, count(*) as total
from unidade_agricola.import_planilha_territorios_areas
group by lote_importacao, status_importacao;
