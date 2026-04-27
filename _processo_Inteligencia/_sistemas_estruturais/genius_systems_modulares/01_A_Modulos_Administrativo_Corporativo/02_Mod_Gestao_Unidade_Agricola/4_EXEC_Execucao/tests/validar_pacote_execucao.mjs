import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const execPath = path.resolve(__dirname, "..");
const modulePath = path.resolve(execPath, "..");

const requiredFiles = [
  "README.md",
  "GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola.md",
  "supabase/config.toml",
  "supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql",
  "supabase/seed/seed_unidade_agricola.sql",
  "supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql",
  "supabase/functions/unidade-agricola-api/index.ts",
  "supabase/functions/fractal-eventos/index.ts"
];

const requiredModuleFiles = [
  "SUPABASE_SCHEMA_Mod_Gestao_Unidade_Agricola.sql",
  "OPENAPI_Mod_Gestao_Unidade_Agricola.yaml",
  "CATALOGO_EVENTOS_FRACTAIS_Mod_Gestao_Unidade_Agricola.md",
  "CATALOGO_SCHEMAS_FRACTAIS_Mod_Gestao_Unidade_Agricola.md",
  "DASHBOARDS_Mod_Gestao_Unidade_Agricola.md",
  "AGENTES_Mod_Gestao_Unidade_Agricola.md",
  "AUTOMACOES_Mod_Gestao_Unidade_Agricola.md",
  "PLAYBOOK_OPERACIONAL_Mod_Gestao_Unidade_Agricola.md"
];

async function exists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function read(filePath) {
  return fs.readFile(filePath, "utf8");
}

function countMatches(text, regex) {
  return [...text.matchAll(regex)].length;
}

function status(ok) {
  return ok ? "OK" : "FALHA";
}

const checks = [];

for (const relative of requiredFiles) {
  const ok = await exists(path.join(execPath, relative));
  checks.push({ item: `arquivo_execucao:${relative}`, status: status(ok), detalhe: ok ? "encontrado" : "ausente" });
}

for (const relative of requiredModuleFiles) {
  const ok = await exists(path.join(modulePath, relative));
  checks.push({ item: `arquivo_modulo:${relative}`, status: status(ok), detalhe: ok ? "encontrado" : "ausente" });
}

const migrationPath = path.join(execPath, "supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql");
const migration = await read(migrationPath);
const totalTables = countMatches(migration, /^create table if not exists unidade_agricola\./gm);
const totalFractalTables = countMatches(migration, /^create table if not exists unidade_agricola\.fractal_/gm) - 2;
const totalCreatedEvents = countMatches(migration, /unidade_agricola\.fractal_[a-z0-9_]+\.criado/g);
const totalEvents = countMatches(migration, /unidade_agricola\.fractal_[a-z0-9_]+\.(criado|atualizado|validado|sincronizado)/g);
const invalidTableNames = countMatches(migration, /^create table if not exists unidade_agricola\.[0-9]/gm);
const invalidEventPrefixes = countMatches(migration, /unidade_agricola\.[0-9]+_/g);

checks.push({ item: "migration:tabelas_totais", status: status(totalTables === 71), detalhe: String(totalTables) });
checks.push({ item: "migration:tabelas_fractais", status: status(totalFractalTables === 68), detalhe: String(totalFractalTables) });
checks.push({ item: "migration:eventos_criado", status: status(totalCreatedEvents === 68), detalhe: String(totalCreatedEvents) });
checks.push({ item: "migration:eventos_totais", status: status(totalEvents === 272), detalhe: String(totalEvents) });
checks.push({ item: "migration:tabelas_iniciando_numero", status: status(invalidTableNames === 0), detalhe: String(invalidTableNames) });
checks.push({ item: "migration:eventos_com_prefixo_numerico", status: status(invalidEventPrefixes === 0), detalhe: String(invalidEventPrefixes) });

const seed = await read(path.join(execPath, "supabase/seed/seed_unidade_agricola.sql"));
checks.push({ item: "seed:unidade_piloto", status: status(seed.includes("PA-SEED-0001")), detalhe: seed.includes("PA-SEED-0001") ? "PA-SEED-0001" : "nao encontrado" });
checks.push({ item: "seed:evento_identidade_validado", status: status(seed.includes("fractal_identidade_unidade.validado")), detalhe: seed.includes("fractal_identidade_unidade.validado") ? "encontrado" : "ausente" });

const apiFunction = await read(path.join(execPath, "supabase/functions/unidade-agricola-api/index.ts"));
const eventFunction = await read(path.join(execPath, "supabase/functions/fractal-eventos/index.ts"));
checks.push({ item: "edge_function:unidade_api_serve", status: status(apiFunction.includes("serve(async")), detalhe: "unidade-agricola-api" });
checks.push({ item: "edge_function:eventos_serve", status: status(eventFunction.includes("serve(async")), detalhe: "fractal-eventos" });
checks.push({ item: "edge_function:schema_unidade_agricola", status: status(apiFunction.includes('.schema("unidade_agricola")') && eventFunction.includes('.schema("unidade_agricola")')), detalhe: "schema usado nas duas funcoes" });

const failures = checks.filter((check) => check.status !== "OK");
const generatedAt = new Date().toISOString();

const report = `# RELATORIO_VALIDACAO_EXECUCAO

## Módulo
Mod_Gestao_Unidade_Agricola

## Data
${generatedAt}

## Resumo

- Checks executados: ${checks.length}
- Sucessos: ${checks.length - failures.length}
- Falhas: ${failures.length}
- Status geral: ${failures.length === 0 ? "APROVADO" : "REVISAR"}

## Resultados

| item | status | detalhe |
| --- | --- | --- |
${checks.map((check) => `| ${check.item} | ${check.status} | ${check.detalhe} |`).join("\n")}

## Próxima ação recomendada

${failures.length === 0
  ? "Pacote local aprovado para teste em Supabase local ou ambiente de desenvolvimento."
  : "Corrigir os itens com FALHA antes de aplicar em Supabase."}
`;

await fs.writeFile(path.join(execPath, "tests", "RELATORIO_VALIDACAO_EXECUCAO.md"), report, "utf8");

console.log(`CHECKS=${checks.length}`);
console.log(`FALHAS=${failures.length}`);
console.log(`STATUS=${failures.length === 0 ? "APROVADO" : "REVISAR"}`);
console.log(path.join(execPath, "tests", "RELATORIO_VALIDACAO_EXECUCAO.md"));

if (failures.length > 0) process.exitCode = 1;
