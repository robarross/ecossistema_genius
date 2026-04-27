import fs from "node:fs/promises";
import path from "node:path";

const modulePath = "E:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/genius_systems_modulares/01_A_Modulos_Administrativo_Corporativo/02_Mod_Gestao_Unidade_Agricola";
const moduleName = "Mod_Gestao_Unidade_Agricola";
const dnaPath = path.join(modulePath, "1_DNA_Processo");

async function exists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function readJson(filePath) {
  return JSON.parse(await fs.readFile(filePath, "utf8"));
}

function sqlIdent(name) {
  return String(name).toLowerCase().replace(/[^a-z0-9_]/g, "_");
}

function eventBase(fractalName) {
  return `unidade_agricola.${fractalName.replace(/^\d+_/, "")}`;
}

function sqlComment(text) {
  return String(text ?? "").replaceAll("'", "''");
}

async function getFractals() {
  const fractals = [];
  const centralPath = path.join(dnaPath, "fractais_modulo");
  for (const entry of await fs.readdir(centralPath, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const fractalPath = path.join(centralPath, entry.name);
    fractals.push({
      nivel: "modulo",
      submodulo: null,
      nome: entry.name,
      manifesto: await readJson(path.join(fractalPath, "manifesto_fractal.json")),
      schema: await readJson(path.join(fractalPath, "schema_dados.json"))
    });
  }

  const submodulesPath = path.join(dnaPath, "submodulos");
  for (const sub of await fs.readdir(submodulesPath, { withFileTypes: true })) {
    if (!sub.isDirectory()) continue;
    const fractalsPath = path.join(submodulesPath, sub.name, "fractais");
    if (!(await exists(fractalsPath))) continue;
    for (const entry of await fs.readdir(fractalsPath, { withFileTypes: true })) {
      if (!entry.isDirectory()) continue;
      const fractalPath = path.join(fractalsPath, entry.name);
      fractals.push({
        nivel: "submodulo",
        submodulo: sub.name,
        nome: entry.name,
        manifesto: await readJson(path.join(fractalPath, "manifesto_fractal.json")),
        schema: await readJson(path.join(fractalPath, "schema_dados.json"))
      });
    }
  }
  return fractals.sort((a, b) => `${a.submodulo ?? "00"}/${a.nome}`.localeCompare(`${b.submodulo ?? "00"}/${b.nome}`));
}

const fractals = await getFractals();

const tableNames = new Set();
const tableRows = [];

for (const fractal of fractals) {
  let tableName = sqlIdent(fractal.schema.tabela_sugerida);
  if (tableNames.has(tableName)) {
    tableName = `${tableName}_${tableNames.size + 1}`;
  }
  tableNames.add(tableName);
  tableRows.push({ ...fractal, tableName });
}

const tableSql = tableRows.map((item) => {
  const title = sqlComment(item.manifesto.titulo);
  const description = sqlComment(item.manifesto.descricao);
  return `create table if not exists unidade_agricola.${item.tableName} (
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

comment on table unidade_agricola.${item.tableName} is '${title} - ${description}';
comment on column unidade_agricola.${item.tableName}.payload is 'Payload flexivel do fractal ${item.nome}. Campos especificos devem ser promovidos para colunas quando estabilizados.';

create index if not exists idx_${item.tableName}_unidade on unidade_agricola.${item.tableName}(id_unidade_agricola);
create index if not exists idx_${item.tableName}_status on unidade_agricola.${item.tableName}(status);
create index if not exists idx_${item.tableName}_sync_status on unidade_agricola.${item.tableName}(sync_status);
create index if not exists idx_${item.tableName}_payload_gin on unidade_agricola.${item.tableName} using gin(payload);
`;
}).join("\n");

const eventValues = tableRows.flatMap((item) => {
  const base = eventBase(item.nome);
  return ["criado", "atualizado", "validado", "sincronizado"].map((action) => {
    const eventName = `${base}.${action}`;
    return `('${eventName}', '${moduleName}', ${item.submodulo ? `'${item.submodulo}'` : "null"}, '${item.nome}', '${item.tableName}', '${action}', true)`;
  });
}).join(",\n");

const sql = `-- SUPABASE_SCHEMA_Mod_Gestao_Unidade_Agricola.sql
-- Modulo: ${moduleName}
-- Gerado a partir de ${fractals.length} fractais plug and play.

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

${tableSql}

insert into unidade_agricola.fractal_eventos_catalogo
  (nome_evento, modulo_origem, submodulo_origem, fractal_origem, tabela_origem, acao, ativo)
values
${eventValues}
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
`;

const rlsRows = tableRows.map((item) => `- \`${item.tableName}\`: acesso por \`id_unidade_agricola\`, perfil do usuario e vinculo com unidade.`).join("\n");

const rlsDoc = `# PERMISSOES_RLS_Mod_Gestao_Unidade_Agricola

Este documento define a diretriz de permissao e Row Level Security para o modulo Gestão da Unidade Agrícola.

## Perfis sugeridos

- \`admin_ecossistema\`: administra todas as unidades e fractais.
- \`gestor_unidade_agricola\`: administra unidades sob sua responsabilidade.
- \`responsavel_tecnico\`: acessa fractais tecnicos, documentais, produtivos e territoriais.
- \`operador_campo\`: cria e atualiza registros operacionais autorizados.
- \`auditor_consulta\`: consulta dados, historicos, evidencias e eventos.
- \`integracao_api\`: usuario tecnico para APIs, Hub, DataLake e automacoes.

## Regra RLS base

Toda tabela deve filtrar por:

- organizacao/tenant, quando este campo for introduzido;
- \`id_unidade_agricola\`;
- papel/perfil do usuario;
- vinculo do usuario com a unidade;
- status do registro quando houver restricao operacional.

## Tabelas/fractais cobertos

${rlsRows}

## Politicas sugeridas

\`\`\`sql
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
\`\`\`

## Observacao

Antes de ativar RLS em producao, criar a tabela de vinculos \`usuario_unidade_vinculos\` e integrar com Genius Hub, Workspace, Cowork e Segurança da Informação.
`;

const flowDoc = `# FLUXO_OPERACIONAL_PLUG_AND_PLAY_Mod_Gestao_Unidade_Agricola

Este fluxo mostra como o modulo deve operar quando instalado como componente plug and play do ecossistema Genius.

## Fluxo principal

1. Cadastro ou atualizacao da unidade agricola.
2. Ativacao dos fractais centrais do modulo.
3. Ativacao dos fractais dos submodulos conforme necessidade da unidade.
4. Validacao de campos obrigatorios, documentos, vinculos, areas e permissoes.
5. Gravacao em Supabase ou base operacional equivalente.
6. Publicacao de eventos no Genius Hub.
7. Indexacao no DataLake.
8. Atualizacao dos dashboards do modulo e dashboards executivos.
9. Exposicao controlada por APIs.
10. Consumo por agentes, automacoes, modulos produtivos, territoriais, financeiros, fiscais e marketplace.

## Sequencia tecnica

\`\`\`text
Planilha/Formulario/API
  -> Supabase unidade_agricola.unidades_agricolas
  -> Tabelas dos fractais
  -> fractal_eventos_log
  -> Genius Hub
  -> DataLake
  -> Dashboards BI
  -> APIs/Agentes/Outros Modulos
\`\`\`

## Regra de instalacao

O modulo pode ser instalado com todos os fractais ou em modo gradual:

- nucleo minimo: unidade, identidade, permissoes, status e integracao;
- pacote territorial: areas, limites, acessos e mapas;
- pacote documental: titulares, documentos, vencimentos e evidencias;
- pacote operacional: ativos, status, prestacao de contas e dashboards.

## Dependencias fortes

- Mod_Gestao_Genius_Hub
- Mod_Gestao_Dados_DataLake
- Mod_Gestao_Integracoes_APIs
- Mod_Gestao_Dashboards_BI
- Mod_Gestao_Seguranca_Informacao

## Modulos que devem consumir esta base

- Gestão Produção Vegetal
- Gestão Produção Animal/Pecuária
- Georreferenciamento
- Regularização Fundiária
- Construções Rurais
- Manutenção
- Financeiro
- Fiscal/Tributário
- Marketplace Agrícola
`;

const packageDoc = `# PACOTE_TECNICO_SUPABASE_Mod_Gestao_Unidade_Agricola

Este pacote transforma os fractais do modulo em uma base tecnica inicial para Supabase, APIs, DataLake, Hub e dashboards.

## Arquivos gerados

- \`SUPABASE_SCHEMA_Mod_Gestao_Unidade_Agricola.sql\`
- \`PERMISSOES_RLS_Mod_Gestao_Unidade_Agricola.md\`
- \`FLUXO_OPERACIONAL_PLUG_AND_PLAY_Mod_Gestao_Unidade_Agricola.md\`

## Conteudo consolidado

- Fractais processados: ${fractals.length}
- Tabelas de fractais sugeridas: ${tableRows.length}
- Eventos catalogados: ${tableRows.length * 4}
- Schema principal: \`unidade_agricola\`
- Tabela raiz: \`unidade_agricola.unidades_agricolas\`
- Catalogo de eventos: \`unidade_agricola.fractal_eventos_catalogo\`
- Log de eventos: \`unidade_agricola.fractal_eventos_log\`

## Como usar

1. Revisar o SQL em ambiente de desenvolvimento.
2. Executar no Supabase SQL Editor.
3. Validar tabelas, indices e catalogo de eventos.
4. Criar politicas RLS conforme perfis reais.
5. Conectar planilhas, formularios, APIs e agentes.
6. Publicar eventos no Genius Hub e DataLake.
`;

const outputs = [
  ["SUPABASE_SCHEMA_Mod_Gestao_Unidade_Agricola.sql", sql],
  ["PERMISSOES_RLS_Mod_Gestao_Unidade_Agricola.md", rlsDoc],
  ["FLUXO_OPERACIONAL_PLUG_AND_PLAY_Mod_Gestao_Unidade_Agricola.md", flowDoc],
  ["PACOTE_TECNICO_SUPABASE_Mod_Gestao_Unidade_Agricola.md", packageDoc]
];

for (const [file, content] of outputs) {
  await fs.writeFile(path.join(modulePath, file), content, "utf8");
}

for (const [file] of outputs) {
  await fs.access(path.join(modulePath, file));
}

console.log(`FRACTAIS=${fractals.length}`);
console.log(`TABELAS_FRACTAIS=${tableRows.length}`);
console.log(`EVENTOS=${tableRows.length * 4}`);
console.log(`ARQUIVOS=${outputs.length}`);
console.log("STATUS=OK");
