-- SUPABASE_SCHEMA_Mod_Gestao_Unidade_Agricola.sql
-- Modulo: Mod_Gestao_Unidade_Agricola
-- Gerado a partir de 68 fractais plug and play.

create extension if not exists pgcrypto;

create schema if not exists unidade_agricola;

create table if not exists unidade_agricola.unidades_agricolas (
  id_unidade_agricola uuid primary key default gen_random_uuid(),
  codigo_unidade text unique not null,
  nome_unidade text not null,
  tipo_unidade text,
  status_cadastro text not null default 'pendente',
  situacao_operacional text,
  uf text,
  municipio text,
  latitude_sede numeric,
  longitude_sede numeric,
  area_total_ha numeric,
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.unidades_agricolas is 'Tabela raiz do Mod_Gestao_Unidade_Agricola. Serve de ancora para os fractais do modulo.';

create index if not exists idx_unidades_agricolas_codigo on unidade_agricola.unidades_agricolas(codigo_unidade);
create index if not exists idx_unidades_agricolas_status on unidade_agricola.unidades_agricolas(status_cadastro);
create index if not exists idx_unidades_agricolas_municipio_uf on unidade_agricola.unidades_agricolas(uf, municipio);
create index if not exists idx_unidades_agricolas_payload_gin on unidade_agricola.unidades_agricolas using gin(payload);

create table if not exists unidade_agricola.fractal_eventos_catalogo (
  id_evento_catalogo uuid primary key default gen_random_uuid(),
  nome_evento text unique not null,
  modulo_origem text not null,
  submodulo_origem text,
  fractal_origem text not null,
  tabela_origem text not null,
  acao text not null,
  ativo boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists unidade_agricola.fractal_eventos_log (
  id_evento uuid primary key default gen_random_uuid(),
  nome_evento text not null references unidade_agricola.fractal_eventos_catalogo(nome_evento),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete set null,
  id_fractal_registro uuid,
  modulo_origem text not null,
  submodulo_origem text,
  fractal_origem text not null,
  status text not null default 'pendente',
  payload jsonb not null default '{}'::jsonb,
  published_at timestamptz not null default now()
);

create index if not exists idx_fractal_eventos_log_unidade on unidade_agricola.fractal_eventos_log(id_unidade_agricola);
create index if not exists idx_fractal_eventos_log_nome on unidade_agricola.fractal_eventos_log(nome_evento);
create index if not exists idx_fractal_eventos_log_payload_gin on unidade_agricola.fractal_eventos_log using gin(payload);

create table if not exists unidade_agricola.fractal_identidade_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_identidade_unidade is 'Identidade da unidade - Define codigo, nome, tipo, localizacao e identidade operacional da unidade agricola.';
comment on column unidade_agricola.fractal_identidade_unidade.payload is 'Payload flexivel do fractal 01_fractal_identidade_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_identidade_unidade_unidade on unidade_agricola.fractal_identidade_unidade(id_unidade_agricola);
create index if not exists idx_fractal_identidade_unidade_status on unidade_agricola.fractal_identidade_unidade(status);
create index if not exists idx_fractal_identidade_unidade_sync_status on unidade_agricola.fractal_identidade_unidade(sync_status);
create index if not exists idx_fractal_identidade_unidade_payload_gin on unidade_agricola.fractal_identidade_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_relacionamentos_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_relacionamentos_unidade is 'Relacionamentos da unidade - Conecta unidade agricola com proprietarios, gestores, areas, documentos, ativos e modulos do ecossistema.';
comment on column unidade_agricola.fractal_relacionamentos_unidade.payload is 'Payload flexivel do fractal 02_fractal_relacionamentos_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_relacionamentos_unidade_unidade on unidade_agricola.fractal_relacionamentos_unidade(id_unidade_agricola);
create index if not exists idx_fractal_relacionamentos_unidade_status on unidade_agricola.fractal_relacionamentos_unidade(status);
create index if not exists idx_fractal_relacionamentos_unidade_sync_status on unidade_agricola.fractal_relacionamentos_unidade(sync_status);
create index if not exists idx_fractal_relacionamentos_unidade_payload_gin on unidade_agricola.fractal_relacionamentos_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_governanca_permissoes (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_governanca_permissoes is 'Governanca e permissoes - Controla perfis, acessos, responsabilidades, autorizacoes e regras de governanca.';
comment on column unidade_agricola.fractal_governanca_permissoes.payload is 'Payload flexivel do fractal 03_fractal_governanca_permissoes. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_governanca_permissoes_unidade on unidade_agricola.fractal_governanca_permissoes(id_unidade_agricola);
create index if not exists idx_fractal_governanca_permissoes_status on unidade_agricola.fractal_governanca_permissoes(status);
create index if not exists idx_fractal_governanca_permissoes_sync_status on unidade_agricola.fractal_governanca_permissoes(sync_status);
create index if not exists idx_fractal_governanca_permissoes_payload_gin on unidade_agricola.fractal_governanca_permissoes using gin(payload);

create table if not exists unidade_agricola.fractal_documental_juridico (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_documental_juridico is 'Documental e juridico - Organiza documentos, certidoes, registros, contratos e evidencias juridicas da unidade.';
comment on column unidade_agricola.fractal_documental_juridico.payload is 'Payload flexivel do fractal 04_fractal_documental_juridico. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_documental_juridico_unidade on unidade_agricola.fractal_documental_juridico(id_unidade_agricola);
create index if not exists idx_fractal_documental_juridico_status on unidade_agricola.fractal_documental_juridico(status);
create index if not exists idx_fractal_documental_juridico_sync_status on unidade_agricola.fractal_documental_juridico(sync_status);
create index if not exists idx_fractal_documental_juridico_payload_gin on unidade_agricola.fractal_documental_juridico using gin(payload);

create table if not exists unidade_agricola.fractal_operacional_status (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_operacional_status is 'Status operacional - Controla situacao operacional, produtiva, documental, estrutural e regulatoria da unidade.';
comment on column unidade_agricola.fractal_operacional_status.payload is 'Payload flexivel do fractal 05_fractal_operacional_status. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_operacional_status_unidade on unidade_agricola.fractal_operacional_status(id_unidade_agricola);
create index if not exists idx_fractal_operacional_status_status on unidade_agricola.fractal_operacional_status(status);
create index if not exists idx_fractal_operacional_status_sync_status on unidade_agricola.fractal_operacional_status(sync_status);
create index if not exists idx_fractal_operacional_status_payload_gin on unidade_agricola.fractal_operacional_status using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_ecossistema (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_ecossistema is 'Integracao com ecossistema - Publica e consome dados para producao, financeiro, fiscal, ambiental, dashboards, DataLake, Hub e APIs.';
comment on column unidade_agricola.fractal_integracao_ecossistema.payload is 'Payload flexivel do fractal 06_fractal_integracao_ecossistema. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_ecossistema_unidade on unidade_agricola.fractal_integracao_ecossistema(id_unidade_agricola);
create index if not exists idx_fractal_integracao_ecossistema_status on unidade_agricola.fractal_integracao_ecossistema(status);
create index if not exists idx_fractal_integracao_ecossistema_sync_status on unidade_agricola.fractal_integracao_ecossistema(sync_status);
create index if not exists idx_fractal_integracao_ecossistema_payload_gin on unidade_agricola.fractal_integracao_ecossistema using gin(payload);

create table if not exists unidade_agricola.fractal_indicadores_dashboards (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_indicadores_dashboards is 'Indicadores e dashboards - Estrutura indicadores, metricas, visoes gerenciais e sinais de acompanhamento da unidade agricola.';
comment on column unidade_agricola.fractal_indicadores_dashboards.payload is 'Payload flexivel do fractal 07_fractal_indicadores_dashboards. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_indicadores_dashboards_unidade on unidade_agricola.fractal_indicadores_dashboards(id_unidade_agricola);
create index if not exists idx_fractal_indicadores_dashboards_status on unidade_agricola.fractal_indicadores_dashboards(status);
create index if not exists idx_fractal_indicadores_dashboards_sync_status on unidade_agricola.fractal_indicadores_dashboards(sync_status);
create index if not exists idx_fractal_indicadores_dashboards_payload_gin on unidade_agricola.fractal_indicadores_dashboards using gin(payload);

create table if not exists unidade_agricola.fractal_inteligencia_automacoes (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_inteligencia_automacoes is 'Inteligencia e automacoes - Habilita alertas, agentes, recomendacoes, regras, validacoes e automacoes futuras.';
comment on column unidade_agricola.fractal_inteligencia_automacoes.payload is 'Payload flexivel do fractal 08_fractal_inteligencia_automacoes. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_inteligencia_automacoes_unidade on unidade_agricola.fractal_inteligencia_automacoes(id_unidade_agricola);
create index if not exists idx_fractal_inteligencia_automacoes_status on unidade_agricola.fractal_inteligencia_automacoes(status);
create index if not exists idx_fractal_inteligencia_automacoes_sync_status on unidade_agricola.fractal_inteligencia_automacoes(sync_status);
create index if not exists idx_fractal_inteligencia_automacoes_payload_gin on unidade_agricola.fractal_inteligencia_automacoes using gin(payload);

create table if not exists unidade_agricola.fractal_dados_basicos_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_dados_basicos_unidade is 'Dados basicos da unidade - Registra identificadores, nome, codigo, tipo, categoria e dados essenciais da unidade agricola.';
comment on column unidade_agricola.fractal_dados_basicos_unidade.payload is 'Payload flexivel do fractal 01_fractal_dados_basicos_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_dados_basicos_unidade_unidade on unidade_agricola.fractal_dados_basicos_unidade(id_unidade_agricola);
create index if not exists idx_fractal_dados_basicos_unidade_status on unidade_agricola.fractal_dados_basicos_unidade(status);
create index if not exists idx_fractal_dados_basicos_unidade_sync_status on unidade_agricola.fractal_dados_basicos_unidade(sync_status);
create index if not exists idx_fractal_dados_basicos_unidade_payload_gin on unidade_agricola.fractal_dados_basicos_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_localizacao_referencia_territorial (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_localizacao_referencia_territorial is 'Localizacao e referencia territorial - Registra endereco, coordenadas, municipio, UF, comunidade, acesso e referencias territoriais.';
comment on column unidade_agricola.fractal_localizacao_referencia_territorial.payload is 'Payload flexivel do fractal 02_fractal_localizacao_referencia_territorial. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_localizacao_referencia_territorial_unidade on unidade_agricola.fractal_localizacao_referencia_territorial(id_unidade_agricola);
create index if not exists idx_fractal_localizacao_referencia_territorial_status on unidade_agricola.fractal_localizacao_referencia_territorial(status);
create index if not exists idx_fractal_localizacao_referencia_territorial_sync_status on unidade_agricola.fractal_localizacao_referencia_territorial(sync_status);
create index if not exists idx_fractal_localizacao_referencia_territorial_payload_gin on unidade_agricola.fractal_localizacao_referencia_territorial using gin(payload);

create table if not exists unidade_agricola.fractal_classificacao_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_classificacao_unidade is 'Classificacao da unidade - Classifica a unidade por tipo, porte, finalidade, uso predominante e perfil produtivo.';
comment on column unidade_agricola.fractal_classificacao_unidade.payload is 'Payload flexivel do fractal 03_fractal_classificacao_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_classificacao_unidade_unidade on unidade_agricola.fractal_classificacao_unidade(id_unidade_agricola);
create index if not exists idx_fractal_classificacao_unidade_status on unidade_agricola.fractal_classificacao_unidade(status);
create index if not exists idx_fractal_classificacao_unidade_sync_status on unidade_agricola.fractal_classificacao_unidade(sync_status);
create index if not exists idx_fractal_classificacao_unidade_payload_gin on unidade_agricola.fractal_classificacao_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_situacao_cadastral (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_situacao_cadastral is 'Situacao cadastral - Controla status cadastral, pendencias, revisoes, validacoes e historico de atualizacao.';
comment on column unidade_agricola.fractal_situacao_cadastral.payload is 'Payload flexivel do fractal 04_fractal_situacao_cadastral. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_situacao_cadastral_unidade on unidade_agricola.fractal_situacao_cadastral(id_unidade_agricola);
create index if not exists idx_fractal_situacao_cadastral_status on unidade_agricola.fractal_situacao_cadastral(status);
create index if not exists idx_fractal_situacao_cadastral_sync_status on unidade_agricola.fractal_situacao_cadastral(sync_status);
create index if not exists idx_fractal_situacao_cadastral_payload_gin on unidade_agricola.fractal_situacao_cadastral using gin(payload);

create table if not exists unidade_agricola.fractal_validacao_campos_obrigatorios (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_validacao_campos_obrigatorios is 'Validacao de campos obrigatorios - Define regras minimas de preenchimento, consistencia e liberacao para integracoes.';
comment on column unidade_agricola.fractal_validacao_campos_obrigatorios.payload is 'Payload flexivel do fractal 05_fractal_validacao_campos_obrigatorios. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_validacao_campos_obrigatorios_unidade on unidade_agricola.fractal_validacao_campos_obrigatorios(id_unidade_agricola);
create index if not exists idx_fractal_validacao_campos_obrigatorios_status on unidade_agricola.fractal_validacao_campos_obrigatorios(status);
create index if not exists idx_fractal_validacao_campos_obrigatorios_sync_status on unidade_agricola.fractal_validacao_campos_obrigatorios(sync_status);
create index if not exists idx_fractal_validacao_campos_obrigatorios_payload_gin on unidade_agricola.fractal_validacao_campos_obrigatorios using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_datalake_mapas_modulos (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_datalake_mapas_modulos is 'Integracao DataLake mapas modulos - Conecta o cadastro da unidade ao DataLake, mapas, Hub, dashboards e modulos dependentes.';
comment on column unidade_agricola.fractal_integracao_datalake_mapas_modulos.payload is 'Payload flexivel do fractal 06_fractal_integracao_datalake_mapas_modulos. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_datalake_mapas_modulos_unidade on unidade_agricola.fractal_integracao_datalake_mapas_modulos(id_unidade_agricola);
create index if not exists idx_fractal_integracao_datalake_mapas_modulos_status on unidade_agricola.fractal_integracao_datalake_mapas_modulos(status);
create index if not exists idx_fractal_integracao_datalake_mapas_modulos_sync_status on unidade_agricola.fractal_integracao_datalake_mapas_modulos(sync_status);
create index if not exists idx_fractal_integracao_datalake_mapas_modulos_payload_gin on unidade_agricola.fractal_integracao_datalake_mapas_modulos using gin(payload);

create table if not exists unidade_agricola.fractal_cadastro_proprietarios (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_cadastro_proprietarios is 'Cadastro de proprietarios - Registra proprietarios pessoas fisicas ou juridicas vinculados a unidade agricola.';
comment on column unidade_agricola.fractal_cadastro_proprietarios.payload is 'Payload flexivel do fractal 01_fractal_cadastro_proprietarios. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_cadastro_proprietarios_unidade on unidade_agricola.fractal_cadastro_proprietarios(id_unidade_agricola);
create index if not exists idx_fractal_cadastro_proprietarios_status on unidade_agricola.fractal_cadastro_proprietarios(status);
create index if not exists idx_fractal_cadastro_proprietarios_sync_status on unidade_agricola.fractal_cadastro_proprietarios(sync_status);
create index if not exists idx_fractal_cadastro_proprietarios_payload_gin on unidade_agricola.fractal_cadastro_proprietarios using gin(payload);

create table if not exists unidade_agricola.fractal_cadastro_possuidores (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_cadastro_possuidores is 'Cadastro de possuidores - Registra possuidores, ocupantes, arrendatarios e demais titulares operacionais da unidade.';
comment on column unidade_agricola.fractal_cadastro_possuidores.payload is 'Payload flexivel do fractal 02_fractal_cadastro_possuidores. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_cadastro_possuidores_unidade on unidade_agricola.fractal_cadastro_possuidores(id_unidade_agricola);
create index if not exists idx_fractal_cadastro_possuidores_status on unidade_agricola.fractal_cadastro_possuidores(status);
create index if not exists idx_fractal_cadastro_possuidores_sync_status on unidade_agricola.fractal_cadastro_possuidores(sync_status);
create index if not exists idx_fractal_cadastro_possuidores_payload_gin on unidade_agricola.fractal_cadastro_possuidores using gin(payload);

create table if not exists unidade_agricola.fractal_documentos_titulares (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_documentos_titulares is 'Documentos dos titulares - Organiza documentos pessoais, empresariais, fundiarios e cadastrais dos titulares.';
comment on column unidade_agricola.fractal_documentos_titulares.payload is 'Payload flexivel do fractal 03_fractal_documentos_titulares. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_documentos_titulares_unidade on unidade_agricola.fractal_documentos_titulares(id_unidade_agricola);
create index if not exists idx_fractal_documentos_titulares_status on unidade_agricola.fractal_documentos_titulares(status);
create index if not exists idx_fractal_documentos_titulares_sync_status on unidade_agricola.fractal_documentos_titulares(sync_status);
create index if not exists idx_fractal_documentos_titulares_payload_gin on unidade_agricola.fractal_documentos_titulares using gin(payload);

create table if not exists unidade_agricola.fractal_vinculos_unidade_agricola (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_vinculos_unidade_agricola is 'Vinculos com unidade agricola - Define tipo de vinculo, percentual, periodo, responsabilidade e status da relacao.';
comment on column unidade_agricola.fractal_vinculos_unidade_agricola.payload is 'Payload flexivel do fractal 04_fractal_vinculos_unidade_agricola. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_vinculos_unidade_agricola_unidade on unidade_agricola.fractal_vinculos_unidade_agricola(id_unidade_agricola);
create index if not exists idx_fractal_vinculos_unidade_agricola_status on unidade_agricola.fractal_vinculos_unidade_agricola(status);
create index if not exists idx_fractal_vinculos_unidade_agricola_sync_status on unidade_agricola.fractal_vinculos_unidade_agricola(sync_status);
create index if not exists idx_fractal_vinculos_unidade_agricola_payload_gin on unidade_agricola.fractal_vinculos_unidade_agricola using gin(payload);

create table if not exists unidade_agricola.fractal_historico_titularidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_historico_titularidade is 'Historico de titularidade - Mantem historico de alteracoes, transferencias, substituicoes e revisoes de titularidade.';
comment on column unidade_agricola.fractal_historico_titularidade.payload is 'Payload flexivel do fractal 05_fractal_historico_titularidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_historico_titularidade_unidade on unidade_agricola.fractal_historico_titularidade(id_unidade_agricola);
create index if not exists idx_fractal_historico_titularidade_status on unidade_agricola.fractal_historico_titularidade(status);
create index if not exists idx_fractal_historico_titularidade_sync_status on unidade_agricola.fractal_historico_titularidade(sync_status);
create index if not exists idx_fractal_historico_titularidade_payload_gin on unidade_agricola.fractal_historico_titularidade using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_contratos_juridico_permissoes (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_contratos_juridico_permissoes is 'Integracao contratos juridico permissoes - Integra titulares com contratos, juridico, fiscal, permissoes, usuarios e auditoria.';
comment on column unidade_agricola.fractal_integracao_contratos_juridico_permissoes.payload is 'Payload flexivel do fractal 06_fractal_integracao_contratos_juridico_permissoes. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_contratos_juridico_permissoes_unidade on unidade_agricola.fractal_integracao_contratos_juridico_permissoes(id_unidade_agricola);
create index if not exists idx_fractal_integracao_contratos_juridico_permissoes_status on unidade_agricola.fractal_integracao_contratos_juridico_permissoes(status);
create index if not exists idx_fractal_integracao_contratos_juridico_permissoes_sync_status on unidade_agricola.fractal_integracao_contratos_juridico_permissoes(sync_status);
create index if not exists idx_fractal_integracao_contratos_juridico_permissoes_payload_gin on unidade_agricola.fractal_integracao_contratos_juridico_permissoes using gin(payload);

create table if not exists unidade_agricola.fractal_cadastro_responsaveis (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_cadastro_responsaveis is 'Cadastro de responsaveis - Registra responsaveis administrativos, tecnicos, operacionais e financeiros.';
comment on column unidade_agricola.fractal_cadastro_responsaveis.payload is 'Payload flexivel do fractal 01_fractal_cadastro_responsaveis. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_cadastro_responsaveis_unidade on unidade_agricola.fractal_cadastro_responsaveis(id_unidade_agricola);
create index if not exists idx_fractal_cadastro_responsaveis_status on unidade_agricola.fractal_cadastro_responsaveis(status);
create index if not exists idx_fractal_cadastro_responsaveis_sync_status on unidade_agricola.fractal_cadastro_responsaveis(sync_status);
create index if not exists idx_fractal_cadastro_responsaveis_payload_gin on unidade_agricola.fractal_cadastro_responsaveis using gin(payload);

create table if not exists unidade_agricola.fractal_funcoes_papeis_operacionais (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_funcoes_papeis_operacionais is 'Funcoes e papeis operacionais - Define papeis, funcoes, alcadas e responsabilidades praticas na unidade.';
comment on column unidade_agricola.fractal_funcoes_papeis_operacionais.payload is 'Payload flexivel do fractal 02_fractal_funcoes_papeis_operacionais. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_funcoes_papeis_operacionais_unidade on unidade_agricola.fractal_funcoes_papeis_operacionais(id_unidade_agricola);
create index if not exists idx_fractal_funcoes_papeis_operacionais_status on unidade_agricola.fractal_funcoes_papeis_operacionais(status);
create index if not exists idx_fractal_funcoes_papeis_operacionais_sync_status on unidade_agricola.fractal_funcoes_papeis_operacionais(sync_status);
create index if not exists idx_fractal_funcoes_papeis_operacionais_payload_gin on unidade_agricola.fractal_funcoes_papeis_operacionais using gin(payload);

create table if not exists unidade_agricola.fractal_responsabilidade_tecnica (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_responsabilidade_tecnica is 'Responsabilidade tecnica - Controla responsaveis tecnicos, registros, areas de atuacao e vigencia.';
comment on column unidade_agricola.fractal_responsabilidade_tecnica.payload is 'Payload flexivel do fractal 03_fractal_responsabilidade_tecnica. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_responsabilidade_tecnica_unidade on unidade_agricola.fractal_responsabilidade_tecnica(id_unidade_agricola);
create index if not exists idx_fractal_responsabilidade_tecnica_status on unidade_agricola.fractal_responsabilidade_tecnica(status);
create index if not exists idx_fractal_responsabilidade_tecnica_sync_status on unidade_agricola.fractal_responsabilidade_tecnica(sync_status);
create index if not exists idx_fractal_responsabilidade_tecnica_payload_gin on unidade_agricola.fractal_responsabilidade_tecnica using gin(payload);

create table if not exists unidade_agricola.fractal_responsabilidade_administrativa (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_responsabilidade_administrativa is 'Responsabilidade administrativa - Organiza responsaveis por documentos, compras, contratos, prestacao de contas e rotina administrativa.';
comment on column unidade_agricola.fractal_responsabilidade_administrativa.payload is 'Payload flexivel do fractal 04_fractal_responsabilidade_administrativa. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_responsabilidade_administrativa_unidade on unidade_agricola.fractal_responsabilidade_administrativa(id_unidade_agricola);
create index if not exists idx_fractal_responsabilidade_administrativa_status on unidade_agricola.fractal_responsabilidade_administrativa(status);
create index if not exists idx_fractal_responsabilidade_administrativa_sync_status on unidade_agricola.fractal_responsabilidade_administrativa(sync_status);
create index if not exists idx_fractal_responsabilidade_administrativa_payload_gin on unidade_agricola.fractal_responsabilidade_administrativa using gin(payload);

create table if not exists unidade_agricola.fractal_niveis_autorizacao (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_niveis_autorizacao is 'Niveis de autorizacao - Define niveis de aprovacao, acesso, decisao e assinatura por perfil.';
comment on column unidade_agricola.fractal_niveis_autorizacao.payload is 'Payload flexivel do fractal 05_fractal_niveis_autorizacao. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_niveis_autorizacao_unidade on unidade_agricola.fractal_niveis_autorizacao(id_unidade_agricola);
create index if not exists idx_fractal_niveis_autorizacao_status on unidade_agricola.fractal_niveis_autorizacao(status);
create index if not exists idx_fractal_niveis_autorizacao_sync_status on unidade_agricola.fractal_niveis_autorizacao(sync_status);
create index if not exists idx_fractal_niveis_autorizacao_payload_gin on unidade_agricola.fractal_niveis_autorizacao using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_tarefas_projetos_cowork (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_tarefas_projetos_cowork is 'Integracao tarefas projetos cowork - Conecta responsaveis com tarefas, projetos, workspace, cowork, alertas e permissoes.';
comment on column unidade_agricola.fractal_integracao_tarefas_projetos_cowork.payload is 'Payload flexivel do fractal 06_fractal_integracao_tarefas_projetos_cowork. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_tarefas_projetos_cowork_unidade on unidade_agricola.fractal_integracao_tarefas_projetos_cowork(id_unidade_agricola);
create index if not exists idx_fractal_integracao_tarefas_projetos_cowork_status on unidade_agricola.fractal_integracao_tarefas_projetos_cowork(status);
create index if not exists idx_fractal_integracao_tarefas_projetos_cowork_sync_status on unidade_agricola.fractal_integracao_tarefas_projetos_cowork(sync_status);
create index if not exists idx_fractal_integracao_tarefas_projetos_cowork_payload_gin on unidade_agricola.fractal_integracao_tarefas_projetos_cowork using gin(payload);

create table if not exists unidade_agricola.fractal_areas_produtivas (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_areas_produtivas is 'Areas produtivas - Registra areas produtivas vinculadas a unidade agricola e sua situacao de uso.';
comment on column unidade_agricola.fractal_areas_produtivas.payload is 'Payload flexivel do fractal 01_fractal_areas_produtivas. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_areas_produtivas_unidade on unidade_agricola.fractal_areas_produtivas(id_unidade_agricola);
create index if not exists idx_fractal_areas_produtivas_status on unidade_agricola.fractal_areas_produtivas(status);
create index if not exists idx_fractal_areas_produtivas_sync_status on unidade_agricola.fractal_areas_produtivas(sync_status);
create index if not exists idx_fractal_areas_produtivas_payload_gin on unidade_agricola.fractal_areas_produtivas using gin(payload);

create table if not exists unidade_agricola.fractal_glebas_talhoes (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_glebas_talhoes is 'Glebas e talhoes - Organiza glebas, talhoes, codigos, dimensoes e relacionamentos territoriais.';
comment on column unidade_agricola.fractal_glebas_talhoes.payload is 'Payload flexivel do fractal 02_fractal_glebas_talhoes. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_glebas_talhoes_unidade on unidade_agricola.fractal_glebas_talhoes(id_unidade_agricola);
create index if not exists idx_fractal_glebas_talhoes_status on unidade_agricola.fractal_glebas_talhoes(status);
create index if not exists idx_fractal_glebas_talhoes_sync_status on unidade_agricola.fractal_glebas_talhoes(sync_status);
create index if not exists idx_fractal_glebas_talhoes_payload_gin on unidade_agricola.fractal_glebas_talhoes using gin(payload);

create table if not exists unidade_agricola.fractal_uso_atual_area (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_uso_atual_area is 'Uso atual da area - Registra uso atual, cultura, atividade, ocupacao, restricoes e disponibilidade.';
comment on column unidade_agricola.fractal_uso_atual_area.payload is 'Payload flexivel do fractal 03_fractal_uso_atual_area. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_uso_atual_area_unidade on unidade_agricola.fractal_uso_atual_area(id_unidade_agricola);
create index if not exists idx_fractal_uso_atual_area_status on unidade_agricola.fractal_uso_atual_area(status);
create index if not exists idx_fractal_uso_atual_area_sync_status on unidade_agricola.fractal_uso_atual_area(sync_status);
create index if not exists idx_fractal_uso_atual_area_payload_gin on unidade_agricola.fractal_uso_atual_area using gin(payload);

create table if not exists unidade_agricola.fractal_potencial_produtivo (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_potencial_produtivo is 'Potencial produtivo - Avalia aptidao, capacidade produtiva, limitacoes e oportunidades de uso.';
comment on column unidade_agricola.fractal_potencial_produtivo.payload is 'Payload flexivel do fractal 04_fractal_potencial_produtivo. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_potencial_produtivo_unidade on unidade_agricola.fractal_potencial_produtivo(id_unidade_agricola);
create index if not exists idx_fractal_potencial_produtivo_status on unidade_agricola.fractal_potencial_produtivo(status);
create index if not exists idx_fractal_potencial_produtivo_sync_status on unidade_agricola.fractal_potencial_produtivo(sync_status);
create index if not exists idx_fractal_potencial_produtivo_payload_gin on unidade_agricola.fractal_potencial_produtivo using gin(payload);

create table if not exists unidade_agricola.fractal_historico_ocupacao_uso (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_historico_ocupacao_uso is 'Historico de ocupacao e uso - Mantem historico de culturas, atividades, rotacoes, pausas e alteracoes de uso.';
comment on column unidade_agricola.fractal_historico_ocupacao_uso.payload is 'Payload flexivel do fractal 05_fractal_historico_ocupacao_uso. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_historico_ocupacao_uso_unidade on unidade_agricola.fractal_historico_ocupacao_uso(id_unidade_agricola);
create index if not exists idx_fractal_historico_ocupacao_uso_status on unidade_agricola.fractal_historico_ocupacao_uso(status);
create index if not exists idx_fractal_historico_ocupacao_uso_sync_status on unidade_agricola.fractal_historico_ocupacao_uso(sync_status);
create index if not exists idx_fractal_historico_ocupacao_uso_payload_gin on unidade_agricola.fractal_historico_ocupacao_uso using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_producao_geo_precisao (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_producao_geo_precisao is 'Integracao producao geo precisao - Integra areas com producao vegetal, animal, georreferenciamento e agricultura de precisao.';
comment on column unidade_agricola.fractal_integracao_producao_geo_precisao.payload is 'Payload flexivel do fractal 06_fractal_integracao_producao_geo_precisao. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_producao_geo_precisao_unidade on unidade_agricola.fractal_integracao_producao_geo_precisao(id_unidade_agricola);
create index if not exists idx_fractal_integracao_producao_geo_precisao_status on unidade_agricola.fractal_integracao_producao_geo_precisao(status);
create index if not exists idx_fractal_integracao_producao_geo_precisao_sync_status on unidade_agricola.fractal_integracao_producao_geo_precisao(sync_status);
create index if not exists idx_fractal_integracao_producao_geo_precisao_payload_gin on unidade_agricola.fractal_integracao_producao_geo_precisao using gin(payload);

create table if not exists unidade_agricola.fractal_limites_fisicos_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_limites_fisicos_unidade is 'Limites fisicos da unidade - Registra limites, confrontacoes, cercas, marcos, pontos e referencias fisicas.';
comment on column unidade_agricola.fractal_limites_fisicos_unidade.payload is 'Payload flexivel do fractal 01_fractal_limites_fisicos_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_limites_fisicos_unidade_unidade on unidade_agricola.fractal_limites_fisicos_unidade(id_unidade_agricola);
create index if not exists idx_fractal_limites_fisicos_unidade_status on unidade_agricola.fractal_limites_fisicos_unidade(status);
create index if not exists idx_fractal_limites_fisicos_unidade_sync_status on unidade_agricola.fractal_limites_fisicos_unidade(sync_status);
create index if not exists idx_fractal_limites_fisicos_unidade_payload_gin on unidade_agricola.fractal_limites_fisicos_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_acessos_internos_externos (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_acessos_internos_externos is 'Acessos internos e externos - Mapeia entradas, saidas, acessos internos, acessos externos e condicoes de trafego.';
comment on column unidade_agricola.fractal_acessos_internos_externos.payload is 'Payload flexivel do fractal 02_fractal_acessos_internos_externos. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_acessos_internos_externos_unidade on unidade_agricola.fractal_acessos_internos_externos(id_unidade_agricola);
create index if not exists idx_fractal_acessos_internos_externos_status on unidade_agricola.fractal_acessos_internos_externos(status);
create index if not exists idx_fractal_acessos_internos_externos_sync_status on unidade_agricola.fractal_acessos_internos_externos(sync_status);
create index if not exists idx_fractal_acessos_internos_externos_payload_gin on unidade_agricola.fractal_acessos_internos_externos using gin(payload);

create table if not exists unidade_agricola.fractal_estradas_ramais_porteiras (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_estradas_ramais_porteiras is 'Estradas ramais porteiras - Registra estradas, ramais, porteiras, pontes, passagens e pontos de controle.';
comment on column unidade_agricola.fractal_estradas_ramais_porteiras.payload is 'Payload flexivel do fractal 03_fractal_estradas_ramais_porteiras. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_estradas_ramais_porteiras_unidade on unidade_agricola.fractal_estradas_ramais_porteiras(id_unidade_agricola);
create index if not exists idx_fractal_estradas_ramais_porteiras_status on unidade_agricola.fractal_estradas_ramais_porteiras(status);
create index if not exists idx_fractal_estradas_ramais_porteiras_sync_status on unidade_agricola.fractal_estradas_ramais_porteiras(sync_status);
create index if not exists idx_fractal_estradas_ramais_porteiras_payload_gin on unidade_agricola.fractal_estradas_ramais_porteiras using gin(payload);

create table if not exists unidade_agricola.fractal_pontos_criticos_acesso (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_pontos_criticos_acesso is 'Pontos criticos de acesso - Identifica riscos, gargalos, bloqueios, manutencoes e vulnerabilidades de acesso.';
comment on column unidade_agricola.fractal_pontos_criticos_acesso.payload is 'Payload flexivel do fractal 04_fractal_pontos_criticos_acesso. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_pontos_criticos_acesso_unidade on unidade_agricola.fractal_pontos_criticos_acesso(id_unidade_agricola);
create index if not exists idx_fractal_pontos_criticos_acesso_status on unidade_agricola.fractal_pontos_criticos_acesso(status);
create index if not exists idx_fractal_pontos_criticos_acesso_sync_status on unidade_agricola.fractal_pontos_criticos_acesso(sync_status);
create index if not exists idx_fractal_pontos_criticos_acesso_payload_gin on unidade_agricola.fractal_pontos_criticos_acesso using gin(payload);

create table if not exists unidade_agricola.fractal_controle_circulacao (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_controle_circulacao is 'Controle de circulacao - Controla circulacao de pessoas, veiculos, maquinas, cargas e visitantes.';
comment on column unidade_agricola.fractal_controle_circulacao.payload is 'Payload flexivel do fractal 05_fractal_controle_circulacao. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_controle_circulacao_unidade on unidade_agricola.fractal_controle_circulacao(id_unidade_agricola);
create index if not exists idx_fractal_controle_circulacao_status on unidade_agricola.fractal_controle_circulacao(status);
create index if not exists idx_fractal_controle_circulacao_sync_status on unidade_agricola.fractal_controle_circulacao(sync_status);
create index if not exists idx_fractal_controle_circulacao_payload_gin on unidade_agricola.fractal_controle_circulacao using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_seguranca_logistica_manutencao (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_seguranca_logistica_manutencao is 'Integracao seguranca logistica manutencao - Integra acessos com seguranca, logistica, mapas, manutencao e monitoramento.';
comment on column unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.payload is 'Payload flexivel do fractal 06_fractal_integracao_seguranca_logistica_manutencao. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_seguranca_logistica_manutencao_unidade on unidade_agricola.fractal_integracao_seguranca_logistica_manutencao(id_unidade_agricola);
create index if not exists idx_fractal_integracao_seguranca_logistica_manutencao_status on unidade_agricola.fractal_integracao_seguranca_logistica_manutencao(status);
create index if not exists idx_fractal_integracao_seguranca_logistica_manutencao_sync_status on unidade_agricola.fractal_integracao_seguranca_logistica_manutencao(sync_status);
create index if not exists idx_fractal_integracao_seguranca_logistica_manutencao_payload_gin on unidade_agricola.fractal_integracao_seguranca_logistica_manutencao using gin(payload);

create table if not exists unidade_agricola.fractal_documentos_fundiarios (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_documentos_fundiarios is 'Documentos fundiarios - Organiza matriculas, posses, contratos, CCIR e demais registros fundiarios.';
comment on column unidade_agricola.fractal_documentos_fundiarios.payload is 'Payload flexivel do fractal 01_fractal_documentos_fundiarios. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_documentos_fundiarios_unidade on unidade_agricola.fractal_documentos_fundiarios(id_unidade_agricola);
create index if not exists idx_fractal_documentos_fundiarios_status on unidade_agricola.fractal_documentos_fundiarios(status);
create index if not exists idx_fractal_documentos_fundiarios_sync_status on unidade_agricola.fractal_documentos_fundiarios(sync_status);
create index if not exists idx_fractal_documentos_fundiarios_payload_gin on unidade_agricola.fractal_documentos_fundiarios using gin(payload);

create table if not exists unidade_agricola.fractal_documentos_ambientais (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_documentos_ambientais is 'Documentos ambientais - Organiza CAR, licencas, autorizacoes, reservas, APPs e documentos ambientais.';
comment on column unidade_agricola.fractal_documentos_ambientais.payload is 'Payload flexivel do fractal 02_fractal_documentos_ambientais. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_documentos_ambientais_unidade on unidade_agricola.fractal_documentos_ambientais(id_unidade_agricola);
create index if not exists idx_fractal_documentos_ambientais_status on unidade_agricola.fractal_documentos_ambientais(status);
create index if not exists idx_fractal_documentos_ambientais_sync_status on unidade_agricola.fractal_documentos_ambientais(sync_status);
create index if not exists idx_fractal_documentos_ambientais_payload_gin on unidade_agricola.fractal_documentos_ambientais using gin(payload);

create table if not exists unidade_agricola.fractal_documentos_fiscais_cadastrais (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_documentos_fiscais_cadastrais is 'Documentos fiscais e cadastrais - Organiza ITR, inscricoes, certidoes fiscais, cadastros oficiais e comprovantes.';
comment on column unidade_agricola.fractal_documentos_fiscais_cadastrais.payload is 'Payload flexivel do fractal 03_fractal_documentos_fiscais_cadastrais. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_documentos_fiscais_cadastrais_unidade on unidade_agricola.fractal_documentos_fiscais_cadastrais(id_unidade_agricola);
create index if not exists idx_fractal_documentos_fiscais_cadastrais_status on unidade_agricola.fractal_documentos_fiscais_cadastrais(status);
create index if not exists idx_fractal_documentos_fiscais_cadastrais_sync_status on unidade_agricola.fractal_documentos_fiscais_cadastrais(sync_status);
create index if not exists idx_fractal_documentos_fiscais_cadastrais_payload_gin on unidade_agricola.fractal_documentos_fiscais_cadastrais using gin(payload);

create table if not exists unidade_agricola.fractal_validades_vencimentos (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_validades_vencimentos is 'Validades e vencimentos - Controla prazos, vencimentos, alertas, renovacoes e situacao documental.';
comment on column unidade_agricola.fractal_validades_vencimentos.payload is 'Payload flexivel do fractal 04_fractal_validades_vencimentos. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_validades_vencimentos_unidade on unidade_agricola.fractal_validades_vencimentos(id_unidade_agricola);
create index if not exists idx_fractal_validades_vencimentos_status on unidade_agricola.fractal_validades_vencimentos(status);
create index if not exists idx_fractal_validades_vencimentos_sync_status on unidade_agricola.fractal_validades_vencimentos(sync_status);
create index if not exists idx_fractal_validades_vencimentos_payload_gin on unidade_agricola.fractal_validades_vencimentos using gin(payload);

create table if not exists unidade_agricola.fractal_uploads_evidencias (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_uploads_evidencias is 'Uploads e evidencias - Gerencia arquivos, anexos, evidencias, URLs, metadados e storage.';
comment on column unidade_agricola.fractal_uploads_evidencias.payload is 'Payload flexivel do fractal 05_fractal_uploads_evidencias. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_uploads_evidencias_unidade on unidade_agricola.fractal_uploads_evidencias(id_unidade_agricola);
create index if not exists idx_fractal_uploads_evidencias_status on unidade_agricola.fractal_uploads_evidencias(status);
create index if not exists idx_fractal_uploads_evidencias_sync_status on unidade_agricola.fractal_uploads_evidencias(sync_status);
create index if not exists idx_fractal_uploads_evidencias_payload_gin on unidade_agricola.fractal_uploads_evidencias using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_regularizacao_fiscal_storage (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_regularizacao_fiscal_storage is 'Integracao regularizacao fiscal storage - Integra documentos com regularizacao fundiaria, ambiental, fiscal, Supabase e storage.';
comment on column unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.payload is 'Payload flexivel do fractal 06_fractal_integracao_regularizacao_fiscal_storage. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_regularizacao_fiscal_storage_unidade on unidade_agricola.fractal_integracao_regularizacao_fiscal_storage(id_unidade_agricola);
create index if not exists idx_fractal_integracao_regularizacao_fiscal_storage_status on unidade_agricola.fractal_integracao_regularizacao_fiscal_storage(status);
create index if not exists idx_fractal_integracao_regularizacao_fiscal_storage_sync_status on unidade_agricola.fractal_integracao_regularizacao_fiscal_storage(sync_status);
create index if not exists idx_fractal_integracao_regularizacao_fiscal_storage_payload_gin on unidade_agricola.fractal_integracao_regularizacao_fiscal_storage using gin(payload);

create table if not exists unidade_agricola.fractal_estruturas_existentes (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_estruturas_existentes is 'Estruturas existentes - Registra estruturas, edificacoes, instalacoes e bases fisicas existentes na unidade.';
comment on column unidade_agricola.fractal_estruturas_existentes.payload is 'Payload flexivel do fractal 01_fractal_estruturas_existentes. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_estruturas_existentes_unidade on unidade_agricola.fractal_estruturas_existentes(id_unidade_agricola);
create index if not exists idx_fractal_estruturas_existentes_status on unidade_agricola.fractal_estruturas_existentes(status);
create index if not exists idx_fractal_estruturas_existentes_sync_status on unidade_agricola.fractal_estruturas_existentes(sync_status);
create index if not exists idx_fractal_estruturas_existentes_payload_gin on unidade_agricola.fractal_estruturas_existentes using gin(payload);

create table if not exists unidade_agricola.fractal_benfeitorias_instalacoes_fixas (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_benfeitorias_instalacoes_fixas is 'Benfeitorias e instalacoes fixas - Organiza benfeitorias, cercas, currais, galpoes, reservatorios e instalacoes fixas.';
comment on column unidade_agricola.fractal_benfeitorias_instalacoes_fixas.payload is 'Payload flexivel do fractal 02_fractal_benfeitorias_instalacoes_fixas. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_benfeitorias_instalacoes_fixas_unidade on unidade_agricola.fractal_benfeitorias_instalacoes_fixas(id_unidade_agricola);
create index if not exists idx_fractal_benfeitorias_instalacoes_fixas_status on unidade_agricola.fractal_benfeitorias_instalacoes_fixas(status);
create index if not exists idx_fractal_benfeitorias_instalacoes_fixas_sync_status on unidade_agricola.fractal_benfeitorias_instalacoes_fixas(sync_status);
create index if not exists idx_fractal_benfeitorias_instalacoes_fixas_payload_gin on unidade_agricola.fractal_benfeitorias_instalacoes_fixas using gin(payload);

create table if not exists unidade_agricola.fractal_equipamentos_fixos_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_equipamentos_fixos_unidade is 'Equipamentos fixos da unidade - Registra equipamentos instalados de forma fixa ou estrutural na unidade agricola.';
comment on column unidade_agricola.fractal_equipamentos_fixos_unidade.payload is 'Payload flexivel do fractal 03_fractal_equipamentos_fixos_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_equipamentos_fixos_unidade_unidade on unidade_agricola.fractal_equipamentos_fixos_unidade(id_unidade_agricola);
create index if not exists idx_fractal_equipamentos_fixos_unidade_status on unidade_agricola.fractal_equipamentos_fixos_unidade(status);
create index if not exists idx_fractal_equipamentos_fixos_unidade_sync_status on unidade_agricola.fractal_equipamentos_fixos_unidade(sync_status);
create index if not exists idx_fractal_equipamentos_fixos_unidade_payload_gin on unidade_agricola.fractal_equipamentos_fixos_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_estado_conservacao (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_estado_conservacao is 'Estado de conservacao - Avalia conservacao, risco, manutencao necessaria e prioridade de intervencao.';
comment on column unidade_agricola.fractal_estado_conservacao.payload is 'Payload flexivel do fractal 04_fractal_estado_conservacao. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_estado_conservacao_unidade on unidade_agricola.fractal_estado_conservacao(id_unidade_agricola);
create index if not exists idx_fractal_estado_conservacao_status on unidade_agricola.fractal_estado_conservacao(status);
create index if not exists idx_fractal_estado_conservacao_sync_status on unidade_agricola.fractal_estado_conservacao(sync_status);
create index if not exists idx_fractal_estado_conservacao_payload_gin on unidade_agricola.fractal_estado_conservacao using gin(payload);

create table if not exists unidade_agricola.fractal_relacao_areas_uso_operacional (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_relacao_areas_uso_operacional is 'Relacao com areas e uso operacional - Relaciona ativos estruturais com areas, talhoes, operacoes e uso produtivo.';
comment on column unidade_agricola.fractal_relacao_areas_uso_operacional.payload is 'Payload flexivel do fractal 05_fractal_relacao_areas_uso_operacional. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_relacao_areas_uso_operacional_unidade on unidade_agricola.fractal_relacao_areas_uso_operacional(id_unidade_agricola);
create index if not exists idx_fractal_relacao_areas_uso_operacional_status on unidade_agricola.fractal_relacao_areas_uso_operacional(status);
create index if not exists idx_fractal_relacao_areas_uso_operacional_sync_status on unidade_agricola.fractal_relacao_areas_uso_operacional(sync_status);
create index if not exists idx_fractal_relacao_areas_uso_operacional_payload_gin on unidade_agricola.fractal_relacao_areas_uso_operacional using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_construcoes_manutencao (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_construcoes_manutencao is 'Integracao construcoes manutencao - Serve de base para Construcoes Rurais e integra com Manutencao, ativos e dashboards.';
comment on column unidade_agricola.fractal_integracao_construcoes_manutencao.payload is 'Payload flexivel do fractal 06_fractal_integracao_construcoes_manutencao. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_construcoes_manutencao_unidade on unidade_agricola.fractal_integracao_construcoes_manutencao(id_unidade_agricola);
create index if not exists idx_fractal_integracao_construcoes_manutencao_status on unidade_agricola.fractal_integracao_construcoes_manutencao(status);
create index if not exists idx_fractal_integracao_construcoes_manutencao_sync_status on unidade_agricola.fractal_integracao_construcoes_manutencao(sync_status);
create index if not exists idx_fractal_integracao_construcoes_manutencao_payload_gin on unidade_agricola.fractal_integracao_construcoes_manutencao using gin(payload);

create table if not exists unidade_agricola.fractal_chaves_fisicas (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_chaves_fisicas is 'Chaves fisicas - Controla chaves fisicas, copias, responsaveis, locais e historico de entrega.';
comment on column unidade_agricola.fractal_chaves_fisicas.payload is 'Payload flexivel do fractal 01_fractal_chaves_fisicas. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_chaves_fisicas_unidade on unidade_agricola.fractal_chaves_fisicas(id_unidade_agricola);
create index if not exists idx_fractal_chaves_fisicas_status on unidade_agricola.fractal_chaves_fisicas(status);
create index if not exists idx_fractal_chaves_fisicas_sync_status on unidade_agricola.fractal_chaves_fisicas(sync_status);
create index if not exists idx_fractal_chaves_fisicas_payload_gin on unidade_agricola.fractal_chaves_fisicas using gin(payload);

create table if not exists unidade_agricola.fractal_acessos_digitais (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_acessos_digitais is 'Acessos digitais - Controla senhas, acessos, credenciais, sistemas, tokens e autorizacoes digitais.';
comment on column unidade_agricola.fractal_acessos_digitais.payload is 'Payload flexivel do fractal 02_fractal_acessos_digitais. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_acessos_digitais_unidade on unidade_agricola.fractal_acessos_digitais(id_unidade_agricola);
create index if not exists idx_fractal_acessos_digitais_status on unidade_agricola.fractal_acessos_digitais(status);
create index if not exists idx_fractal_acessos_digitais_sync_status on unidade_agricola.fractal_acessos_digitais(sync_status);
create index if not exists idx_fractal_acessos_digitais_payload_gin on unidade_agricola.fractal_acessos_digitais using gin(payload);

create table if not exists unidade_agricola.fractal_perfis_operacionais (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_perfis_operacionais is 'Perfis operacionais - Define perfis de usuario, niveis de acesso e responsabilidades operacionais.';
comment on column unidade_agricola.fractal_perfis_operacionais.payload is 'Payload flexivel do fractal 03_fractal_perfis_operacionais. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_perfis_operacionais_unidade on unidade_agricola.fractal_perfis_operacionais(id_unidade_agricola);
create index if not exists idx_fractal_perfis_operacionais_status on unidade_agricola.fractal_perfis_operacionais(status);
create index if not exists idx_fractal_perfis_operacionais_sync_status on unidade_agricola.fractal_perfis_operacionais(sync_status);
create index if not exists idx_fractal_perfis_operacionais_payload_gin on unidade_agricola.fractal_perfis_operacionais using gin(payload);

create table if not exists unidade_agricola.fractal_autorizacoes_area_funcao (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_autorizacoes_area_funcao is 'Autorizacoes por area ou funcao - Regula acessos conforme area, funcao, modulo, unidade e tipo de operacao.';
comment on column unidade_agricola.fractal_autorizacoes_area_funcao.payload is 'Payload flexivel do fractal 04_fractal_autorizacoes_area_funcao. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_autorizacoes_area_funcao_unidade on unidade_agricola.fractal_autorizacoes_area_funcao(id_unidade_agricola);
create index if not exists idx_fractal_autorizacoes_area_funcao_status on unidade_agricola.fractal_autorizacoes_area_funcao(status);
create index if not exists idx_fractal_autorizacoes_area_funcao_sync_status on unidade_agricola.fractal_autorizacoes_area_funcao(sync_status);
create index if not exists idx_fractal_autorizacoes_area_funcao_payload_gin on unidade_agricola.fractal_autorizacoes_area_funcao using gin(payload);

create table if not exists unidade_agricola.fractal_historico_acesso (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_historico_acesso is 'Historico de acesso - Registra logs, retiradas, devolucoes, acessos concedidos e acessos revogados.';
comment on column unidade_agricola.fractal_historico_acesso.payload is 'Payload flexivel do fractal 05_fractal_historico_acesso. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_historico_acesso_unidade on unidade_agricola.fractal_historico_acesso(id_unidade_agricola);
create index if not exists idx_fractal_historico_acesso_status on unidade_agricola.fractal_historico_acesso(status);
create index if not exists idx_fractal_historico_acesso_sync_status on unidade_agricola.fractal_historico_acesso(sync_status);
create index if not exists idx_fractal_historico_acesso_payload_gin on unidade_agricola.fractal_historico_acesso using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_seguranca_cowork_workspace (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_seguranca_cowork_workspace is 'Integracao seguranca cowork workspace - Integra chaves e permissoes com seguranca da informacao, cowork, workspace e usuarios.';
comment on column unidade_agricola.fractal_integracao_seguranca_cowork_workspace.payload is 'Payload flexivel do fractal 06_fractal_integracao_seguranca_cowork_workspace. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_seguranca_cowork_workspace_unidade on unidade_agricola.fractal_integracao_seguranca_cowork_workspace(id_unidade_agricola);
create index if not exists idx_fractal_integracao_seguranca_cowork_workspace_status on unidade_agricola.fractal_integracao_seguranca_cowork_workspace(status);
create index if not exists idx_fractal_integracao_seguranca_cowork_workspace_sync_status on unidade_agricola.fractal_integracao_seguranca_cowork_workspace(sync_status);
create index if not exists idx_fractal_integracao_seguranca_cowork_workspace_payload_gin on unidade_agricola.fractal_integracao_seguranca_cowork_workspace using gin(payload);

create table if not exists unidade_agricola.fractal_status_geral_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_status_geral_unidade is 'Status geral da unidade - Define status consolidado da unidade agricola e sua prontidao operacional.';
comment on column unidade_agricola.fractal_status_geral_unidade.payload is 'Payload flexivel do fractal 01_fractal_status_geral_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_status_geral_unidade_unidade on unidade_agricola.fractal_status_geral_unidade(id_unidade_agricola);
create index if not exists idx_fractal_status_geral_unidade_status on unidade_agricola.fractal_status_geral_unidade(status);
create index if not exists idx_fractal_status_geral_unidade_sync_status on unidade_agricola.fractal_status_geral_unidade(sync_status);
create index if not exists idx_fractal_status_geral_unidade_payload_gin on unidade_agricola.fractal_status_geral_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_status_produtivo (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_status_produtivo is 'Status produtivo - Controla condicao produtiva, areas ativas, ciclos e disponibilidade de producao.';
comment on column unidade_agricola.fractal_status_produtivo.payload is 'Payload flexivel do fractal 02_fractal_status_produtivo. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_status_produtivo_unidade on unidade_agricola.fractal_status_produtivo(id_unidade_agricola);
create index if not exists idx_fractal_status_produtivo_status on unidade_agricola.fractal_status_produtivo(status);
create index if not exists idx_fractal_status_produtivo_sync_status on unidade_agricola.fractal_status_produtivo(sync_status);
create index if not exists idx_fractal_status_produtivo_payload_gin on unidade_agricola.fractal_status_produtivo using gin(payload);

create table if not exists unidade_agricola.fractal_status_documental (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_status_documental is 'Status documental - Consolida pendencias, validades, riscos e aprovacao documental.';
comment on column unidade_agricola.fractal_status_documental.payload is 'Payload flexivel do fractal 03_fractal_status_documental. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_status_documental_unidade on unidade_agricola.fractal_status_documental(id_unidade_agricola);
create index if not exists idx_fractal_status_documental_status on unidade_agricola.fractal_status_documental(status);
create index if not exists idx_fractal_status_documental_sync_status on unidade_agricola.fractal_status_documental(sync_status);
create index if not exists idx_fractal_status_documental_payload_gin on unidade_agricola.fractal_status_documental using gin(payload);

create table if not exists unidade_agricola.fractal_status_estrutural (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_status_estrutural is 'Status estrutural - Consolida situacao de estruturas, benfeitorias, acessos e ativos fixos.';
comment on column unidade_agricola.fractal_status_estrutural.payload is 'Payload flexivel do fractal 04_fractal_status_estrutural. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_status_estrutural_unidade on unidade_agricola.fractal_status_estrutural(id_unidade_agricola);
create index if not exists idx_fractal_status_estrutural_status on unidade_agricola.fractal_status_estrutural(status);
create index if not exists idx_fractal_status_estrutural_sync_status on unidade_agricola.fractal_status_estrutural(sync_status);
create index if not exists idx_fractal_status_estrutural_payload_gin on unidade_agricola.fractal_status_estrutural using gin(payload);

create table if not exists unidade_agricola.fractal_status_risco_pendencia (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_status_risco_pendencia is 'Status de risco e pendencia - Identifica riscos, bloqueios, inconformidades, alertas e tarefas pendentes.';
comment on column unidade_agricola.fractal_status_risco_pendencia.payload is 'Payload flexivel do fractal 05_fractal_status_risco_pendencia. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_status_risco_pendencia_unidade on unidade_agricola.fractal_status_risco_pendencia(id_unidade_agricola);
create index if not exists idx_fractal_status_risco_pendencia_status on unidade_agricola.fractal_status_risco_pendencia(status);
create index if not exists idx_fractal_status_risco_pendencia_sync_status on unidade_agricola.fractal_status_risco_pendencia(sync_status);
create index if not exists idx_fractal_status_risco_pendencia_payload_gin on unidade_agricola.fractal_status_risco_pendencia using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_dashboards_alertas_planejamento (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_dashboards_alertas_planejamento is 'Integracao dashboards alertas planejamento - Publica status para dashboards, alertas, planejamento, tarefas e agentes.';
comment on column unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.payload is 'Payload flexivel do fractal 06_fractal_integracao_dashboards_alertas_planejamento. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_dashboards_alertas_planejamento_unidade on unidade_agricola.fractal_integracao_dashboards_alertas_planejamento(id_unidade_agricola);
create index if not exists idx_fractal_integracao_dashboards_alertas_planejamento_status on unidade_agricola.fractal_integracao_dashboards_alertas_planejamento(status);
create index if not exists idx_fractal_integracao_dashboards_alertas_planejamento_sync_status on unidade_agricola.fractal_integracao_dashboards_alertas_planejamento(sync_status);
create index if not exists idx_fractal_integracao_dashboards_alertas_planejamento_payload_gin on unidade_agricola.fractal_integracao_dashboards_alertas_planejamento using gin(payload);

create table if not exists unidade_agricola.fractal_resumo_operacional_unidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_resumo_operacional_unidade is 'Resumo operacional da unidade - Gera visao resumida da operacao, status, indicadores e eventos relevantes.';
comment on column unidade_agricola.fractal_resumo_operacional_unidade.payload is 'Payload flexivel do fractal 01_fractal_resumo_operacional_unidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_resumo_operacional_unidade_unidade on unidade_agricola.fractal_resumo_operacional_unidade(id_unidade_agricola);
create index if not exists idx_fractal_resumo_operacional_unidade_status on unidade_agricola.fractal_resumo_operacional_unidade(status);
create index if not exists idx_fractal_resumo_operacional_unidade_sync_status on unidade_agricola.fractal_resumo_operacional_unidade(sync_status);
create index if not exists idx_fractal_resumo_operacional_unidade_payload_gin on unidade_agricola.fractal_resumo_operacional_unidade using gin(payload);

create table if not exists unidade_agricola.fractal_evidencias_suporte (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_evidencias_suporte is 'Evidencias e suporte - Organiza evidencias, comprovantes, fotos, documentos e anexos de suporte.';
comment on column unidade_agricola.fractal_evidencias_suporte.payload is 'Payload flexivel do fractal 02_fractal_evidencias_suporte. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_evidencias_suporte_unidade on unidade_agricola.fractal_evidencias_suporte(id_unidade_agricola);
create index if not exists idx_fractal_evidencias_suporte_status on unidade_agricola.fractal_evidencias_suporte(status);
create index if not exists idx_fractal_evidencias_suporte_sync_status on unidade_agricola.fractal_evidencias_suporte(sync_status);
create index if not exists idx_fractal_evidencias_suporte_payload_gin on unidade_agricola.fractal_evidencias_suporte using gin(payload);

create table if not exists unidade_agricola.fractal_indicadores_conformidade (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_indicadores_conformidade is 'Indicadores de conformidade - Calcula indicadores de conformidade cadastral, documental, estrutural e operacional.';
comment on column unidade_agricola.fractal_indicadores_conformidade.payload is 'Payload flexivel do fractal 03_fractal_indicadores_conformidade. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_indicadores_conformidade_unidade on unidade_agricola.fractal_indicadores_conformidade(id_unidade_agricola);
create index if not exists idx_fractal_indicadores_conformidade_status on unidade_agricola.fractal_indicadores_conformidade(status);
create index if not exists idx_fractal_indicadores_conformidade_sync_status on unidade_agricola.fractal_indicadores_conformidade(sync_status);
create index if not exists idx_fractal_indicadores_conformidade_payload_gin on unidade_agricola.fractal_indicadores_conformidade using gin(payload);

create table if not exists unidade_agricola.fractal_pendencias_abertas (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_pendencias_abertas is 'Pendencias abertas - Lista pendencias, responsaveis, prazos, prioridades e status de resolucao.';
comment on column unidade_agricola.fractal_pendencias_abertas.payload is 'Payload flexivel do fractal 04_fractal_pendencias_abertas. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_pendencias_abertas_unidade on unidade_agricola.fractal_pendencias_abertas(id_unidade_agricola);
create index if not exists idx_fractal_pendencias_abertas_status on unidade_agricola.fractal_pendencias_abertas(status);
create index if not exists idx_fractal_pendencias_abertas_sync_status on unidade_agricola.fractal_pendencias_abertas(sync_status);
create index if not exists idx_fractal_pendencias_abertas_payload_gin on unidade_agricola.fractal_pendencias_abertas using gin(payload);

create table if not exists unidade_agricola.fractal_historico_atualizacoes (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_historico_atualizacoes is 'Historico de atualizacoes - Mantem trilha de alteracoes, revisoes, aprovacoes e auditoria da unidade.';
comment on column unidade_agricola.fractal_historico_atualizacoes.payload is 'Payload flexivel do fractal 05_fractal_historico_atualizacoes. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_historico_atualizacoes_unidade on unidade_agricola.fractal_historico_atualizacoes(id_unidade_agricola);
create index if not exists idx_fractal_historico_atualizacoes_status on unidade_agricola.fractal_historico_atualizacoes(status);
create index if not exists idx_fractal_historico_atualizacoes_sync_status on unidade_agricola.fractal_historico_atualizacoes(sync_status);
create index if not exists idx_fractal_historico_atualizacoes_payload_gin on unidade_agricola.fractal_historico_atualizacoes using gin(payload);

create table if not exists unidade_agricola.fractal_integracao_financeiro_admin_auditoria (
  id_fractal_registro uuid primary key default gen_random_uuid(),
  id_unidade_agricola uuid references unidade_agricola.unidades_agricolas(id_unidade_agricola) on delete cascade,
  id_origem text,
  status text not null default 'pendente' check (status in ('pendente', 'validado', 'sincronizado', 'erro', 'inativo')),
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente' check (sync_status in ('pendente', 'validado', 'importado', 'sincronizado', 'erro')),
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table unidade_agricola.fractal_integracao_financeiro_admin_auditoria is 'Integracao financeiro administrativo auditoria - Integra prestacao de contas com financeiro, administrativo, dashboards, auditoria e DataLake.';
comment on column unidade_agricola.fractal_integracao_financeiro_admin_auditoria.payload is 'Payload flexivel do fractal 06_fractal_integracao_financeiro_admin_auditoria. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_fractal_integracao_financeiro_admin_auditoria_unidade on unidade_agricola.fractal_integracao_financeiro_admin_auditoria(id_unidade_agricola);
create index if not exists idx_fractal_integracao_financeiro_admin_auditoria_status on unidade_agricola.fractal_integracao_financeiro_admin_auditoria(status);
create index if not exists idx_fractal_integracao_financeiro_admin_auditoria_sync_status on unidade_agricola.fractal_integracao_financeiro_admin_auditoria(sync_status);
create index if not exists idx_fractal_integracao_financeiro_admin_auditoria_payload_gin on unidade_agricola.fractal_integracao_financeiro_admin_auditoria using gin(payload);


insert into unidade_agricola.fractal_eventos_catalogo
  (nome_evento, modulo_origem, submodulo_origem, fractal_origem, tabela_origem, acao, ativo)
values
('unidade_agricola.fractal_identidade_unidade.criado', 'Mod_Gestao_Unidade_Agricola', null, '01_fractal_identidade_unidade', 'fractal_identidade_unidade', 'criado', true),
('unidade_agricola.fractal_identidade_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '01_fractal_identidade_unidade', 'fractal_identidade_unidade', 'atualizado', true),
('unidade_agricola.fractal_identidade_unidade.validado', 'Mod_Gestao_Unidade_Agricola', null, '01_fractal_identidade_unidade', 'fractal_identidade_unidade', 'validado', true),
('unidade_agricola.fractal_identidade_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '01_fractal_identidade_unidade', 'fractal_identidade_unidade', 'sincronizado', true),
('unidade_agricola.fractal_relacionamentos_unidade.criado', 'Mod_Gestao_Unidade_Agricola', null, '02_fractal_relacionamentos_unidade', 'fractal_relacionamentos_unidade', 'criado', true),
('unidade_agricola.fractal_relacionamentos_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '02_fractal_relacionamentos_unidade', 'fractal_relacionamentos_unidade', 'atualizado', true),
('unidade_agricola.fractal_relacionamentos_unidade.validado', 'Mod_Gestao_Unidade_Agricola', null, '02_fractal_relacionamentos_unidade', 'fractal_relacionamentos_unidade', 'validado', true),
('unidade_agricola.fractal_relacionamentos_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '02_fractal_relacionamentos_unidade', 'fractal_relacionamentos_unidade', 'sincronizado', true),
('unidade_agricola.fractal_governanca_permissoes.criado', 'Mod_Gestao_Unidade_Agricola', null, '03_fractal_governanca_permissoes', 'fractal_governanca_permissoes', 'criado', true),
('unidade_agricola.fractal_governanca_permissoes.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '03_fractal_governanca_permissoes', 'fractal_governanca_permissoes', 'atualizado', true),
('unidade_agricola.fractal_governanca_permissoes.validado', 'Mod_Gestao_Unidade_Agricola', null, '03_fractal_governanca_permissoes', 'fractal_governanca_permissoes', 'validado', true),
('unidade_agricola.fractal_governanca_permissoes.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '03_fractal_governanca_permissoes', 'fractal_governanca_permissoes', 'sincronizado', true),
('unidade_agricola.fractal_documental_juridico.criado', 'Mod_Gestao_Unidade_Agricola', null, '04_fractal_documental_juridico', 'fractal_documental_juridico', 'criado', true),
('unidade_agricola.fractal_documental_juridico.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '04_fractal_documental_juridico', 'fractal_documental_juridico', 'atualizado', true),
('unidade_agricola.fractal_documental_juridico.validado', 'Mod_Gestao_Unidade_Agricola', null, '04_fractal_documental_juridico', 'fractal_documental_juridico', 'validado', true),
('unidade_agricola.fractal_documental_juridico.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '04_fractal_documental_juridico', 'fractal_documental_juridico', 'sincronizado', true),
('unidade_agricola.fractal_operacional_status.criado', 'Mod_Gestao_Unidade_Agricola', null, '05_fractal_operacional_status', 'fractal_operacional_status', 'criado', true),
('unidade_agricola.fractal_operacional_status.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '05_fractal_operacional_status', 'fractal_operacional_status', 'atualizado', true),
('unidade_agricola.fractal_operacional_status.validado', 'Mod_Gestao_Unidade_Agricola', null, '05_fractal_operacional_status', 'fractal_operacional_status', 'validado', true),
('unidade_agricola.fractal_operacional_status.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '05_fractal_operacional_status', 'fractal_operacional_status', 'sincronizado', true),
('unidade_agricola.fractal_integracao_ecossistema.criado', 'Mod_Gestao_Unidade_Agricola', null, '06_fractal_integracao_ecossistema', 'fractal_integracao_ecossistema', 'criado', true),
('unidade_agricola.fractal_integracao_ecossistema.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '06_fractal_integracao_ecossistema', 'fractal_integracao_ecossistema', 'atualizado', true),
('unidade_agricola.fractal_integracao_ecossistema.validado', 'Mod_Gestao_Unidade_Agricola', null, '06_fractal_integracao_ecossistema', 'fractal_integracao_ecossistema', 'validado', true),
('unidade_agricola.fractal_integracao_ecossistema.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '06_fractal_integracao_ecossistema', 'fractal_integracao_ecossistema', 'sincronizado', true),
('unidade_agricola.fractal_indicadores_dashboards.criado', 'Mod_Gestao_Unidade_Agricola', null, '07_fractal_indicadores_dashboards', 'fractal_indicadores_dashboards', 'criado', true),
('unidade_agricola.fractal_indicadores_dashboards.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '07_fractal_indicadores_dashboards', 'fractal_indicadores_dashboards', 'atualizado', true),
('unidade_agricola.fractal_indicadores_dashboards.validado', 'Mod_Gestao_Unidade_Agricola', null, '07_fractal_indicadores_dashboards', 'fractal_indicadores_dashboards', 'validado', true),
('unidade_agricola.fractal_indicadores_dashboards.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '07_fractal_indicadores_dashboards', 'fractal_indicadores_dashboards', 'sincronizado', true),
('unidade_agricola.fractal_inteligencia_automacoes.criado', 'Mod_Gestao_Unidade_Agricola', null, '08_fractal_inteligencia_automacoes', 'fractal_inteligencia_automacoes', 'criado', true),
('unidade_agricola.fractal_inteligencia_automacoes.atualizado', 'Mod_Gestao_Unidade_Agricola', null, '08_fractal_inteligencia_automacoes', 'fractal_inteligencia_automacoes', 'atualizado', true),
('unidade_agricola.fractal_inteligencia_automacoes.validado', 'Mod_Gestao_Unidade_Agricola', null, '08_fractal_inteligencia_automacoes', 'fractal_inteligencia_automacoes', 'validado', true),
('unidade_agricola.fractal_inteligencia_automacoes.sincronizado', 'Mod_Gestao_Unidade_Agricola', null, '08_fractal_inteligencia_automacoes', 'fractal_inteligencia_automacoes', 'sincronizado', true),
('unidade_agricola.fractal_dados_basicos_unidade.criado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '01_fractal_dados_basicos_unidade', 'fractal_dados_basicos_unidade', 'criado', true),
('unidade_agricola.fractal_dados_basicos_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '01_fractal_dados_basicos_unidade', 'fractal_dados_basicos_unidade', 'atualizado', true),
('unidade_agricola.fractal_dados_basicos_unidade.validado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '01_fractal_dados_basicos_unidade', 'fractal_dados_basicos_unidade', 'validado', true),
('unidade_agricola.fractal_dados_basicos_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '01_fractal_dados_basicos_unidade', 'fractal_dados_basicos_unidade', 'sincronizado', true),
('unidade_agricola.fractal_localizacao_referencia_territorial.criado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '02_fractal_localizacao_referencia_territorial', 'fractal_localizacao_referencia_territorial', 'criado', true),
('unidade_agricola.fractal_localizacao_referencia_territorial.atualizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '02_fractal_localizacao_referencia_territorial', 'fractal_localizacao_referencia_territorial', 'atualizado', true),
('unidade_agricola.fractal_localizacao_referencia_territorial.validado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '02_fractal_localizacao_referencia_territorial', 'fractal_localizacao_referencia_territorial', 'validado', true),
('unidade_agricola.fractal_localizacao_referencia_territorial.sincronizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '02_fractal_localizacao_referencia_territorial', 'fractal_localizacao_referencia_territorial', 'sincronizado', true),
('unidade_agricola.fractal_classificacao_unidade.criado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '03_fractal_classificacao_unidade', 'fractal_classificacao_unidade', 'criado', true),
('unidade_agricola.fractal_classificacao_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '03_fractal_classificacao_unidade', 'fractal_classificacao_unidade', 'atualizado', true),
('unidade_agricola.fractal_classificacao_unidade.validado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '03_fractal_classificacao_unidade', 'fractal_classificacao_unidade', 'validado', true),
('unidade_agricola.fractal_classificacao_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '03_fractal_classificacao_unidade', 'fractal_classificacao_unidade', 'sincronizado', true),
('unidade_agricola.fractal_situacao_cadastral.criado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '04_fractal_situacao_cadastral', 'fractal_situacao_cadastral', 'criado', true),
('unidade_agricola.fractal_situacao_cadastral.atualizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '04_fractal_situacao_cadastral', 'fractal_situacao_cadastral', 'atualizado', true),
('unidade_agricola.fractal_situacao_cadastral.validado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '04_fractal_situacao_cadastral', 'fractal_situacao_cadastral', 'validado', true),
('unidade_agricola.fractal_situacao_cadastral.sincronizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '04_fractal_situacao_cadastral', 'fractal_situacao_cadastral', 'sincronizado', true),
('unidade_agricola.fractal_validacao_campos_obrigatorios.criado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '05_fractal_validacao_campos_obrigatorios', 'fractal_validacao_campos_obrigatorios', 'criado', true),
('unidade_agricola.fractal_validacao_campos_obrigatorios.atualizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '05_fractal_validacao_campos_obrigatorios', 'fractal_validacao_campos_obrigatorios', 'atualizado', true),
('unidade_agricola.fractal_validacao_campos_obrigatorios.validado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '05_fractal_validacao_campos_obrigatorios', 'fractal_validacao_campos_obrigatorios', 'validado', true),
('unidade_agricola.fractal_validacao_campos_obrigatorios.sincronizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '05_fractal_validacao_campos_obrigatorios', 'fractal_validacao_campos_obrigatorios', 'sincronizado', true),
('unidade_agricola.fractal_integracao_datalake_mapas_modulos.criado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '06_fractal_integracao_datalake_mapas_modulos', 'fractal_integracao_datalake_mapas_modulos', 'criado', true),
('unidade_agricola.fractal_integracao_datalake_mapas_modulos.atualizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '06_fractal_integracao_datalake_mapas_modulos', 'fractal_integracao_datalake_mapas_modulos', 'atualizado', true),
('unidade_agricola.fractal_integracao_datalake_mapas_modulos.validado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '06_fractal_integracao_datalake_mapas_modulos', 'fractal_integracao_datalake_mapas_modulos', 'validado', true),
('unidade_agricola.fractal_integracao_datalake_mapas_modulos.sincronizado', 'Mod_Gestao_Unidade_Agricola', '01_sub_cadastro_unidades_agricolas', '06_fractal_integracao_datalake_mapas_modulos', 'fractal_integracao_datalake_mapas_modulos', 'sincronizado', true),
('unidade_agricola.fractal_cadastro_proprietarios.criado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '01_fractal_cadastro_proprietarios', 'fractal_cadastro_proprietarios', 'criado', true),
('unidade_agricola.fractal_cadastro_proprietarios.atualizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '01_fractal_cadastro_proprietarios', 'fractal_cadastro_proprietarios', 'atualizado', true),
('unidade_agricola.fractal_cadastro_proprietarios.validado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '01_fractal_cadastro_proprietarios', 'fractal_cadastro_proprietarios', 'validado', true),
('unidade_agricola.fractal_cadastro_proprietarios.sincronizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '01_fractal_cadastro_proprietarios', 'fractal_cadastro_proprietarios', 'sincronizado', true),
('unidade_agricola.fractal_cadastro_possuidores.criado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '02_fractal_cadastro_possuidores', 'fractal_cadastro_possuidores', 'criado', true),
('unidade_agricola.fractal_cadastro_possuidores.atualizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '02_fractal_cadastro_possuidores', 'fractal_cadastro_possuidores', 'atualizado', true),
('unidade_agricola.fractal_cadastro_possuidores.validado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '02_fractal_cadastro_possuidores', 'fractal_cadastro_possuidores', 'validado', true),
('unidade_agricola.fractal_cadastro_possuidores.sincronizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '02_fractal_cadastro_possuidores', 'fractal_cadastro_possuidores', 'sincronizado', true),
('unidade_agricola.fractal_documentos_titulares.criado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '03_fractal_documentos_titulares', 'fractal_documentos_titulares', 'criado', true),
('unidade_agricola.fractal_documentos_titulares.atualizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '03_fractal_documentos_titulares', 'fractal_documentos_titulares', 'atualizado', true),
('unidade_agricola.fractal_documentos_titulares.validado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '03_fractal_documentos_titulares', 'fractal_documentos_titulares', 'validado', true),
('unidade_agricola.fractal_documentos_titulares.sincronizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '03_fractal_documentos_titulares', 'fractal_documentos_titulares', 'sincronizado', true),
('unidade_agricola.fractal_vinculos_unidade_agricola.criado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '04_fractal_vinculos_unidade_agricola', 'fractal_vinculos_unidade_agricola', 'criado', true),
('unidade_agricola.fractal_vinculos_unidade_agricola.atualizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '04_fractal_vinculos_unidade_agricola', 'fractal_vinculos_unidade_agricola', 'atualizado', true),
('unidade_agricola.fractal_vinculos_unidade_agricola.validado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '04_fractal_vinculos_unidade_agricola', 'fractal_vinculos_unidade_agricola', 'validado', true),
('unidade_agricola.fractal_vinculos_unidade_agricola.sincronizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '04_fractal_vinculos_unidade_agricola', 'fractal_vinculos_unidade_agricola', 'sincronizado', true),
('unidade_agricola.fractal_historico_titularidade.criado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '05_fractal_historico_titularidade', 'fractal_historico_titularidade', 'criado', true),
('unidade_agricola.fractal_historico_titularidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '05_fractal_historico_titularidade', 'fractal_historico_titularidade', 'atualizado', true),
('unidade_agricola.fractal_historico_titularidade.validado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '05_fractal_historico_titularidade', 'fractal_historico_titularidade', 'validado', true),
('unidade_agricola.fractal_historico_titularidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '05_fractal_historico_titularidade', 'fractal_historico_titularidade', 'sincronizado', true),
('unidade_agricola.fractal_integracao_contratos_juridico_permissoes.criado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '06_fractal_integracao_contratos_juridico_permissoes', 'fractal_integracao_contratos_juridico_permissoes', 'criado', true),
('unidade_agricola.fractal_integracao_contratos_juridico_permissoes.atualizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '06_fractal_integracao_contratos_juridico_permissoes', 'fractal_integracao_contratos_juridico_permissoes', 'atualizado', true),
('unidade_agricola.fractal_integracao_contratos_juridico_permissoes.validado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '06_fractal_integracao_contratos_juridico_permissoes', 'fractal_integracao_contratos_juridico_permissoes', 'validado', true),
('unidade_agricola.fractal_integracao_contratos_juridico_permissoes.sincronizado', 'Mod_Gestao_Unidade_Agricola', '02_sub_proprietarios_possuidores', '06_fractal_integracao_contratos_juridico_permissoes', 'fractal_integracao_contratos_juridico_permissoes', 'sincronizado', true),
('unidade_agricola.fractal_cadastro_responsaveis.criado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '01_fractal_cadastro_responsaveis', 'fractal_cadastro_responsaveis', 'criado', true),
('unidade_agricola.fractal_cadastro_responsaveis.atualizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '01_fractal_cadastro_responsaveis', 'fractal_cadastro_responsaveis', 'atualizado', true),
('unidade_agricola.fractal_cadastro_responsaveis.validado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '01_fractal_cadastro_responsaveis', 'fractal_cadastro_responsaveis', 'validado', true),
('unidade_agricola.fractal_cadastro_responsaveis.sincronizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '01_fractal_cadastro_responsaveis', 'fractal_cadastro_responsaveis', 'sincronizado', true),
('unidade_agricola.fractal_funcoes_papeis_operacionais.criado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '02_fractal_funcoes_papeis_operacionais', 'fractal_funcoes_papeis_operacionais', 'criado', true),
('unidade_agricola.fractal_funcoes_papeis_operacionais.atualizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '02_fractal_funcoes_papeis_operacionais', 'fractal_funcoes_papeis_operacionais', 'atualizado', true),
('unidade_agricola.fractal_funcoes_papeis_operacionais.validado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '02_fractal_funcoes_papeis_operacionais', 'fractal_funcoes_papeis_operacionais', 'validado', true),
('unidade_agricola.fractal_funcoes_papeis_operacionais.sincronizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '02_fractal_funcoes_papeis_operacionais', 'fractal_funcoes_papeis_operacionais', 'sincronizado', true),
('unidade_agricola.fractal_responsabilidade_tecnica.criado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '03_fractal_responsabilidade_tecnica', 'fractal_responsabilidade_tecnica', 'criado', true),
('unidade_agricola.fractal_responsabilidade_tecnica.atualizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '03_fractal_responsabilidade_tecnica', 'fractal_responsabilidade_tecnica', 'atualizado', true),
('unidade_agricola.fractal_responsabilidade_tecnica.validado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '03_fractal_responsabilidade_tecnica', 'fractal_responsabilidade_tecnica', 'validado', true),
('unidade_agricola.fractal_responsabilidade_tecnica.sincronizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '03_fractal_responsabilidade_tecnica', 'fractal_responsabilidade_tecnica', 'sincronizado', true),
('unidade_agricola.fractal_responsabilidade_administrativa.criado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '04_fractal_responsabilidade_administrativa', 'fractal_responsabilidade_administrativa', 'criado', true),
('unidade_agricola.fractal_responsabilidade_administrativa.atualizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '04_fractal_responsabilidade_administrativa', 'fractal_responsabilidade_administrativa', 'atualizado', true),
('unidade_agricola.fractal_responsabilidade_administrativa.validado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '04_fractal_responsabilidade_administrativa', 'fractal_responsabilidade_administrativa', 'validado', true),
('unidade_agricola.fractal_responsabilidade_administrativa.sincronizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '04_fractal_responsabilidade_administrativa', 'fractal_responsabilidade_administrativa', 'sincronizado', true),
('unidade_agricola.fractal_niveis_autorizacao.criado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '05_fractal_niveis_autorizacao', 'fractal_niveis_autorizacao', 'criado', true),
('unidade_agricola.fractal_niveis_autorizacao.atualizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '05_fractal_niveis_autorizacao', 'fractal_niveis_autorizacao', 'atualizado', true),
('unidade_agricola.fractal_niveis_autorizacao.validado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '05_fractal_niveis_autorizacao', 'fractal_niveis_autorizacao', 'validado', true),
('unidade_agricola.fractal_niveis_autorizacao.sincronizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '05_fractal_niveis_autorizacao', 'fractal_niveis_autorizacao', 'sincronizado', true),
('unidade_agricola.fractal_integracao_tarefas_projetos_cowork.criado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '06_fractal_integracao_tarefas_projetos_cowork', 'fractal_integracao_tarefas_projetos_cowork', 'criado', true),
('unidade_agricola.fractal_integracao_tarefas_projetos_cowork.atualizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '06_fractal_integracao_tarefas_projetos_cowork', 'fractal_integracao_tarefas_projetos_cowork', 'atualizado', true),
('unidade_agricola.fractal_integracao_tarefas_projetos_cowork.validado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '06_fractal_integracao_tarefas_projetos_cowork', 'fractal_integracao_tarefas_projetos_cowork', 'validado', true),
('unidade_agricola.fractal_integracao_tarefas_projetos_cowork.sincronizado', 'Mod_Gestao_Unidade_Agricola', '03_sub_responsaveis_gestores', '06_fractal_integracao_tarefas_projetos_cowork', 'fractal_integracao_tarefas_projetos_cowork', 'sincronizado', true),
('unidade_agricola.fractal_areas_produtivas.criado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '01_fractal_areas_produtivas', 'fractal_areas_produtivas', 'criado', true),
('unidade_agricola.fractal_areas_produtivas.atualizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '01_fractal_areas_produtivas', 'fractal_areas_produtivas', 'atualizado', true),
('unidade_agricola.fractal_areas_produtivas.validado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '01_fractal_areas_produtivas', 'fractal_areas_produtivas', 'validado', true),
('unidade_agricola.fractal_areas_produtivas.sincronizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '01_fractal_areas_produtivas', 'fractal_areas_produtivas', 'sincronizado', true),
('unidade_agricola.fractal_glebas_talhoes.criado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '02_fractal_glebas_talhoes', 'fractal_glebas_talhoes', 'criado', true),
('unidade_agricola.fractal_glebas_talhoes.atualizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '02_fractal_glebas_talhoes', 'fractal_glebas_talhoes', 'atualizado', true),
('unidade_agricola.fractal_glebas_talhoes.validado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '02_fractal_glebas_talhoes', 'fractal_glebas_talhoes', 'validado', true),
('unidade_agricola.fractal_glebas_talhoes.sincronizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '02_fractal_glebas_talhoes', 'fractal_glebas_talhoes', 'sincronizado', true),
('unidade_agricola.fractal_uso_atual_area.criado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '03_fractal_uso_atual_area', 'fractal_uso_atual_area', 'criado', true),
('unidade_agricola.fractal_uso_atual_area.atualizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '03_fractal_uso_atual_area', 'fractal_uso_atual_area', 'atualizado', true),
('unidade_agricola.fractal_uso_atual_area.validado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '03_fractal_uso_atual_area', 'fractal_uso_atual_area', 'validado', true),
('unidade_agricola.fractal_uso_atual_area.sincronizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '03_fractal_uso_atual_area', 'fractal_uso_atual_area', 'sincronizado', true),
('unidade_agricola.fractal_potencial_produtivo.criado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '04_fractal_potencial_produtivo', 'fractal_potencial_produtivo', 'criado', true),
('unidade_agricola.fractal_potencial_produtivo.atualizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '04_fractal_potencial_produtivo', 'fractal_potencial_produtivo', 'atualizado', true),
('unidade_agricola.fractal_potencial_produtivo.validado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '04_fractal_potencial_produtivo', 'fractal_potencial_produtivo', 'validado', true),
('unidade_agricola.fractal_potencial_produtivo.sincronizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '04_fractal_potencial_produtivo', 'fractal_potencial_produtivo', 'sincronizado', true),
('unidade_agricola.fractal_historico_ocupacao_uso.criado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '05_fractal_historico_ocupacao_uso', 'fractal_historico_ocupacao_uso', 'criado', true),
('unidade_agricola.fractal_historico_ocupacao_uso.atualizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '05_fractal_historico_ocupacao_uso', 'fractal_historico_ocupacao_uso', 'atualizado', true),
('unidade_agricola.fractal_historico_ocupacao_uso.validado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '05_fractal_historico_ocupacao_uso', 'fractal_historico_ocupacao_uso', 'validado', true),
('unidade_agricola.fractal_historico_ocupacao_uso.sincronizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '05_fractal_historico_ocupacao_uso', 'fractal_historico_ocupacao_uso', 'sincronizado', true),
('unidade_agricola.fractal_integracao_producao_geo_precisao.criado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '06_fractal_integracao_producao_geo_precisao', 'fractal_integracao_producao_geo_precisao', 'criado', true),
('unidade_agricola.fractal_integracao_producao_geo_precisao.atualizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '06_fractal_integracao_producao_geo_precisao', 'fractal_integracao_producao_geo_precisao', 'atualizado', true),
('unidade_agricola.fractal_integracao_producao_geo_precisao.validado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '06_fractal_integracao_producao_geo_precisao', 'fractal_integracao_producao_geo_precisao', 'validado', true),
('unidade_agricola.fractal_integracao_producao_geo_precisao.sincronizado', 'Mod_Gestao_Unidade_Agricola', '04_sub_territorios_areas_producao', '06_fractal_integracao_producao_geo_precisao', 'fractal_integracao_producao_geo_precisao', 'sincronizado', true),
('unidade_agricola.fractal_limites_fisicos_unidade.criado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '01_fractal_limites_fisicos_unidade', 'fractal_limites_fisicos_unidade', 'criado', true),
('unidade_agricola.fractal_limites_fisicos_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '01_fractal_limites_fisicos_unidade', 'fractal_limites_fisicos_unidade', 'atualizado', true),
('unidade_agricola.fractal_limites_fisicos_unidade.validado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '01_fractal_limites_fisicos_unidade', 'fractal_limites_fisicos_unidade', 'validado', true),
('unidade_agricola.fractal_limites_fisicos_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '01_fractal_limites_fisicos_unidade', 'fractal_limites_fisicos_unidade', 'sincronizado', true),
('unidade_agricola.fractal_acessos_internos_externos.criado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '02_fractal_acessos_internos_externos', 'fractal_acessos_internos_externos', 'criado', true),
('unidade_agricola.fractal_acessos_internos_externos.atualizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '02_fractal_acessos_internos_externos', 'fractal_acessos_internos_externos', 'atualizado', true),
('unidade_agricola.fractal_acessos_internos_externos.validado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '02_fractal_acessos_internos_externos', 'fractal_acessos_internos_externos', 'validado', true),
('unidade_agricola.fractal_acessos_internos_externos.sincronizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '02_fractal_acessos_internos_externos', 'fractal_acessos_internos_externos', 'sincronizado', true),
('unidade_agricola.fractal_estradas_ramais_porteiras.criado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '03_fractal_estradas_ramais_porteiras', 'fractal_estradas_ramais_porteiras', 'criado', true),
('unidade_agricola.fractal_estradas_ramais_porteiras.atualizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '03_fractal_estradas_ramais_porteiras', 'fractal_estradas_ramais_porteiras', 'atualizado', true),
('unidade_agricola.fractal_estradas_ramais_porteiras.validado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '03_fractal_estradas_ramais_porteiras', 'fractal_estradas_ramais_porteiras', 'validado', true),
('unidade_agricola.fractal_estradas_ramais_porteiras.sincronizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '03_fractal_estradas_ramais_porteiras', 'fractal_estradas_ramais_porteiras', 'sincronizado', true),
('unidade_agricola.fractal_pontos_criticos_acesso.criado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '04_fractal_pontos_criticos_acesso', 'fractal_pontos_criticos_acesso', 'criado', true),
('unidade_agricola.fractal_pontos_criticos_acesso.atualizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '04_fractal_pontos_criticos_acesso', 'fractal_pontos_criticos_acesso', 'atualizado', true),
('unidade_agricola.fractal_pontos_criticos_acesso.validado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '04_fractal_pontos_criticos_acesso', 'fractal_pontos_criticos_acesso', 'validado', true),
('unidade_agricola.fractal_pontos_criticos_acesso.sincronizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '04_fractal_pontos_criticos_acesso', 'fractal_pontos_criticos_acesso', 'sincronizado', true),
('unidade_agricola.fractal_controle_circulacao.criado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '05_fractal_controle_circulacao', 'fractal_controle_circulacao', 'criado', true),
('unidade_agricola.fractal_controle_circulacao.atualizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '05_fractal_controle_circulacao', 'fractal_controle_circulacao', 'atualizado', true),
('unidade_agricola.fractal_controle_circulacao.validado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '05_fractal_controle_circulacao', 'fractal_controle_circulacao', 'validado', true),
('unidade_agricola.fractal_controle_circulacao.sincronizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '05_fractal_controle_circulacao', 'fractal_controle_circulacao', 'sincronizado', true),
('unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.criado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '06_fractal_integracao_seguranca_logistica_manutencao', 'fractal_integracao_seguranca_logistica_manutencao', 'criado', true),
('unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.atualizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '06_fractal_integracao_seguranca_logistica_manutencao', 'fractal_integracao_seguranca_logistica_manutencao', 'atualizado', true),
('unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.validado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '06_fractal_integracao_seguranca_logistica_manutencao', 'fractal_integracao_seguranca_logistica_manutencao', 'validado', true),
('unidade_agricola.fractal_integracao_seguranca_logistica_manutencao.sincronizado', 'Mod_Gestao_Unidade_Agricola', '05_sub_limites_acessos', '06_fractal_integracao_seguranca_logistica_manutencao', 'fractal_integracao_seguranca_logistica_manutencao', 'sincronizado', true),
('unidade_agricola.fractal_documentos_fundiarios.criado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '01_fractal_documentos_fundiarios', 'fractal_documentos_fundiarios', 'criado', true),
('unidade_agricola.fractal_documentos_fundiarios.atualizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '01_fractal_documentos_fundiarios', 'fractal_documentos_fundiarios', 'atualizado', true),
('unidade_agricola.fractal_documentos_fundiarios.validado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '01_fractal_documentos_fundiarios', 'fractal_documentos_fundiarios', 'validado', true),
('unidade_agricola.fractal_documentos_fundiarios.sincronizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '01_fractal_documentos_fundiarios', 'fractal_documentos_fundiarios', 'sincronizado', true),
('unidade_agricola.fractal_documentos_ambientais.criado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '02_fractal_documentos_ambientais', 'fractal_documentos_ambientais', 'criado', true),
('unidade_agricola.fractal_documentos_ambientais.atualizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '02_fractal_documentos_ambientais', 'fractal_documentos_ambientais', 'atualizado', true),
('unidade_agricola.fractal_documentos_ambientais.validado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '02_fractal_documentos_ambientais', 'fractal_documentos_ambientais', 'validado', true),
('unidade_agricola.fractal_documentos_ambientais.sincronizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '02_fractal_documentos_ambientais', 'fractal_documentos_ambientais', 'sincronizado', true),
('unidade_agricola.fractal_documentos_fiscais_cadastrais.criado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '03_fractal_documentos_fiscais_cadastrais', 'fractal_documentos_fiscais_cadastrais', 'criado', true),
('unidade_agricola.fractal_documentos_fiscais_cadastrais.atualizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '03_fractal_documentos_fiscais_cadastrais', 'fractal_documentos_fiscais_cadastrais', 'atualizado', true),
('unidade_agricola.fractal_documentos_fiscais_cadastrais.validado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '03_fractal_documentos_fiscais_cadastrais', 'fractal_documentos_fiscais_cadastrais', 'validado', true),
('unidade_agricola.fractal_documentos_fiscais_cadastrais.sincronizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '03_fractal_documentos_fiscais_cadastrais', 'fractal_documentos_fiscais_cadastrais', 'sincronizado', true),
('unidade_agricola.fractal_validades_vencimentos.criado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '04_fractal_validades_vencimentos', 'fractal_validades_vencimentos', 'criado', true),
('unidade_agricola.fractal_validades_vencimentos.atualizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '04_fractal_validades_vencimentos', 'fractal_validades_vencimentos', 'atualizado', true),
('unidade_agricola.fractal_validades_vencimentos.validado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '04_fractal_validades_vencimentos', 'fractal_validades_vencimentos', 'validado', true),
('unidade_agricola.fractal_validades_vencimentos.sincronizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '04_fractal_validades_vencimentos', 'fractal_validades_vencimentos', 'sincronizado', true),
('unidade_agricola.fractal_uploads_evidencias.criado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '05_fractal_uploads_evidencias', 'fractal_uploads_evidencias', 'criado', true),
('unidade_agricola.fractal_uploads_evidencias.atualizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '05_fractal_uploads_evidencias', 'fractal_uploads_evidencias', 'atualizado', true),
('unidade_agricola.fractal_uploads_evidencias.validado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '05_fractal_uploads_evidencias', 'fractal_uploads_evidencias', 'validado', true),
('unidade_agricola.fractal_uploads_evidencias.sincronizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '05_fractal_uploads_evidencias', 'fractal_uploads_evidencias', 'sincronizado', true),
('unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.criado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '06_fractal_integracao_regularizacao_fiscal_storage', 'fractal_integracao_regularizacao_fiscal_storage', 'criado', true),
('unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.atualizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '06_fractal_integracao_regularizacao_fiscal_storage', 'fractal_integracao_regularizacao_fiscal_storage', 'atualizado', true),
('unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.validado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '06_fractal_integracao_regularizacao_fiscal_storage', 'fractal_integracao_regularizacao_fiscal_storage', 'validado', true),
('unidade_agricola.fractal_integracao_regularizacao_fiscal_storage.sincronizado', 'Mod_Gestao_Unidade_Agricola', '06_sub_documentacao_unidade', '06_fractal_integracao_regularizacao_fiscal_storage', 'fractal_integracao_regularizacao_fiscal_storage', 'sincronizado', true),
('unidade_agricola.fractal_estruturas_existentes.criado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '01_fractal_estruturas_existentes', 'fractal_estruturas_existentes', 'criado', true),
('unidade_agricola.fractal_estruturas_existentes.atualizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '01_fractal_estruturas_existentes', 'fractal_estruturas_existentes', 'atualizado', true),
('unidade_agricola.fractal_estruturas_existentes.validado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '01_fractal_estruturas_existentes', 'fractal_estruturas_existentes', 'validado', true),
('unidade_agricola.fractal_estruturas_existentes.sincronizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '01_fractal_estruturas_existentes', 'fractal_estruturas_existentes', 'sincronizado', true),
('unidade_agricola.fractal_benfeitorias_instalacoes_fixas.criado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '02_fractal_benfeitorias_instalacoes_fixas', 'fractal_benfeitorias_instalacoes_fixas', 'criado', true),
('unidade_agricola.fractal_benfeitorias_instalacoes_fixas.atualizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '02_fractal_benfeitorias_instalacoes_fixas', 'fractal_benfeitorias_instalacoes_fixas', 'atualizado', true),
('unidade_agricola.fractal_benfeitorias_instalacoes_fixas.validado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '02_fractal_benfeitorias_instalacoes_fixas', 'fractal_benfeitorias_instalacoes_fixas', 'validado', true),
('unidade_agricola.fractal_benfeitorias_instalacoes_fixas.sincronizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '02_fractal_benfeitorias_instalacoes_fixas', 'fractal_benfeitorias_instalacoes_fixas', 'sincronizado', true),
('unidade_agricola.fractal_equipamentos_fixos_unidade.criado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '03_fractal_equipamentos_fixos_unidade', 'fractal_equipamentos_fixos_unidade', 'criado', true),
('unidade_agricola.fractal_equipamentos_fixos_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '03_fractal_equipamentos_fixos_unidade', 'fractal_equipamentos_fixos_unidade', 'atualizado', true),
('unidade_agricola.fractal_equipamentos_fixos_unidade.validado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '03_fractal_equipamentos_fixos_unidade', 'fractal_equipamentos_fixos_unidade', 'validado', true),
('unidade_agricola.fractal_equipamentos_fixos_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '03_fractal_equipamentos_fixos_unidade', 'fractal_equipamentos_fixos_unidade', 'sincronizado', true),
('unidade_agricola.fractal_estado_conservacao.criado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '04_fractal_estado_conservacao', 'fractal_estado_conservacao', 'criado', true),
('unidade_agricola.fractal_estado_conservacao.atualizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '04_fractal_estado_conservacao', 'fractal_estado_conservacao', 'atualizado', true),
('unidade_agricola.fractal_estado_conservacao.validado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '04_fractal_estado_conservacao', 'fractal_estado_conservacao', 'validado', true),
('unidade_agricola.fractal_estado_conservacao.sincronizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '04_fractal_estado_conservacao', 'fractal_estado_conservacao', 'sincronizado', true),
('unidade_agricola.fractal_relacao_areas_uso_operacional.criado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '05_fractal_relacao_areas_uso_operacional', 'fractal_relacao_areas_uso_operacional', 'criado', true),
('unidade_agricola.fractal_relacao_areas_uso_operacional.atualizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '05_fractal_relacao_areas_uso_operacional', 'fractal_relacao_areas_uso_operacional', 'atualizado', true),
('unidade_agricola.fractal_relacao_areas_uso_operacional.validado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '05_fractal_relacao_areas_uso_operacional', 'fractal_relacao_areas_uso_operacional', 'validado', true),
('unidade_agricola.fractal_relacao_areas_uso_operacional.sincronizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '05_fractal_relacao_areas_uso_operacional', 'fractal_relacao_areas_uso_operacional', 'sincronizado', true),
('unidade_agricola.fractal_integracao_construcoes_manutencao.criado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '06_fractal_integracao_construcoes_manutencao', 'fractal_integracao_construcoes_manutencao', 'criado', true),
('unidade_agricola.fractal_integracao_construcoes_manutencao.atualizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '06_fractal_integracao_construcoes_manutencao', 'fractal_integracao_construcoes_manutencao', 'atualizado', true),
('unidade_agricola.fractal_integracao_construcoes_manutencao.validado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '06_fractal_integracao_construcoes_manutencao', 'fractal_integracao_construcoes_manutencao', 'validado', true),
('unidade_agricola.fractal_integracao_construcoes_manutencao.sincronizado', 'Mod_Gestao_Unidade_Agricola', '07_sub_base_ativos_estruturais_unidade', '06_fractal_integracao_construcoes_manutencao', 'fractal_integracao_construcoes_manutencao', 'sincronizado', true),
('unidade_agricola.fractal_chaves_fisicas.criado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '01_fractal_chaves_fisicas', 'fractal_chaves_fisicas', 'criado', true),
('unidade_agricola.fractal_chaves_fisicas.atualizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '01_fractal_chaves_fisicas', 'fractal_chaves_fisicas', 'atualizado', true),
('unidade_agricola.fractal_chaves_fisicas.validado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '01_fractal_chaves_fisicas', 'fractal_chaves_fisicas', 'validado', true),
('unidade_agricola.fractal_chaves_fisicas.sincronizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '01_fractal_chaves_fisicas', 'fractal_chaves_fisicas', 'sincronizado', true),
('unidade_agricola.fractal_acessos_digitais.criado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '02_fractal_acessos_digitais', 'fractal_acessos_digitais', 'criado', true),
('unidade_agricola.fractal_acessos_digitais.atualizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '02_fractal_acessos_digitais', 'fractal_acessos_digitais', 'atualizado', true),
('unidade_agricola.fractal_acessos_digitais.validado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '02_fractal_acessos_digitais', 'fractal_acessos_digitais', 'validado', true),
('unidade_agricola.fractal_acessos_digitais.sincronizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '02_fractal_acessos_digitais', 'fractal_acessos_digitais', 'sincronizado', true),
('unidade_agricola.fractal_perfis_operacionais.criado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '03_fractal_perfis_operacionais', 'fractal_perfis_operacionais', 'criado', true),
('unidade_agricola.fractal_perfis_operacionais.atualizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '03_fractal_perfis_operacionais', 'fractal_perfis_operacionais', 'atualizado', true),
('unidade_agricola.fractal_perfis_operacionais.validado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '03_fractal_perfis_operacionais', 'fractal_perfis_operacionais', 'validado', true),
('unidade_agricola.fractal_perfis_operacionais.sincronizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '03_fractal_perfis_operacionais', 'fractal_perfis_operacionais', 'sincronizado', true),
('unidade_agricola.fractal_autorizacoes_area_funcao.criado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '04_fractal_autorizacoes_area_funcao', 'fractal_autorizacoes_area_funcao', 'criado', true),
('unidade_agricola.fractal_autorizacoes_area_funcao.atualizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '04_fractal_autorizacoes_area_funcao', 'fractal_autorizacoes_area_funcao', 'atualizado', true),
('unidade_agricola.fractal_autorizacoes_area_funcao.validado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '04_fractal_autorizacoes_area_funcao', 'fractal_autorizacoes_area_funcao', 'validado', true),
('unidade_agricola.fractal_autorizacoes_area_funcao.sincronizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '04_fractal_autorizacoes_area_funcao', 'fractal_autorizacoes_area_funcao', 'sincronizado', true),
('unidade_agricola.fractal_historico_acesso.criado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '05_fractal_historico_acesso', 'fractal_historico_acesso', 'criado', true),
('unidade_agricola.fractal_historico_acesso.atualizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '05_fractal_historico_acesso', 'fractal_historico_acesso', 'atualizado', true),
('unidade_agricola.fractal_historico_acesso.validado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '05_fractal_historico_acesso', 'fractal_historico_acesso', 'validado', true),
('unidade_agricola.fractal_historico_acesso.sincronizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '05_fractal_historico_acesso', 'fractal_historico_acesso', 'sincronizado', true),
('unidade_agricola.fractal_integracao_seguranca_cowork_workspace.criado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '06_fractal_integracao_seguranca_cowork_workspace', 'fractal_integracao_seguranca_cowork_workspace', 'criado', true),
('unidade_agricola.fractal_integracao_seguranca_cowork_workspace.atualizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '06_fractal_integracao_seguranca_cowork_workspace', 'fractal_integracao_seguranca_cowork_workspace', 'atualizado', true),
('unidade_agricola.fractal_integracao_seguranca_cowork_workspace.validado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '06_fractal_integracao_seguranca_cowork_workspace', 'fractal_integracao_seguranca_cowork_workspace', 'validado', true),
('unidade_agricola.fractal_integracao_seguranca_cowork_workspace.sincronizado', 'Mod_Gestao_Unidade_Agricola', '08_sub_chaves_permissoes_operacionais', '06_fractal_integracao_seguranca_cowork_workspace', 'fractal_integracao_seguranca_cowork_workspace', 'sincronizado', true),
('unidade_agricola.fractal_status_geral_unidade.criado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '01_fractal_status_geral_unidade', 'fractal_status_geral_unidade', 'criado', true),
('unidade_agricola.fractal_status_geral_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '01_fractal_status_geral_unidade', 'fractal_status_geral_unidade', 'atualizado', true),
('unidade_agricola.fractal_status_geral_unidade.validado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '01_fractal_status_geral_unidade', 'fractal_status_geral_unidade', 'validado', true),
('unidade_agricola.fractal_status_geral_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '01_fractal_status_geral_unidade', 'fractal_status_geral_unidade', 'sincronizado', true),
('unidade_agricola.fractal_status_produtivo.criado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '02_fractal_status_produtivo', 'fractal_status_produtivo', 'criado', true),
('unidade_agricola.fractal_status_produtivo.atualizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '02_fractal_status_produtivo', 'fractal_status_produtivo', 'atualizado', true),
('unidade_agricola.fractal_status_produtivo.validado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '02_fractal_status_produtivo', 'fractal_status_produtivo', 'validado', true),
('unidade_agricola.fractal_status_produtivo.sincronizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '02_fractal_status_produtivo', 'fractal_status_produtivo', 'sincronizado', true),
('unidade_agricola.fractal_status_documental.criado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '03_fractal_status_documental', 'fractal_status_documental', 'criado', true),
('unidade_agricola.fractal_status_documental.atualizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '03_fractal_status_documental', 'fractal_status_documental', 'atualizado', true),
('unidade_agricola.fractal_status_documental.validado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '03_fractal_status_documental', 'fractal_status_documental', 'validado', true),
('unidade_agricola.fractal_status_documental.sincronizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '03_fractal_status_documental', 'fractal_status_documental', 'sincronizado', true),
('unidade_agricola.fractal_status_estrutural.criado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '04_fractal_status_estrutural', 'fractal_status_estrutural', 'criado', true),
('unidade_agricola.fractal_status_estrutural.atualizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '04_fractal_status_estrutural', 'fractal_status_estrutural', 'atualizado', true),
('unidade_agricola.fractal_status_estrutural.validado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '04_fractal_status_estrutural', 'fractal_status_estrutural', 'validado', true),
('unidade_agricola.fractal_status_estrutural.sincronizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '04_fractal_status_estrutural', 'fractal_status_estrutural', 'sincronizado', true),
('unidade_agricola.fractal_status_risco_pendencia.criado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '05_fractal_status_risco_pendencia', 'fractal_status_risco_pendencia', 'criado', true),
('unidade_agricola.fractal_status_risco_pendencia.atualizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '05_fractal_status_risco_pendencia', 'fractal_status_risco_pendencia', 'atualizado', true),
('unidade_agricola.fractal_status_risco_pendencia.validado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '05_fractal_status_risco_pendencia', 'fractal_status_risco_pendencia', 'validado', true),
('unidade_agricola.fractal_status_risco_pendencia.sincronizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '05_fractal_status_risco_pendencia', 'fractal_status_risco_pendencia', 'sincronizado', true),
('unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.criado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '06_fractal_integracao_dashboards_alertas_planejamento', 'fractal_integracao_dashboards_alertas_planejamento', 'criado', true),
('unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.atualizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '06_fractal_integracao_dashboards_alertas_planejamento', 'fractal_integracao_dashboards_alertas_planejamento', 'atualizado', true),
('unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.validado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '06_fractal_integracao_dashboards_alertas_planejamento', 'fractal_integracao_dashboards_alertas_planejamento', 'validado', true),
('unidade_agricola.fractal_integracao_dashboards_alertas_planejamento.sincronizado', 'Mod_Gestao_Unidade_Agricola', '09_sub_status_operacional_unidade', '06_fractal_integracao_dashboards_alertas_planejamento', 'fractal_integracao_dashboards_alertas_planejamento', 'sincronizado', true),
('unidade_agricola.fractal_resumo_operacional_unidade.criado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '01_fractal_resumo_operacional_unidade', 'fractal_resumo_operacional_unidade', 'criado', true),
('unidade_agricola.fractal_resumo_operacional_unidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '01_fractal_resumo_operacional_unidade', 'fractal_resumo_operacional_unidade', 'atualizado', true),
('unidade_agricola.fractal_resumo_operacional_unidade.validado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '01_fractal_resumo_operacional_unidade', 'fractal_resumo_operacional_unidade', 'validado', true),
('unidade_agricola.fractal_resumo_operacional_unidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '01_fractal_resumo_operacional_unidade', 'fractal_resumo_operacional_unidade', 'sincronizado', true),
('unidade_agricola.fractal_evidencias_suporte.criado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '02_fractal_evidencias_suporte', 'fractal_evidencias_suporte', 'criado', true),
('unidade_agricola.fractal_evidencias_suporte.atualizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '02_fractal_evidencias_suporte', 'fractal_evidencias_suporte', 'atualizado', true),
('unidade_agricola.fractal_evidencias_suporte.validado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '02_fractal_evidencias_suporte', 'fractal_evidencias_suporte', 'validado', true),
('unidade_agricola.fractal_evidencias_suporte.sincronizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '02_fractal_evidencias_suporte', 'fractal_evidencias_suporte', 'sincronizado', true),
('unidade_agricola.fractal_indicadores_conformidade.criado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '03_fractal_indicadores_conformidade', 'fractal_indicadores_conformidade', 'criado', true),
('unidade_agricola.fractal_indicadores_conformidade.atualizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '03_fractal_indicadores_conformidade', 'fractal_indicadores_conformidade', 'atualizado', true),
('unidade_agricola.fractal_indicadores_conformidade.validado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '03_fractal_indicadores_conformidade', 'fractal_indicadores_conformidade', 'validado', true),
('unidade_agricola.fractal_indicadores_conformidade.sincronizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '03_fractal_indicadores_conformidade', 'fractal_indicadores_conformidade', 'sincronizado', true),
('unidade_agricola.fractal_pendencias_abertas.criado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '04_fractal_pendencias_abertas', 'fractal_pendencias_abertas', 'criado', true),
('unidade_agricola.fractal_pendencias_abertas.atualizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '04_fractal_pendencias_abertas', 'fractal_pendencias_abertas', 'atualizado', true),
('unidade_agricola.fractal_pendencias_abertas.validado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '04_fractal_pendencias_abertas', 'fractal_pendencias_abertas', 'validado', true),
('unidade_agricola.fractal_pendencias_abertas.sincronizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '04_fractal_pendencias_abertas', 'fractal_pendencias_abertas', 'sincronizado', true),
('unidade_agricola.fractal_historico_atualizacoes.criado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '05_fractal_historico_atualizacoes', 'fractal_historico_atualizacoes', 'criado', true),
('unidade_agricola.fractal_historico_atualizacoes.atualizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '05_fractal_historico_atualizacoes', 'fractal_historico_atualizacoes', 'atualizado', true),
('unidade_agricola.fractal_historico_atualizacoes.validado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '05_fractal_historico_atualizacoes', 'fractal_historico_atualizacoes', 'validado', true),
('unidade_agricola.fractal_historico_atualizacoes.sincronizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '05_fractal_historico_atualizacoes', 'fractal_historico_atualizacoes', 'sincronizado', true),
('unidade_agricola.fractal_integracao_financeiro_admin_auditoria.criado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '06_fractal_integracao_financeiro_admin_auditoria', 'fractal_integracao_financeiro_admin_auditoria', 'criado', true),
('unidade_agricola.fractal_integracao_financeiro_admin_auditoria.atualizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '06_fractal_integracao_financeiro_admin_auditoria', 'fractal_integracao_financeiro_admin_auditoria', 'atualizado', true),
('unidade_agricola.fractal_integracao_financeiro_admin_auditoria.validado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '06_fractal_integracao_financeiro_admin_auditoria', 'fractal_integracao_financeiro_admin_auditoria', 'validado', true),
('unidade_agricola.fractal_integracao_financeiro_admin_auditoria.sincronizado', 'Mod_Gestao_Unidade_Agricola', '10_sub_prestacao_contas_unidade', '06_fractal_integracao_financeiro_admin_auditoria', 'fractal_integracao_financeiro_admin_auditoria', 'sincronizado', true)
on conflict (nome_evento) do update set
  modulo_origem = excluded.modulo_origem,
  submodulo_origem = excluded.submodulo_origem,
  fractal_origem = excluded.fractal_origem,
  tabela_origem = excluded.tabela_origem,
  acao = excluded.acao,
  ativo = excluded.ativo;

create or replace function unidade_agricola.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_unidades_agricolas_updated_at on unidade_agricola.unidades_agricolas;
create trigger trg_unidades_agricolas_updated_at
before update on unidade_agricola.unidades_agricolas
for each row execute function unidade_agricola.set_updated_at();

-- Observacao:
-- Os triggers especificos de cada tabela fractal podem ser ativados posteriormente
-- quando a execucao no Supabase for validada no ambiente alvo.
