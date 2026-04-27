-- 202604260004_import_planilha_unidade_agricola.sql
-- Fluxo Planilha -> Supabase para o Mod_Gestao_Unidade_Agricola.

create table if not exists unidade_agricola.import_planilha_unidades_agricolas (
  id_importacao uuid primary key default gen_random_uuid(),
  lote_importacao text not null default 'lote_manual',
  linha_origem integer,
  codigo_unidade text,
  nome_unidade text,
  tipo_unidade text,
  status_cadastro text,
  situacao_operacional text,
  uf text,
  municipio text,
  latitude_sede text,
  longitude_sede text,
  area_total_ha text,
  proprietario_nome text,
  proprietario_documento text,
  telefone_principal text,
  email_principal text,
  observacoes text,
  status_importacao text not null default 'pendente',
  mensagem_importacao text,
  id_unidade_agricola uuid,
  payload_original jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  processed_at timestamptz
);

comment on table unidade_agricola.import_planilha_unidades_agricolas is
'Tabela staging para receber CSV/planilha antes de processar para unidades_agricolas e fractais.';

create index if not exists idx_import_planilha_unidades_lote
on unidade_agricola.import_planilha_unidades_agricolas(lote_importacao);

create index if not exists idx_import_planilha_unidades_status
on unidade_agricola.import_planilha_unidades_agricolas(status_importacao);

create or replace function unidade_agricola.processar_importacao_planilha_unidades_agricolas(p_lote_importacao text default null)
returns table (
  lote_importacao text,
  total_processado integer,
  total_importado integer,
  total_erro integer
)
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
    select *
    from unidade_agricola.import_planilha_unidades_agricolas
    where status_importacao in ('pendente', 'erro')
      and (p_lote_importacao is null or import_planilha_unidades_agricolas.lote_importacao = p_lote_importacao)
    order by created_at, linha_origem nulls last
  loop
    v_total_processado := v_total_processado + 1;

    begin
      if coalesce(trim(r.codigo_unidade), '') = '' then
        raise exception 'codigo_unidade obrigatório';
      end if;

      if coalesce(trim(r.nome_unidade), '') = '' then
        raise exception 'nome_unidade obrigatório';
      end if;

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
        trim(r.codigo_unidade),
        trim(r.nome_unidade),
        nullif(trim(coalesce(r.tipo_unidade, '')), ''),
        coalesce(nullif(trim(coalesce(r.status_cadastro, '')), ''), 'Pendente'),
        nullif(trim(coalesce(r.situacao_operacional, '')), ''),
        nullif(trim(coalesce(r.uf, '')), ''),
        nullif(trim(coalesce(r.municipio, '')), ''),
        nullif(trim(coalesce(r.latitude_sede, '')), '')::numeric,
        nullif(trim(coalesce(r.longitude_sede, '')), '')::numeric,
        nullif(trim(coalesce(r.area_total_ha, '')), '')::numeric,
        jsonb_build_object(
          'origem', 'planilha',
          'lote_importacao', r.lote_importacao,
          'linha_origem', r.linha_origem,
          'proprietario_nome', r.proprietario_nome,
          'proprietario_documento', r.proprietario_documento,
          'telefone_principal', r.telefone_principal,
          'email_principal', r.email_principal,
          'observacoes', r.observacoes
        ),
        'validado'
      )
      on conflict (codigo_unidade) do update set
        nome_unidade = excluded.nome_unidade,
        tipo_unidade = excluded.tipo_unidade,
        status_cadastro = excluded.status_cadastro,
        situacao_operacional = excluded.situacao_operacional,
        uf = excluded.uf,
        municipio = excluded.municipio,
        latitude_sede = excluded.latitude_sede,
        longitude_sede = excluded.longitude_sede,
        area_total_ha = excluded.area_total_ha,
        payload = unidade_agricola.unidades_agricolas.payload || excluded.payload,
        sync_status = excluded.sync_status,
        updated_at = now()
      returning id_unidade_agricola into v_id_unidade;

      insert into unidade_agricola.fractal_identidade_unidade (
        id_unidade_agricola,
        id_origem,
        status,
        payload,
        sync_status
      ) values (
        v_id_unidade,
        'planilha:' || r.id_importacao::text,
        'validado',
        jsonb_build_object(
          'codigo_unidade', r.codigo_unidade,
          'nome_unidade', r.nome_unidade,
          'tipo_unidade', r.tipo_unidade,
          'origem', 'planilha',
          'lote_importacao', r.lote_importacao
        ),
        'validado'
      )
      returning id_fractal_registro into v_id_fractal;

      insert into unidade_agricola.fractal_eventos_log (
        nome_evento,
        id_unidade_agricola,
        id_fractal_registro,
        modulo_origem,
        submodulo_origem,
        fractal_origem,
        status,
        payload
      ) values (
        'unidade_agricola.fractal_identidade_unidade.validado',
        v_id_unidade,
        v_id_fractal,
        'Mod_Gestao_Unidade_Agricola',
        null,
        '01_fractal_identidade_unidade',
        'validado',
        jsonb_build_object(
          'origem', 'planilha',
          'lote_importacao', r.lote_importacao,
          'id_importacao', r.id_importacao
        )
      );

      update unidade_agricola.import_planilha_unidades_agricolas
      set
        status_importacao = 'importado',
        mensagem_importacao = 'Importado com sucesso',
        id_unidade_agricola = v_id_unidade,
        processed_at = now()
      where id_importacao = r.id_importacao;

      v_total_importado := v_total_importado + 1;

    exception when others then
      update unidade_agricola.import_planilha_unidades_agricolas
      set
        status_importacao = 'erro',
        mensagem_importacao = sqlerrm,
        processed_at = now()
      where id_importacao = r.id_importacao;

      v_total_erro := v_total_erro + 1;
    end;
  end loop;

  return query
  select
    coalesce(p_lote_importacao, 'todos')::text,
    v_total_processado,
    v_total_importado,
    v_total_erro;
end;
$$;

create or replace view unidade_agricola.vw_importacao_planilha_unidades_status as
select
  lote_importacao,
  status_importacao,
  count(*) as total_linhas,
  count(*) filter (where id_unidade_agricola is not null) as total_com_unidade,
  min(created_at) as primeira_linha_em,
  max(processed_at) as ultimo_processamento_em
from unidade_agricola.import_planilha_unidades_agricolas
group by lote_importacao, status_importacao;

comment on view unidade_agricola.vw_importacao_planilha_unidades_status is
'Resumo dos lotes importados da planilha para unidades agrícolas.';
