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

function mdTable(headers, rows) {
  return [
    `| ${headers.join(" | ")} |`,
    `| ${headers.map(() => "---").join(" | ")} |`,
    ...rows.map((row) => `| ${row.map((cell) => String(cell ?? "").replaceAll("\n", " ")).join(" | ")} |`)
  ].join("\n");
}

async function collectFractals() {
  const fractals = [];
  const centralPath = path.join(dnaPath, "fractais_modulo");
  for (const entry of await fs.readdir(centralPath, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const fractalPath = path.join(centralPath, entry.name);
    fractals.push({
      nivel: "modulo",
      submodulo: "N/A",
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
  return fractals.sort((a, b) => `${a.submodulo}/${a.nome}`.localeCompare(`${b.submodulo}/${b.nome}`));
}

function suggestedDashboard(fractal) {
  const text = `${fractal.nome} ${fractal.submodulo}`.toLowerCase();
  if (text.includes("document")) return "dashboard_documental";
  if (text.includes("territor") || text.includes("area") || text.includes("limite") || text.includes("acesso")) return "dashboard_territorial_operacional";
  if (text.includes("ativo") || text.includes("estrutura") || text.includes("conservacao") || text.includes("manutencao")) return "dashboard_ativos_estruturais";
  if (text.includes("status") || text.includes("pendencia") || text.includes("risco")) return "dashboard_status_pendencias";
  if (text.includes("permiss") || text.includes("chave") || text.includes("acesso")) return "dashboard_governanca_acessos";
  if (text.includes("prestacao") || text.includes("conformidade") || text.includes("auditoria")) return "dashboard_prestacao_contas";
  if (fractal.nivel === "modulo") return "dashboard_executivo_unidade";
  return "dashboard_cadastro_base";
}

const fractals = await collectFractals();

const dashboards = [
  ["dashboard_executivo_unidade", "Visão executiva da unidade agrícola", "Gestores, diretoria, agentes executivos", "Resumo de unidades, status, pendências, área total, completude e riscos."],
  ["dashboard_cadastro_base", "Cadastro base da unidade", "Equipe administrativa e cadastro", "Acompanha preenchimento, validação, duplicidades e qualidade cadastral."],
  ["dashboard_documental", "Documentação e regularidade", "Administrativo, jurídico, fiscal e ambiental", "Monitora documentos, vencimentos, pendências e situação de validação."],
  ["dashboard_territorial_operacional", "Território, áreas e acessos", "Operação, campo, georreferenciamento e logística", "Acompanha áreas, talhões, limites, acessos, circulação e pontos críticos."],
  ["dashboard_ativos_estruturais", "Ativos estruturais da unidade", "Infraestrutura, manutenção e construções rurais", "Monitora estruturas, benfeitorias, equipamentos fixos e estado de conservação."],
  ["dashboard_governanca_acessos", "Governança, chaves e permissões", "Gestão, segurança, workspace e cowork", "Controla responsáveis, perfis, acessos, autorizações e histórico."],
  ["dashboard_status_pendencias", "Status, riscos e pendências", "Gestores, agentes e responsáveis", "Consolida riscos, bloqueios, pendências, status operacional e alertas."],
  ["dashboard_prestacao_contas", "Prestação de contas da unidade", "Gestão, auditoria, financeiro e administrativo", "Consolida evidências, conformidade, pendências e histórico de atualização."],
  ["dashboard_integracoes_ecossistema", "Integrações com ecossistema Genius", "TechOps, integrações, BI e DataLake", "Monitora eventos, sync_status, APIs, Hub, DataLake e módulos consumidores."]
];

const dashboardDoc = `# DASHBOARDS_Mod_Gestao_Unidade_Agricola

Este documento define os dashboards plug and play do módulo Gestão da Unidade Agrícola.

## Objetivo

Transformar os dados dos fractais em visões gerenciais, operacionais e técnicas para tomada de decisão.

## Dashboards recomendados

${mdTable(["dashboard", "nome", "publico", "funcao"], dashboards)}

## Fluxo de alimentação

\`\`\`text
Supabase / Formularios / Planilhas
  -> Tabelas dos fractais
  -> Eventos dos fractais
  -> Genius Hub
  -> DataLake
  -> Dashboards BI
  -> Agentes e automacoes
\`\`\`

## Regra plug and play

Cada dashboard deve poder funcionar isoladamente, mas todos devem alimentar o dashboard executivo da unidade e o dashboard geral do ecossistema Genius.
`;

const kpis = [
  ["kpi_total_unidades", "Total de unidades agrícolas", "count(unidades_agricolas)", "unidades_agricolas", "executivo"],
  ["kpi_unidades_ativas", "Unidades ativas", "count where status_cadastro = Ativo", "unidades_agricolas", "executivo"],
  ["kpi_unidades_pendentes", "Unidades pendentes", "count where status_cadastro in Pendente/Em validacao", "unidades_agricolas", "executivo"],
  ["kpi_area_total_ha", "Área total cadastrada", "sum(area_total_ha)", "unidades_agricolas", "territorial"],
  ["kpi_completude_cadastral", "Completude cadastral", "campos preenchidos / campos obrigatorios", "fractais de cadastro", "cadastro"],
  ["kpi_documentos_validos", "Documentos válidos", "count documentos com status válido", "fractais documentais", "documental"],
  ["kpi_documentos_vencidos", "Documentos vencidos", "count documentos vencidos", "fractais documentais", "documental"],
  ["kpi_areas_talhoes_cadastrados", "Áreas/talhões/glebas cadastrados", "count registros territoriais", "fractais territoriais", "territorial"],
  ["kpi_ativos_estruturais", "Ativos estruturais cadastrados", "count ativos estruturais", "fractais de ativos", "infraestrutura"],
  ["kpi_pendencias_abertas", "Pendências abertas", "count status pendente/erro", "todos os fractais", "status"],
  ["kpi_riscos_criticos", "Riscos críticos", "count riscos críticos", "status e pendências", "status"],
  ["kpi_eventos_publicados", "Eventos publicados", "count fractal_eventos_log", "fractal_eventos_log", "integração"],
  ["kpi_sync_pendente", "Sincronizações pendentes", "count sync_status = pendente", "todos os fractais", "integração"],
  ["kpi_sync_erro", "Sincronizações com erro", "count sync_status = erro", "todos os fractais", "integração"],
  ["kpi_conformidade_unidade", "Índice de conformidade da unidade", "media ponderada cadastro/documentos/status/evidencias", "múltiplas fontes", "executivo"]
];

const kpiDoc = `# INDICADORES_KPIS_Mod_Gestao_Unidade_Agricola

Este catálogo define os indicadores mínimos para acompanhamento do módulo.

## KPIs recomendados

${mdTable(["kpi", "nome", "formula_logica", "fonte", "categoria"], kpis)}

## Frequência sugerida

- Operacional: em tempo quase real ou a cada sincronização.
- Gestão diária: atualização diária.
- Auditoria e prestação de contas: atualização por evento validado.
- Histórico/DataLake: atualização incremental.
`;

const metricRows = fractals.map((fractal) => {
  const base = fractal.nome.replace(/^\d+_/, "");
  return [
    fractal.nivel,
    fractal.submodulo,
    fractal.nome,
    suggestedDashboard(fractal),
    `qtd_${base}`,
    `pendencias_${base}`,
    `sync_${base}`,
    `unidade_agricola.${base}.*`
  ];
});

const metricsDoc = `# METRICAS_FRACTAIS_Mod_Gestao_Unidade_Agricola

Este arquivo amarra cada fractal aos seus indicadores próprios e ao dashboard recomendado.

## Métricas por fractal

${mdTable(["nivel", "submodulo", "fractal", "dashboard", "metrica_quantidade", "metrica_pendencia", "metrica_sync", "eventos"], metricRows)}

## Métricas padrão por fractal

- Quantidade de registros.
- Registros pendentes.
- Registros validados.
- Registros com erro.
- Última atualização.
- Eventos publicados.
- Sync pendente.
- Sync com erro.
`;

const contractRows = dashboards.map(([dashboard, , , funcao]) => {
  const related = fractals
    .filter((fractal) => suggestedDashboard(fractal) === dashboard)
    .map((fractal) => fractal.schema.tabela_sugerida)
    .slice(0, 8)
    .join(", ");
  return [
    dashboard,
    related || "unidades_agricolas, fractal_eventos_log",
    "fractal_eventos_log, fractal_eventos_catalogo",
    "OPENAPI_Mod_Gestao_Unidade_Agricola.yaml",
    funcao
  ];
});

const dataContractDoc = `# DASHBOARD_CONTRATO_DADOS_Mod_Gestao_Unidade_Agricola

Este contrato define quais fontes alimentam cada dashboard do módulo.

## Fontes obrigatórias

- Supabase schema: \`unidade_agricola\`
- Tabela raiz: \`unidade_agricola.unidades_agricolas\`
- Tabelas dos fractais
- \`unidade_agricola.fractal_eventos_catalogo\`
- \`unidade_agricola.fractal_eventos_log\`
- OpenAPI do módulo
- Genius Hub
- DataLake

## Contrato por dashboard

${mdTable(["dashboard", "tabelas_fractais", "eventos", "api", "uso"], contractRows)}

## Regras de qualidade dos dados

- Todo dashboard deve filtrar por \`id_unidade_agricola\`.
- Todo indicador deve aceitar filtros por status, período, município, UF e sync_status.
- Dados de payload devem ser estabilizados em colunas quando virarem regra permanente.
- Eventos devem ser rastreáveis por \`id_evento\`, \`id_fractal_registro\` e \`id_unidade_agricola\`.
- O dashboard do módulo deve se integrar ao dashboard geral do ecossistema Genius.
`;

const outputs = [
  ["DASHBOARDS_Mod_Gestao_Unidade_Agricola.md", dashboardDoc],
  ["INDICADORES_KPIS_Mod_Gestao_Unidade_Agricola.md", kpiDoc],
  ["METRICAS_FRACTAIS_Mod_Gestao_Unidade_Agricola.md", metricsDoc],
  ["DASHBOARD_CONTRATO_DADOS_Mod_Gestao_Unidade_Agricola.md", dataContractDoc]
];

for (const [file, content] of outputs) {
  await fs.writeFile(path.join(modulePath, file), content, "utf8");
}

for (const [file] of outputs) {
  await fs.access(path.join(modulePath, file));
}

console.log(`FRACTAIS=${fractals.length}`);
console.log(`DASHBOARDS=${dashboards.length}`);
console.log(`KPIS=${kpis.length}`);
console.log(`METRICAS_FRACTAIS=${metricRows.length}`);
console.log(`ARQUIVOS=${outputs.length}`);
console.log("STATUS=OK");
