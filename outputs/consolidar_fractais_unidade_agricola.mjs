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

async function getFractals() {
  const fractals = [];
  const centralPath = path.join(dnaPath, "fractais_modulo");
  for (const entry of await fs.readdir(centralPath, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const fractalPath = path.join(centralPath, entry.name);
    fractals.push({
      nivel: "modulo",
      submodulo: "N/A",
      nome: entry.name,
      path: fractalPath,
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
        path: fractalPath,
        manifesto: await readJson(path.join(fractalPath, "manifesto_fractal.json")),
        schema: await readJson(path.join(fractalPath, "schema_dados.json"))
      });
    }
  }
  return fractals.sort((a, b) => `${a.submodulo}/${a.nome}`.localeCompare(`${b.submodulo}/${b.nome}`));
}

function eventBase(fractal) {
  return `unidade_agricola.${fractal.nome}`;
}

function relPath(filePath) {
  return path.relative(modulePath, filePath).replaceAll("\\", "/");
}

function mdTable(headers, rows) {
  return [
    `| ${headers.join(" | ")} |`,
    `| ${headers.map(() => "---").join(" | ")} |`,
    ...rows.map((row) => `| ${row.map((cell) => String(cell ?? "").replaceAll("\n", " ")).join(" | ")} |`)
  ].join("\n");
}

const fractals = await getFractals();

const eventsRows = fractals.flatMap((fractal) => {
  const base = eventBase(fractal);
  return [
    [base + ".criado", fractal.nivel, fractal.submodulo, fractal.nome, "Publicado quando um registro do fractal e criado.", "Hub, DataLake, Dashboards, APIs"],
    [base + ".atualizado", fractal.nivel, fractal.submodulo, fractal.nome, "Publicado quando um registro do fractal e atualizado.", "Hub, DataLake, Dashboards, APIs"],
    [base + ".validado", fractal.nivel, fractal.submodulo, fractal.nome, "Publicado quando o registro fica apto para integracao.", "Hub, DataLake, Dashboards, APIs"],
    [base + ".sincronizado", fractal.nivel, fractal.submodulo, fractal.nome, "Publicado apos sincronizacao com camada de dados ou API.", "Hub, DataLake, Supabase, APIs"]
  ];
});

const eventsDoc = `# Catalogo de Eventos dos Fractais - ${moduleName}

Este catalogo consolida os eventos publicados pelos fractais do modulo Gestão da Unidade Agrícola.

## Convencao de nomes

Padrao:

\`\`\`text
unidade_agricola.<nome_fractal>.<acao>
\`\`\`

Acoes padrao:

- \`criado\`: registro criado.
- \`atualizado\`: registro atualizado.
- \`validado\`: registro validado para uso e integracao.
- \`sincronizado\`: registro sincronizado com Hub, DataLake, Supabase ou APIs.

## Eventos

${mdTable(["evento", "nivel", "submodulo", "fractal", "quando_publica", "consumidores"], eventsRows)}

## Payload minimo padrao

\`\`\`json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.fractal_x.criado",
  "id_unidade_agricola": "uuid/text",
  "id_fractal_registro": "uuid",
  "modulo_origem": "${moduleName}",
  "submodulo_origem": "nome_submodulo",
  "fractal_origem": "nome_fractal",
  "status": "pendente|validado|sincronizado|erro",
  "payload": {},
  "created_at": "timestamp"
}
\`\`\`
`;

const schemaRows = fractals.map((fractal) => [
  fractal.nivel,
  fractal.submodulo,
  fractal.nome,
  fractal.schema.tabela_sugerida,
  fractal.schema.primary_key,
  fractal.schema.campos.map((campo) => campo.nome).join(", "),
  relPath(path.join(fractal.path, "schema_dados.json"))
]);

