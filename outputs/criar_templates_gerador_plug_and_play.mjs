import fs from "node:fs/promises";
import path from "node:path";

const root = "E:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais";
const templatesRoot = path.join(root, "_templates_genius");
const moduleTemplate = path.join(templatesRoot, "TEMPLATE_MODULO_PLUG_AND_PLAY");
const fractalTemplate = path.join(templatesRoot, "TEMPLATE_FRACTAL_PLUG_AND_PLAY");
const generatorDir = path.join(templatesRoot, "GERADOR_MODULO_PLUG_AND_PLAY");

async function write(filePath, content) {
  await fs.mkdir(path.dirname(filePath), { recursive: true });
  await fs.writeFile(filePath, content, "utf8");
}

async function mkdir(dirPath) {
  await fs.mkdir(dirPath, { recursive: true });
}

const fractalFiles = {
  "README.md": `# {{NOME_FRACTAL}}

## Nome
{{TITULO_FRACTAL}}

## Função
{{DESCRICAO_FRACTAL}}

## Escopo
{{ESCOPO_FRACTAL}}

## Plug and play
Este fractal possui manifesto, contrato, schema de dados e eventos próprios para funcionar de forma independente, complementar e integrada.
`,
  "manifesto_fractal.json": `{
  "nome_fractal": "{{NOME_FRACTAL}}",
  "titulo": "{{TITULO_FRACTAL}}",
  "descricao": "{{DESCRICAO_FRACTAL}}",
  "status": "proposto",
  "versao": "0.1.0",
  "escopo": "{{ESCOPO_FRACTAL}}",
  "modulo_pai": "{{NOME_MODULO}}",
  "submodulo_pai": "{{NOME_SUBMODULO}}",
  "plug_and_play": true,
  "entradas_esperadas": ["dados_origem", "id_entidade_base", "id_usuario_responsavel", "contexto_operacional"],
  "saidas_geradas": ["registro_validado", "evento_publicado", "indicador_atualizado"],
  "depende_de": ["Mod_Gestao_Genius_Hub", "Mod_Gestao_Dados_DataLake"],
  "integra_com": ["Mod_Gestao_Dashboards_BI", "Mod_Gestao_Integracoes_APIs"],
  "permissoes_perfis": ["admin_ecossistema", "gestor_modulo", "operador_autorizado"],
  "dashboards_proprios": ["dashboard_status_fractal", "dashboard_pendencias_fractal"]
}
`,
  "contrato_integracao.md": `# Contrato de Integração - {{NOME_FRACTAL}}

## Objetivo
{{DESCRICAO_FRACTAL}}

## Entradas
- id_entidade_base
- id_registro_origem
- dados_origem
- usuario_responsavel
- data_evento

## Saídas
- registro_validado
- status_processamento
- evento_publicado
- payload_integracao

## Eventos publicados
- {{EVENTO_BASE}}.criado
- {{EVENTO_BASE}}.atualizado
- {{EVENTO_BASE}}.validado
- {{EVENTO_BASE}}.sincronizado

## Eventos consumidos
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- usuario.permissao_atualizada
`,
  "schema_dados.json": `{
  "tabela_sugerida": "{{TABELA_FRACTAL}}",
  "primary_key": "id_fractal_registro",
  "campos": [
    { "nome": "id_fractal_registro", "tipo": "uuid", "obrigatorio": true, "descricao": "Identificador único do registro do fractal." },
    { "nome": "id_entidade_base", "tipo": "uuid/text", "obrigatorio": true, "descricao": "Referência da entidade base do módulo." },
    { "nome": "id_origem", "tipo": "text", "obrigatorio": false, "descricao": "Referência externa ou registro de origem." },
    { "nome": "status", "tipo": "text", "obrigatorio": true, "descricao": "Status do registro dentro do fractal." },
    { "nome": "payload", "tipo": "jsonb", "obrigatorio": false, "descricao": "Dados flexíveis do fractal." },
    { "nome": "created_at", "tipo": "timestamptz", "obrigatorio": true, "descricao": "Data de criação." },
    { "nome": "updated_at", "tipo": "timestamptz", "obrigatorio": true, "descricao": "Data de atualização." },
    { "nome": "sync_status", "tipo": "text", "obrigatorio": true, "descricao": "Status de sincronização." }
  ],
  "relacionamentos": []
}
`,
  "eventos_fractal.md": `# Eventos do Fractal - {{NOME_FRACTAL}}

## Publica
- {{EVENTO_BASE}}.criado
- {{EVENTO_BASE}}.atualizado
- {{EVENTO_BASE}}.validado
- {{EVENTO_BASE}}.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload mínimo
\`\`\`json
{
  "id_evento": "uuid",
  "nome_evento": "{{EVENTO_BASE}}.criado",
  "id_entidade_base": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "{{NOME_MODULO}}",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
\`\`\`
`
};

