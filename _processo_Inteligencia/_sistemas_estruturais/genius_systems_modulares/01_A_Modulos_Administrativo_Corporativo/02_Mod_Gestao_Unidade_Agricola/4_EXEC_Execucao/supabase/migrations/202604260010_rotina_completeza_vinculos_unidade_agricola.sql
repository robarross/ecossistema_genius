-- 202604260010_rotina_completeza_vinculos_unidade_agricola.sql
-- Rotina de completeza de vínculos básicos para unidades sem proprietário, responsável ou área.

create or replace function unidade_agricola.completar_vinculos_basicos_unidade(
  p_codigo_unidade text,
  p_nome_titular text default null,
  p_nome_responsavel text default null,
  p_codigo_area text default null,
  p_nome_area text default null,
  p_area_ha numeric default null
)
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
  v_id_unidade uuid;
  v_nome_unidade text;
  v_id_fractal uuid;
  v_proprietario_criado boolean := false;
  v_responsavel_criado boolean := false;
  v_area_criada boolean := false;
  v_eventos integer := 0;
begin
  select id_unidade_agricola, nome_unidade
  into v_id_unidade, v_nome_unidade
  from unidade_agricola.unidades_agricolas
  where unidades_agricolas.codigo_unidade = p_codigo_unidade;

  if v_id_unidade is null then
    raise exception 'codigo_unidade não encontrado: %', p_codigo_unidade;
  end if;

  if not exists (
    select 1 from unidade_agricola.fractal_cadastro_proprietarios f
    where f.id_unidade_agricola = v_id_unidade
  ) then
    insert into unidade_agricola.fractal_cadastro_proprietarios (
      id_unidade_agricola,
      id_origem,
      status,
      payload,
      sync_status
    ) values (
      v_id_unidade,
      'completeza_vinculos:' || p_codigo_unidade || ':proprietario',
      'validado',
      jsonb_build_object(
        'nome_titular', coalesce(p_nome_titular, 'Titular de ' || v_nome_unidade),
        'tipo_titular', 'Nao informado',
        'tipo_vinculo', 'A complementar',
        'origem', 'completeza_vinculos',
        'observacoes', 'Registro criado para completar vínculo mínimo da unidade.'
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
      'unidade_agricola.fractal_cadastro_proprietarios.validado',
      v_id_unidade,
      v_id_fractal,
      'Mod_Gestao_Unidade_Agricola',
      '02_sub_proprietarios_possuidores',
      '01_fractal_cadastro_proprietarios',
      'validado',
      jsonb_build_object('origem','completeza_vinculos','codigo_unidade',p_codigo_unidade)
    );

    v_proprietario_criado := true;
    v_eventos := v_eventos + 1;
  end if;

  if not exists (
    select 1 from unidade_agricola.fractal_cadastro_responsaveis f
    where f.id_unidade_agricola = v_id_unidade
  ) then
    insert into unidade_agricola.fractal_cadastro_responsaveis (
      id_unidade_agricola,
      id_origem,
      status,
      payload,
      sync_status
    ) values (
      v_id_unidade,
      'completeza_vinculos:' || p_codigo_unidade || ':responsavel',
      'validado',
      jsonb_build_object(
        'nome_responsavel', coalesce(p_nome_responsavel, 'Responsavel de ' || v_nome_unidade),
        'tipo_responsabilidade', 'Operacional',
        'cargo_funcao', 'Responsavel principal',
        'principal', 'Sim',
        'origem', 'completeza_vinculos',
        'observacoes', 'Registro criado para completar vínculo mínimo da unidade.'
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
      'unidade_agricola.fractal_cadastro_responsaveis.validado',
      v_id_unidade,
      v_id_fractal,
      'Mod_Gestao_Unidade_Agricola',
      '03_sub_responsaveis_gestores',
      '01_fractal_cadastro_responsaveis',
      'validado',
      jsonb_build_object('origem','completeza_vinculos','codigo_unidade',p_codigo_unidade)
    );

    v_responsavel_criado := true;
    v_eventos := v_eventos + 1;
  end if;

  if not exists (
    select 1 from unidade_agricola.fractal_areas_produtivas f
    where f.id_unidade_agricola = v_id_unidade
  ) then
    insert into unidade_agricola.fractal_areas_produtivas (
      id_unidade_agricola,
      id_origem,
      status,
      payload,
      sync_status
    ) values (
      v_id_unidade,
      'completeza_vinculos:' || p_codigo_unidade || ':area',
      'validado',
      jsonb_build_object(
        'codigo_area', coalesce(p_codigo_area, p_codigo_unidade || '-AREA-01'),
        'nome_area', coalesce(p_nome_area, 'Area principal de ' || v_nome_unidade),
        'tipo_area', 'Area produtiva',
        'area_ha', coalesce(p_area_ha, 0),
        'status_area', 'Ativo',
        'origem', 'completeza_vinculos',
        'observacoes', 'Registro criado para completar vínculo mínimo da unidade.'
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
      'unidade_agricola.fractal_areas_produtivas.validado',
      v_id_unidade,
      v_id_fractal,
      'Mod_Gestao_Unidade_Agricola',
      '04_sub_territorios_areas_producao',
      '01_fractal_areas_produtivas',
      'validado',
      jsonb_build_object('origem','completeza_vinculos','codigo_unidade',p_codigo_unidade)
    );

    v_area_criada := true;
    v_eventos := v_eventos + 1;
  end if;

  return query select p_codigo_unidade, v_proprietario_criado, v_responsavel_criado, v_area_criada, v_eventos;
end;
$$;

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
    select codigo_unidade
    from unidade_agricola.vw_auditoria_unidades_sem_vinculos
    order by codigo_unidade
  loop
    return query
    select *
    from unidade_agricola.completar_vinculos_basicos_unidade(r.codigo_unidade);
  end loop;
end;
$$;
