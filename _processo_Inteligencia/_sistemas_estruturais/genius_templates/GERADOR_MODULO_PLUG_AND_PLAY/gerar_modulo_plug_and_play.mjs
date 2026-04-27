import fs from "node:fs/promises";
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
  const eventBase = (config.schema_modulo ?? config.nome_modulo).toLowerCase().replace(/[^a-z0-9_]/g, "_") + "." + fractal.nome.replace(/^\\d+_/, "");
  const map = replacements({
    "{{NOME_FRACTAL}}": fractal.nome,
    "{{TITULO_FRACTAL}}": fractal.titulo ?? fractal.nome,
    "{{DESCRICAO_FRACTAL}}": fractal.descricao ?? "",
    "{{ESCOPO_FRACTAL}}": scope,
    "{{NOME_SUBMODULO}}": submoduleName,
    "{{EVENTO_BASE}}": eventBase,
    "{{TABELA_FRACTAL}}": fractal.nome.replace(/^\\d+_fractal_/, "fractal_")
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
  await fs.writeFile(path.join(subPath, "README.md"), "# " + submodule.nome + "\n\nSubmódulo plug and play de " + config.nome_modulo + ".\n", "utf8");
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