const moduleDocs = {
  "README.md": `# {{NOME_MODULO}}

## Função
{{DESCRICAO_MODULO}}

## Padrão plug and play
Este módulo segue o padrão Genius de módulo, submódulos e fractais independentes, complementares e altamente integrados.

## Estrutura
- 0_IN_Entrada
- 1_DNA_Processo
- 2_OUT_Saida
- 3_LIB_Biblioteca
- fractais centrais do módulo
- fractais por submódulo
- contratos, schemas, eventos, API, Supabase, dashboards, agentes, automações e playbook
`,
  "manifesto_modulo.json": `{
  "nome_modulo": "{{NOME_MODULO}}",
  "descricao": "{{DESCRICAO_MODULO}}",
  "status": "template",
  "versao": "0.1.0",
  "plug_and_play": true,
  "camadas": ["entrada", "dna_processo", "saida", "biblioteca", "fractais", "supabase", "api", "dashboards", "agentes"],
  "depende_de": ["Mod_Gestao_Genius_Hub", "Mod_Gestao_Dados_DataLake"],
  "integra_com": ["Mod_Gestao_Integracoes_APIs", "Mod_Gestao_Dashboards_BI"]
}
`,
  "contrato_integracao.md": `# Contrato de Integração - {{NOME_MODULO}}

## Objetivo
Definir como o módulo recebe dados, processa fractais, publica eventos e se integra ao ecossistema Genius.

## Entradas
- formulários
- planilhas
- APIs
- eventos do Genius Hub
- dados de outros módulos

## Saídas
- registros validados
- eventos
- dashboards
- dados para DataLake
- endpoints de API
`,
  "SUPABASE_SCHEMA_TEMPLATE.sql": `-- SUPABASE_SCHEMA_TEMPLATE.sql
-- Substituir {{NOME_MODULO}}, {{SCHEMA_MODULO}} e tabelas conforme módulo gerado.

create extension if not exists pgcrypto;
create schema if not exists {{SCHEMA_MODULO}};

create table if not exists {{SCHEMA_MODULO}}.entidade_base (
  id_entidade_base uuid primary key default gen_random_uuid(),
  codigo text unique not null,
  nome text not null,
  status text not null default 'pendente',
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
`,
  "OPENAPI_TEMPLATE.yaml": `openapi: 3.1.0
info:
  title: API - {{NOME_MODULO}}
  version: 0.1.0
  description: Contrato OpenAPI plug and play do módulo.
paths:
  /entidades:
    get:
      summary: Lista entidades base do módulo
      responses:
        "200":
          description: OK
  /entidades/{id_entidade_base}/fractais:
    get:
      summary: Lista fractais da entidade base
      responses:
        "200":
          description: OK
`,
  "DASHBOARDS_TEMPLATE.md": `# DASHBOARDS_{{NOME_MODULO}}

## Dashboards mínimos
- dashboard_executivo_modulo
- dashboard_cadastro_status
- dashboard_pendencias
- dashboard_integracoes
- dashboard_fractais
`,
  "AGENTES_TEMPLATE.md": `# AGENTES_{{NOME_MODULO}}

## Agentes mínimos
- agente_cadastro
- agente_validacao
- agente_integracao
- agente_dashboard
- agente_auditor
`,
  "AUTOMACOES_TEMPLATE.md": `# AUTOMACOES_{{NOME_MODULO}}

## Automações mínimas
- validar cadastro mínimo
- publicar eventos
- sincronizar DataLake
- atualizar dashboards
- auditar inconsistências
`,
  "REGRAS_NEGOCIO_TEMPLATE.md": `# REGRAS_NEGOCIO_{{NOME_MODULO}}

## Regras mínimas
- entidade base precisa ter código, nome e status
- fractal precisa estar vinculado à entidade base
- registro validado precisa publicar evento
- sync com erro precisa gerar pendência
`,
  "PLAYBOOK_OPERACIONAL_TEMPLATE.md": `# PLAYBOOK_OPERACIONAL_{{NOME_MODULO}}

## Sequência mínima
1. Cadastrar entidade base.
2. Ativar fractais centrais.
3. Ativar fractais dos submódulos.
4. Validar dados.
5. Publicar eventos.
6. Atualizar dashboards.
`
};