const schemasDoc = `# Catalogo de Schemas dos Fractais - ${moduleName}

Este arquivo consolida as tabelas sugeridas e os campos basicos de cada fractal para orientar Supabase, APIs, DataLake e agentes.

## Diretriz geral

Cada fractal pode virar uma tabela propria, uma view, uma funcao de dominio ou uma colecao logica no DataLake. A decisao tecnica final pode variar, mas o contrato de dados fica preservado.

## Schemas por fractal

${mdTable(["nivel", "submodulo", "fractal", "tabela_sugerida", "primary_key", "campos_base", "arquivo_schema"], schemaRows)}

## Campos minimos comuns

Todo fractal deve manter estes campos ou equivalentes:

- \`id_fractal_registro\`
- \`id_unidade_agricola\`
- \`id_origem\`
- \`status\`
- \`payload\`
- \`created_at\`
- \`updated_at\`
- \`sync_status\`
`;

const matrixRows = fractals.map((fractal) => [
  fractal.nivel,
  fractal.submodulo,
  fractal.nome,
  fractal.manifesto.entradas_esperadas.join(", "),
  fractal.manifesto.saidas_geradas.join(", "),
  fractal.manifesto.depende_de.join(", "),
  fractal.manifesto.integra_com.join(", "),
  `${eventBase(fractal)}.*`
]);

const matrixDoc = `# Matriz de Integracao dos Fractais - ${moduleName}

Esta matriz mostra como cada fractal se encaixa no ecossistema Genius.

## Camadas de integracao obrigatorias

- Genius Hub: roteia eventos e sincronizacoes entre modulos.
- DataLake: armazena historico, dados analiticos e trilhas de auditoria.
- Integracoes APIs: publica e consome interfaces externas.
- Dashboards BI: consome indicadores e status dos fractais.
- Supabase: base operacional futura para tabelas, storage, autenticacao e Row Level Security.

## Matriz

${mdTable(["nivel", "submodulo", "fractal", "entradas", "saidas", "depende_de", "integra_com", "eventos"], matrixRows)}

## Regra de independencia e complementaridade

Cada fractal deve funcionar de forma independente dentro do seu submodulo, mas sempre publicar eventos e dados padronizados para permitir composicao com outros fractais, submodulos, modulos, plataformas e sistemas maiores.
`;

const indexRows = fractals.map((fractal) => [
  fractal.nivel,
  fractal.submodulo,
  fractal.nome,
  fractal.manifesto.titulo,
  fractal.manifesto.descricao,
  fractal.manifesto.status,
  relPath(fractal.path)
]);

const indexDoc = `# Indice Operacional dos Fractais - ${moduleName}

Este indice funciona como mapa rapido para humanos, agentes e automacoes encontrarem cada fractal do modulo.

## Resumo

- Fractais centrais do modulo: ${fractals.filter((item) => item.nivel === "modulo").length}
- Fractais de submodulos: ${fractals.filter((item) => item.nivel === "submodulo").length}
- Total de fractais: ${fractals.length}

## Fractais

${mdTable(["nivel", "submodulo", "fractal", "titulo", "descricao", "status", "caminho"], indexRows)}
`;

const files = [
  ["CATALOGO_EVENTOS_FRACTAIS_Mod_Gestao_Unidade_Agricola.md", eventsDoc],
  ["CATALOGO_SCHEMAS_FRACTAIS_Mod_Gestao_Unidade_Agricola.md", schemasDoc],
  ["MATRIZ_INTEGRACAO_FRACTAIS_Mod_Gestao_Unidade_Agricola.md", matrixDoc],
  ["INDICE_OPERACIONAL_FRACTAIS_Mod_Gestao_Unidade_Agricola.md", indexDoc]
];

for (const [file, content] of files) {
  await fs.writeFile(path.join(modulePath, file), content, "utf8");
}

for (const [file] of files) {
  await fs.access(path.join(modulePath, file));
}

console.log(`FRACTAIS=${fractals.length}`);
console.log(`EVENTOS=${eventsRows.length}`);
console.log(`ARQUIVOS_CENTRAIS=${files.length}`);
console.log("STATUS=OK");