const generatorReadme = `# GERADOR_MODULO_PLUG_AND_PLAY

Este gerador cria módulos no padrão Genius plug and play.

## Entrada esperada

Arquivo JSON com:

\`\`\`json
{
  "destino": "E:/caminho/do/grupo",
  "nome_modulo": "01_Mod_Exemplo",
  "descricao_modulo": "Descrição do módulo.",
  "schema_modulo": "mod_exemplo",
  "fractais_modulo": [
    { "nome": "01_fractal_identidade", "titulo": "Identidade", "descricao": "Define identidade do módulo." }
  ],
  "submodulos": [
    {
      "nome": "01_sub_cadastro",
      "fractais": [
        { "nome": "01_fractal_dados_basicos", "titulo": "Dados básicos", "descricao": "Registra dados básicos." }
      ]
    }
  ]
}
\`\`\`

## Uso

\`\`\`powershell
node gerar_modulo_plug_and_play.mjs config_modulo_exemplo.json
\`\`\`
`;

const generatorScript = `import fs from "node:fs/promises";
import path from "node:path";

const configPath = process.argv[2];
if (!configPath) {
  console.error("Uso: node gerar_modulo_plug_and_play.mjs config_modulo.json");
  process.exit(1);
}

const templateRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const moduleTemplate = path.join(templateRoot, "TEMPLATE_MODULO_PLUG_AND_PLAY");
const config = JSON.parse(await fs.readFile(configPath, "utf8"));
const modulePath = path.join(config.destino, config.nome_modulo);

function replacements(extra = {}) {
  return {
    "{{NOME_MODULO}}": config.nome_modulo,
    "{{DESCRICAO_MODULO}}": config.descricao_modulo ?? "",
    "{{SCHEMA_MODULO}}": config.schema_modulo ?? config.nome_modulo.toLowerCase().replace(/[^a-z0-9_]/g, "_"),
    ...extra
  };
}

function applyTemplate(content, map) {
  let output = content;
  for (const [key, value] of Object.entries(map)) output = output.replaceAll(key, value ?? "");
  return output;
}

async function copyTemplateFile(source, target, map) {
  const content = await fs.readFile(source, "utf8");
  await fs.mkdir(path.dirname(target), { recursive: true });
  await fs.writeFile(target, applyTemplate(content, map), "utf8");
}

async function writeFractal(basePath, fractal, scope, submoduleName = "N/A") {
  const fractalTemplate = path.join(templateRoot, "TEMPLATE_FRACTAL_PLUG_AND_PLAY");
  const fractalPath = path.join(basePath, fractal.nome);
  const eventBase = (config.schema_modulo ?? config.nome_modulo).toLowerCase().replace(/[^a-z0-9_]/g, "_") + "." + fractal.nome.replace(/^\\\\d+_/, "");
  const map = replacements({
    "{{NOME_FRACTAL}}": fractal.nome,
    "{{TITULO_FRACTAL}}": fractal.titulo ?? fractal.nome,
    "{{DESCRICAO_FRACTAL}}": fractal.descricao ?? "",
    "{{ESCOPO_FRACTAL}}": scope,
    "{{NOME_SUBMODULO}}": submoduleName,
    "{{EVENTO_BASE}}": eventBase,
    "{{TABELA_FRACTAL}}": fractal.nome.replace(/^\\\\d+_fractal_/, "fractal_")
  });
  for (const file of await fs.readdir(fractalTemplate)) {
    await copyTemplateFile(path.join(fractalTemplate, file), path.join(fractalPath, file), map);
  }
}

await fs.mkdir(modulePath, { recursive: true });
for (const dir of ["0_IN_Entrada", "1_DNA_Processo", "2_OUT_Saida", "3_LIB_Biblioteca"]) {
  await fs.mkdir(path.join(modulePath, dir), { recursive: true });
}

for (const file of await fs.readdir(moduleTemplate)) {
  const source = path.join(moduleTemplate, file);
  const stat = await fs.stat(source);
  if (stat.isFile()) await copyTemplateFile(source, path.join(modulePath, file), replacements());
}

const centralPath = path.join(modulePath, "1_DNA_Processo", "fractais_modulo");
for (const fractal of config.fractais_modulo ?? []) {
  await writeFractal(centralPath, fractal, "fractal_central_modulo");
}

const submodulesPath = path.join(modulePath, "1_DNA_Processo", "submodulos");
for (const submodule of config.submodulos ?? []) {
  const subPath = path.join(submodulesPath, submodule.nome);
  await fs.mkdir(path.join(subPath, "fractais"), { recursive: true });
  await fs.writeFile(path.join(subPath, "README.md"), "# " + submodule.nome + "\\n\\nSubmódulo plug and play de " + config.nome_modulo + ".\\n", "utf8");
  for (const fractal of submodule.fractais ?? []) {
    await writeFractal(path.join(subPath, "fractais"), fractal, "fractal_submodulo", submodule.nome);
  }
}

const totalCentral = (config.fractais_modulo ?? []).length;
const totalSubFractals = (config.submodulos ?? []).reduce((sum, sub) => sum + (sub.fractais ?? []).length, 0);
console.log("MODULO=" + modulePath);
console.log("FRACTAIS_CENTRAIS=" + totalCentral);
console.log("FRACTAIS_SUBMODULOS=" + totalSubFractals);
console.log("TOTAL_FRACTAIS=" + (totalCentral + totalSubFractals));
console.log("STATUS=OK");
`;

await mkdir(templatesRoot);
await mkdir(moduleTemplate);
await mkdir(fractalTemplate);
await mkdir(generatorDir);

for (const [file, content] of Object.entries(moduleDocs)) {
  await write(path.join(moduleTemplate, file), content);
}

await mkdir(path.join(moduleTemplate, "1_DNA_Processo", "fractais_modulo", "01_fractal_template"));
await mkdir(path.join(moduleTemplate, "1_DNA_Processo", "submodulos", "01_sub_template", "fractais", "01_fractal_template"));

for (const [file, content] of Object.entries(fractalFiles)) {
  await write(path.join(fractalTemplate, file), content);
  await write(path.join(moduleTemplate, "1_DNA_Processo", "fractais_modulo", "01_fractal_template", file), content);
  await write(path.join(moduleTemplate, "1_DNA_Processo", "submodulos", "01_sub_template", "fractais", "01_fractal_template", file), content);
}

await write(path.join(moduleTemplate, "1_DNA_Processo", "submodulos", "01_sub_template", "README.md"), "# 01_sub_template\n\nSubmódulo template plug and play.\n");
await write(path.join(generatorDir, "README.md"), generatorReadme);
await write(path.join(generatorDir, "gerar_modulo_plug_and_play.mjs"), generatorScript);

const expected = [
  moduleTemplate,
  fractalTemplate,
  generatorDir,
  path.join(generatorDir, "gerar_modulo_plug_and_play.mjs"),
  path.join(moduleTemplate, "README.md"),
  path.join(fractalTemplate, "manifesto_fractal.json")
];

for (const item of expected) await fs.access(item);

console.log(`TEMPLATES_ROOT=${templatesRoot}`);
console.log("TEMPLATE_MODULO=OK");
console.log("TEMPLATE_FRACTAL=OK");
console.log("GERADOR=OK");
