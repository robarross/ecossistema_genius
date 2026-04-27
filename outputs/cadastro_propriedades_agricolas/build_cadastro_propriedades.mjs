import fs from "node:fs/promises";
import path from "node:path";
import JSZip from "jszip";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputDir = "E:/Diretorios/Diretorio_Agentes/outputs/cadastro_propriedades_agricolas";
const outputPath = path.join(outputDir, "cadastro_propriedades_agricolas_supabase_com_listas.xlsx");

const workbook = Workbook.create();

function addSheet(name, rows) {
  const sheet = workbook.worksheets.add(name);
  const endCol = columnName(rows[0].length);
  sheet.getRange(`A1:${endCol}${rows.length}`).values = rows;
  return sheet;
}

function columnName(index) {
  let name = "";
  let n = index;
  while (n > 0) {
    const mod = (n - 1) % 26;
    name = String.fromCharCode(65 + mod) + name;
    n = Math.floor((n - mod) / 26);
  }
  return name;
}

const now = "2026-04-25T00:00:00-04:00";

const cadastroHeaders = [
  "id_propriedade",
  "codigo_propriedade",
  "nome_propriedade",
  "tipo_propriedade",
  "status_cadastro",
  "situacao_operacional",
  "data_cadastro",
  "cpf_cnpj_proprietario",
  "nome_proprietario",
  "tipo_vinculo",
  "telefone_principal",
  "email_principal",
  "cep",
  "uf",
  "municipio",
  "comunidade_localidade",
  "endereco_referencia",
  "latitude_sede",
  "longitude_sede",
  "area_total_ha",
  "area_produtiva_ha",
  "area_preservacao_ha",
  "principal_atividade",
  "culturas_principais",
  "criacoes_principais",
  "possui_car",
  "numero_car",
  "possui_ccir",
  "numero_ccir",
  "possui_itr",
  "numero_itr",
  "possui_matricula",
  "numero_matricula",
  "possui_georreferenciamento",
  "fonte_georreferenciamento",
  "modulo_origem",
  "observacoes",
  "created_at",
  "updated_at",
  "sync_status"
];

const propriedades = [
  ["prop_0001", "PA-0001", "Fazenda Santa Clara", "Fazenda", "Ativo", "Em operacao", "2026-04-01", "04231876000110", "Agro Santa Clara Ltda", "Proprietario", "+55 92 99901-0001", "santaclara@exemplo.com", "69000001", "AM", "Manaus", "Ramal Bela Vista", "Km 12, margem direita", -3.1190, -60.0210, 1250.50, 820.00, 310.00, "Producao vegetal", "Mandioca; Cacau; Banana", "Aves", "Sim", "AM-000001", "Sim", "CCIR-000001", "Sim", "ITR-000001", "Sim", "MAT-000001", "Parcial", "SIGEF", "Mod_Gestao_Unidade_Agricola", "Cadastro simulado para teste de importacao.", now, now, "pendente"],
  ["prop_0002", "PA-0002", "Sitio Boa Esperanca", "Sitio", "Ativo", "Em operacao", "2026-04-02", "73921456000", "Joao Batista Ferreira", "Proprietario", "+55 92 99901-0002", "boaesperanca@exemplo.com", "69120000", "AM", "Iranduba", "Comunidade Sao Jose", "Estrada vicinal 04", -3.2841, -60.1874, 84.30, 61.20, 18.50, "Horticultura", "Hortalicas; Macaxeira; Mamao", "Galinhas", "Sim", "AM-000002", "Nao", "", "Sim", "ITR-000002", "Nao", "", "Nao", "GPS campo", "Mod_Gestao_Unidade_Agricola", "Unidade familiar com producao diversificada.", now, now, "validado"],
  ["prop_0003", "PA-0003", "Chacara Rio Verde", "Chacara", "Em validacao", "Em regularizacao", "2026-04-03", "11876543000187", "Cooperativa Rio Verde", "Cooperativa", "+55 92 99901-0003", "rioverde@exemplo.com", "69151000", "AM", "Manacapuru", "Lago do Miriti", "Proximo ao porto comunitario", -3.2998, -60.6205, 42.75, 28.40, 9.10, "Agrofloresta", "Acai; Cupuacu; Cacau", "Abelhas", "Sim", "AM-000003", "Sim", "CCIR-000003", "Nao", "", "Nao", "", "Parcial", "CAR", "Mod_Gestao_Unidade_Agricola", "Aguardando validacao documental.", now, now, "pendente"],
  ["prop_0004", "PA-0004", "Fazenda Nova Alianca", "Fazenda", "Ativo", "Em operacao", "2026-04-04", "05362987000164", "Nova Alianca Agropecuaria", "Proprietario", "+55 92 99901-0004", "novaalianca@exemplo.com", "76800000", "RO", "Porto Velho", "Linha 21", "Km 38 da linha principal", -8.7612, -63.9039, 2380.00, 1460.00, 710.00, "Pecuaria", "Milho; Capim; Soja", "Bovinos", "Sim", "RO-000004", "Sim", "CCIR-000004", "Sim", "ITR-000004", "Sim", "MAT-000004", "Sim", "SIGEF", "Mod_Gestao_Unidade_Agricola", "Area com pecuaria e lavoura integrada.", now, now, "importado"],
  ["prop_0005", "PA-0005", "Unidade Produtiva Sao Pedro", "Unidade produtiva", "Ativo", "Em implantacao", "2026-04-05", "64028319000", "Maria Oliveira Santos", "Possuidor", "+55 93 99901-0005", "saopedro@exemplo.com", "68180000", "PA", "Santarem", "Planalto Santareno", "Travessao 07", -2.5310, -54.7065, 63.20, 44.80, 12.00, "Fruticultura", "Cupuacu; Banana; Limao", "Suinos", "Nao", "", "Nao", "", "Nao", "", "Nao", "", "Nao", "GPS campo", "Mod_Gestao_Unidade_Agricola", "Cadastro inicial para regularizacao.", now, now, "erro"],
  ["prop_0006", "PA-0006", "Fazenda Horizonte", "Fazenda", "Ativo", "Em operacao", "2026-04-06", "19182745000131", "Horizonte Agro Ltda", "Arrendatario", "+55 69 99901-0006", "horizonte@exemplo.com", "76900000", "RO", "Ji-Parana", "Setor Riachuelo", "Linha 94, lote 18", -10.8850, -61.9512, 910.00, 620.00, 205.00, "Graos", "Soja; Milho; Arroz", "Bovinos", "Sim", "RO-000006", "Sim", "CCIR-000006", "Sim", "ITR-000006", "Sim", "MAT-000006", "Sim", "SIGEF", "Mod_Gestao_Unidade_Agricola", "Propriedade pronta para integracao produtiva.", now, now, "validado"],
  ["prop_0007", "PA-0007", "Sitio Primavera", "Sitio", "Pendente", "Em regularizacao", "2026-04-07", "58291376000", "Carlos Menezes Lima", "Parceiro", "+55 92 99901-0007", "primavera@exemplo.com", "69240000", "AM", "Presidente Figueiredo", "Ramal do Urubui", "Km 5 apos ponte", -2.0342, -60.0251, 31.90, 21.60, 6.00, "Olericultura", "Pimentao; Alface; Coentro", "Peixes", "Nao", "", "Nao", "", "Nao", "", "Nao", "", "Nao", "App campo", "Mod_Gestao_Unidade_Agricola", "Falta complementar documentos.", now, now, "pendente"],
  ["prop_0008", "PA-0008", "Fazenda Sol Nascente", "Fazenda", "Ativo", "Em operacao", "2026-04-08", "08273651000155", "Sol Nascente Rural SA", "Proprietario", "+55 94 99901-0008", "solnascente@exemplo.com", "68540000", "PA", "Redencao", "Vicinal 12", "Entrada pela rodovia estadual", -8.0306, -50.0319, 1750.00, 1190.00, 430.00, "Pecuaria", "Capim; Milho; Sorgo", "Bovinos; Equinos", "Sim", "PA-000008", "Sim", "CCIR-000008", "Sim", "ITR-000008", "Sim", "MAT-000008", "Sim", "SIGEF", "Mod_Gestao_Unidade_Agricola", "Base para rastreabilidade e comercializacao.", now, now, "validado"],
  ["prop_0009", "PA-0009", "Comunidade Agroextrativista Mapira", "Comunidade agricola", "Ativo", "Em operacao", "2026-04-09", "31928764000102", "Associacao Mapira", "Associacao", "+55 92 99901-0009", "mapira@exemplo.com", "69470000", "AM", "Tefe", "Rio Mapira", "Acesso fluvial pela comunidade", -3.3682, -64.7205, 520.75, 210.30, 260.00, "Agroextrativismo", "Acai; Castanha; Mandioca", "Aves; Peixes", "Sim", "AM-000009", "Nao", "", "Nao", "", "Nao", "", "Parcial", "CAR", "Mod_Gestao_Unidade_Agricola", "Cadastro coletivo com varias familias.", now, now, "pendente"],
  ["prop_0010", "PA-0010", "Lote Rural Caminho das Aguas", "Lote rural", "Ativo", "Em implantacao", "2026-04-10", "90548271000", "Ana Lucia Pereira", "Proprietario", "+55 92 99901-0010", "caminhodasaguas@exemplo.com", "69100000", "AM", "Careiro", "BR-319", "Lote 32, ramal secundario", -3.7680, -60.3620, 18.40, 12.80, 3.20, "Piscicultura", "Macaxeira; Banana", "Tambacu; Tambaqui", "Sim", "AM-000010", "Nao", "", "Sim", "ITR-000010", "Nao", "", "Nao", "GPS campo", "Mod_Gestao_Unidade_Agricola", "Unidade pequena para simulacao plug and play.", now, now, "validado"]
];

const contatoHeaders = [
  "id_contato",
  "id_propriedade",
  "tipo_contato",
  "nome",
  "cpf_cnpj",
  "cargo_funcao",
  "telefone",
  "email",
  "principal",
  "observacoes"
];

const contatos = propriedades.map((prop, index) => [
  `cont_${String(index + 1).padStart(4, "0")}`,
  prop[0],
  index % 3 === 0 ? "Responsavel tecnico" : index % 3 === 1 ? "Proprietario" : "Administrativo",
  prop[8],
  prop[7],
  index % 3 === 0 ? "Responsavel de campo" : index % 3 === 1 ? "Responsavel legal" : "Gestao documental",
  prop[10],
  prop[11],
  index === 0 ? "Sim" : "Nao",
  "Contato simulado vinculado a propriedade."
]);

const areaHeaders = [
  "id_area",
  "id_propriedade",
  "codigo_area",
  "nome_area_talhao_gleba",
  "tipo_area",
  "area_ha",
  "uso_atual",
  "cultura_atividade",
  "latitude_centroide",
  "longitude_centroide",
  "status_area",
  "observacoes"
];

const areas = propriedades.map((prop, index) => [
  `area_${String(index + 1).padStart(4, "0")}`,
  prop[0],
  `TAL-${String(index + 1).padStart(2, "0")}`,
  index % 2 === 0 ? `Talhao ${String(index + 1).padStart(2, "0")}` : `Gleba ${String(index + 1).padStart(2, "0")}`,
  index % 2 === 0 ? "Talhao" : "Gleba",
  Number((prop[20] * 0.18).toFixed(2)),
  index % 4 === 0 ? "Produtivo" : index % 4 === 1 ? "Implantacao" : index % 4 === 2 ? "Reserva" : "Pousio",
  String(prop[23]).split(";")[0].trim(),
  Number((prop[17] - 0.004).toFixed(4)),
  Number((prop[18] - 0.004).toFixed(4)),
  prop[4] === "Pendente" ? "Pendente" : "Ativo",
  "Area simulada para teste de relacionamento com propriedade."
]);

const documentoHeaders = [
  "id_documento",
  "id_propriedade",
  "tipo_documento",
  "numero_documento",
  "orgao_emissor",
  "data_emissao",
  "data_validade",
  "status_documento",
  "url_arquivo",
  "observacoes"
];

const documentos = propriedades.map((prop, index) => {
  const tipos = ["CAR", "CCIR", "ITR", "Matricula", "Contrato", "Licenca", "Georreferenciamento", "Declaracao", "Associacao", "Cadastro municipal"];
  const tipo = tipos[index];
  return [
    `doc_${String(index + 1).padStart(4, "0")}`,
    prop[0],
    tipo,
    `${tipo.toUpperCase().replaceAll(" ", "-")}-${String(index + 1).padStart(6, "0")}`,
    index % 2 === 0 ? "Orgao estadual" : "Orgao federal",
    `2026-0${(index % 9) + 1}-10`,
    index % 3 === 0 ? "" : `2027-0${(index % 9) + 1}-10`,
    index % 5 === 0 ? "Em analise" : "Valido",
    `https://storage.supabase.co/propriedades/${prop[0]}/documento_${index + 1}.pdf`,
    "Documento simulado para fluxo de upload e importacao."
  ];
});

const supabaseRows = [
  ["item", "sugestao", "observacao"],
  ["tabela_principal", "propriedades_agricolas", "Tabela principal do cadastro."],
  ["tabela_contatos", "propriedade_contatos", "Relacionamento 1:N com propriedades_agricolas."],
  ["tabela_areas", "propriedade_areas", "Relacionamento 1:N com talhoes, glebas e areas."],
  ["tabela_documentos", "propriedade_documentos", "Relacionamento 1:N com arquivos e documentos."],
  ["primary_key", "id_propriedade", "Pode ser UUID ou chave controlada pelo ecossistema Genius."],
  ["foreign_keys", "id_propriedade", "Usada em contatos, areas e documentos."],
  ["sync_status", "pendente | validado | importado | erro", "Controle de envio para Supabase."],
  ["rls_sugerido", "por organizacao/unidade/propriedade", "Preparar para Row Level Security."],
  ["observacao", "Manter ids estaveis", "Evita duplicidade nas importacoes."]
];

const dicionarioRows = [
  ["tabela_sugerida", "campo", "tipo_sugerido_supabase", "obrigatorio", "chave_relacao", "validacao_lista", "descricao", "exemplo"],
  ["propriedades_agricolas", "id_propriedade", "text primary key", "Sim", "PK", "", "Identificador unico da propriedade.", "prop_0001"],
  ["propriedades_agricolas", "codigo_propriedade", "text unique", "Sim", "Unique", "", "Codigo humano de referencia.", "PA-0001"],
  ["propriedades_agricolas", "nome_propriedade", "text", "Sim", "", "", "Nome oficial ou operacional da propriedade.", "Fazenda Santa Clara"],
  ["propriedades_agricolas", "tipo_propriedade", "text", "Sim", "", "tipo_propriedade", "Classificacao operacional da propriedade.", "Fazenda"],
  ["propriedades_agricolas", "status_cadastro", "text", "Sim", "", "status_cadastro", "Estado do cadastro.", "Ativo"],
  ["propriedades_agricolas", "situacao_operacional", "text", "Nao", "", "situacao_operacional", "Condicao operacional atual.", "Em operacao"],
  ["propriedades_agricolas", "data_cadastro", "date", "Sim", "", "", "Data do cadastro inicial.", "2026-04-01"],
  ["propriedades_agricolas", "cpf_cnpj_proprietario", "text", "Nao", "", "", "Documento do proprietario ou entidade responsavel.", "04231876000110"],
  ["propriedades_agricolas", "nome_proprietario", "text", "Sim", "", "", "Nome do proprietario, possuidor, parceiro ou entidade.", "Agro Santa Clara Ltda"],
  ["propriedades_agricolas", "uf", "text", "Sim", "", "uf", "Unidade federativa.", "AM"],
  ["propriedades_agricolas", "municipio", "text", "Sim", "", "", "Municipio da propriedade.", "Manaus"],
  ["propriedades_agricolas", "latitude_sede", "numeric", "Nao", "", "", "Latitude decimal da sede ou ponto de referencia.", "-3.1190"],
  ["propriedades_agricolas", "longitude_sede", "numeric", "Nao", "", "", "Longitude decimal da sede ou ponto de referencia.", "-60.0210"],
  ["propriedades_agricolas", "area_total_ha", "numeric", "Nao", "", "", "Area total em hectares.", "1250.50"],
  ["propriedades_agricolas", "area_produtiva_ha", "numeric", "Nao", "", "", "Area produtiva em hectares.", "820.00"],
  ["propriedades_agricolas", "area_preservacao_ha", "numeric", "Nao", "", "", "Area de preservacao ou conservacao em hectares.", "310.00"],
  ["propriedades_agricolas", "sync_status", "text", "Sim", "", "sync_status", "Controle de importacao para Supabase.", "pendente"],
  ["propriedade_contatos", "id_contato", "text primary key", "Sim", "PK", "", "Identificador unico do contato.", "cont_0001"],
  ["propriedade_contatos", "id_propriedade", "text references propriedades_agricolas", "Sim", "FK", "", "Propriedade vinculada ao contato.", "prop_0001"],
  ["propriedade_areas", "id_area", "text primary key", "Sim", "PK", "", "Identificador unico da area, talhao ou gleba.", "area_0001"],
  ["propriedade_areas", "id_propriedade", "text references propriedades_agricolas", "Sim", "FK", "", "Propriedade vinculada a area.", "prop_0001"],
  ["propriedade_documentos", "id_documento", "text primary key", "Sim", "PK", "", "Identificador unico do documento.", "doc_0001"],
  ["propriedade_documentos", "id_propriedade", "text references propriedades_agricolas", "Sim", "FK", "", "Propriedade vinculada ao documento.", "prop_0001"]
];

const listasRows = [
  ["lista", "valor"],
  ["tipo_propriedade", "Fazenda"],
  ["tipo_propriedade", "Sitio"],
  ["tipo_propriedade", "Chacara"],
  ["tipo_propriedade", "Lote rural"],
  ["tipo_propriedade", "Comunidade agricola"],
  ["tipo_propriedade", "Unidade produtiva"],
  ["status_cadastro", "Ativo"],
  ["status_cadastro", "Inativo"],
  ["status_cadastro", "Em validacao"],
  ["status_cadastro", "Pendente"],
  ["situacao_operacional", "Em operacao"],
  ["situacao_operacional", "Em implantacao"],
  ["situacao_operacional", "Em regularizacao"],
  ["situacao_operacional", "Suspensa"],
  ["sim_nao", "Sim"],
  ["sim_nao", "Nao"],
  ["sim_nao", "Parcial"],
  ["sync_status", "pendente"],
  ["sync_status", "validado"],
  ["sync_status", "importado"],
  ["sync_status", "erro"],
  ["uf", "AM"],
  ["uf", "PA"],
  ["uf", "RO"]
];

addSheet("Cadastro_Propriedades", [cadastroHeaders, ...propriedades]);
addSheet("Contatos", [contatoHeaders, ...contatos]);
addSheet("Areas_Talhoes_Glebas", [areaHeaders, ...areas]);
addSheet("Documentos", [documentoHeaders, ...documentos]);
addSheet("Supabase_Mapeamento", supabaseRows);
addSheet("Dicionario_Campos", dicionarioRows);
addSheet("Listas_Validacao", listasRows);

const checks = workbook.worksheets.add("Checks");
checks.getRange("A1:B12").values = [
  ["check", "formula"],
  ["total_cadastros_preenchidos", "=COUNTA(Cadastro_Propriedades!C2:C11)"],
  ["sem_id_propriedade", "=COUNTBLANK(Cadastro_Propriedades!A2:A11)"],
  ["sem_nome_propriedade", "=COUNTBLANK(Cadastro_Propriedades!C2:C11)"],
  ["sem_status", "=COUNTBLANK(Cadastro_Propriedades!E2:E11)"],
  ["sem_municipio", "=COUNTBLANK(Cadastro_Propriedades!O2:O11)"],
  ["sem_uf", "=COUNTBLANK(Cadastro_Propriedades!N2:N11)"],
  ["area_total_informada", "=SUM(Cadastro_Propriedades!T2:T11)"],
  ["pendentes_sync", "=COUNTIF(Cadastro_Propriedades!AN2:AN11,\"pendente\")"],
  ["total_contatos", "=COUNTA(Contatos!A2:A11)"],
  ["total_areas", "=COUNTA(Areas_Talhoes_Glebas!A2:A11)"],
  ["total_documentos", "=COUNTA(Documentos!A2:A11)"]
];

const dashboard = workbook.worksheets.add("Resumo");
dashboard.getRange("A1:D16").values = [
  ["Cadastro de Propriedades Agricolas", "", "", ""],
  ["Uso", "Modelo com 10 cadastros simulados, filtros e propriedades de colunas para importacao futura no Supabase.", "", ""],
  ["Aba principal", "Cadastro_Propriedades", "", ""],
  ["Tabelas auxiliares", "Contatos, Areas_Talhoes_Glebas, Documentos", "", ""],
  ["Controle Supabase", "Supabase_Mapeamento, Dicionario_Campos e sync_status", "", ""],
  ["", "", "", ""],
  ["Indicador", "Valor", "Observacao", ""],
  ["Cadastros preenchidos", "=Checks!B2", "Conta nomes preenchidos", ""],
  ["IDs em branco", "=Checks!B3", "Devem ser zero antes da importacao", ""],
  ["Area total informada ha", "=Checks!B8", "Soma das areas totais", ""],
  ["Pendentes de sync", "=Checks!B9", "Registros ainda nao importados", ""],
  ["Contatos cadastrados", "=Checks!B10", "Aba Contatos", ""],
  ["Areas cadastradas", "=Checks!B11", "Aba Areas_Talhoes_Glebas", ""],
  ["Documentos cadastrados", "=Checks!B12", "Aba Documentos", ""],
  ["Status recomendado", "Validar, exportar CSV e importar Supabase", "", ""],
  ["Chave de integracao", "id_propriedade", "Usada como FK nas abas auxiliares", ""]
];

const inspect = await workbook.inspect({
  kind: "table",
  range: "Cadastro_Propriedades!A1:AN11",
  include: "values,formulas",
  tableMaxRows: 11,
  tableMaxCols: 40
});
console.log(inspect.ndjson);

const errors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "formula error scan"
});
console.log(errors.ndjson);

await workbook.render({ sheetName: "Resumo", range: "A1:D16", scale: 1 });
await workbook.render({ sheetName: "Cadastro_Propriedades", range: "A1:J11", scale: 1 });

await fs.mkdir(outputDir, { recursive: true });
const output = await SpreadsheetFile.exportXlsx(workbook);
await output.save(outputPath);

await addExcelEnhancements(outputPath);

console.log(`SAVED:${outputPath}`);
process.exit(0);

async function addExcelEnhancements(xlsxPath) {
  const sheetRefs = {
    "xl/worksheets/sheet1.xml": "A1:AN11",
    "xl/worksheets/sheet2.xml": "A1:J11",
    "xl/worksheets/sheet3.xml": "A1:L11",
    "xl/worksheets/sheet4.xml": "A1:J11",
    "xl/worksheets/sheet5.xml": "A1:C10",
    "xl/worksheets/sheet6.xml": "A1:H24",
    "xl/worksheets/sheet7.xml": "A1:B25",
    "xl/worksheets/sheet8.xml": "A1:B12"
  };

  const validations = {
    "xl/worksheets/sheet1.xml": [
      { sqref: "D2:D11", formula: "lista_tipo_propriedade" },
      { sqref: "E2:E11", formula: "lista_status_cadastro" },
      { sqref: "F2:F11", formula: "lista_situacao_operacional" },
      { sqref: "J2:J11", formula: '"Proprietario,Possuidor,Arrendatario,Parceiro,Cooperativa,Associacao"' },
      { sqref: "N2:N11", formula: "lista_uf" },
      { sqref: "Z2:Z11", formula: "lista_sim_nao_parcial" },
      { sqref: "AB2:AB11", formula: "lista_sim_nao_parcial" },
      { sqref: "AD2:AD11", formula: "lista_sim_nao_parcial" },
      { sqref: "AF2:AF11", formula: "lista_sim_nao_parcial" },
      { sqref: "AH2:AH11", formula: "lista_sim_nao_parcial" },
      { sqref: "AN2:AN11", formula: "lista_sync_status" }
    ],
    "xl/worksheets/sheet2.xml": [
      { sqref: "B2:B11", formula: "lista_id_propriedade" },
      { sqref: "C2:C11", formula: '"Proprietario,Responsavel tecnico,Administrativo,Financeiro,Operacional"' },
      { sqref: "D2:D11", formula: "lista_proprietarios" },
      { sqref: "I2:I11", formula: "lista_sim_nao" }
    ],
    "xl/worksheets/sheet3.xml": [
      { sqref: "B2:B11", formula: "lista_id_propriedade" },
      { sqref: "E2:E11", formula: '"Talhao,Gleba,Area produtiva,Reserva,Pasto,Infraestrutura"' },
      { sqref: "G2:G11", formula: '"Produtivo,Implantacao,Reserva,Pousio,Infraestrutura"' },
      { sqref: "K2:K11", formula: '"Ativo,Pendente,Inativo,Em revisao"' }
    ],
    "xl/worksheets/sheet4.xml": [
      { sqref: "B2:B11", formula: "lista_id_propriedade" },
      { sqref: "C2:C11", formula: '"CAR,CCIR,ITR,Matricula,Contrato,Licenca,Georreferenciamento,Declaracao,Associacao,Cadastro municipal"' },
      { sqref: "H2:H11", formula: '"Valido,Em analise,Vencido,Pendente,Reprovado"' }
    ]
  };

  const definedNames = [
    { name: "lista_id_propriedade", ref: "Cadastro_Propriedades!$A$2:$A$11" },
    { name: "lista_proprietarios", ref: "Cadastro_Propriedades!$I$2:$I$11" },
    { name: "lista_tipo_propriedade", ref: "Listas_Validacao!$B$2:$B$7" },
    { name: "lista_status_cadastro", ref: "Listas_Validacao!$B$8:$B$11" },
    { name: "lista_situacao_operacional", ref: "Listas_Validacao!$B$12:$B$15" },
    { name: "lista_sim_nao", ref: "Listas_Validacao!$B$16:$B$17" },
    { name: "lista_sim_nao_parcial", ref: "Listas_Validacao!$B$16:$B$18" },
    { name: "lista_sync_status", ref: "Listas_Validacao!$B$19:$B$22" },
    { name: "lista_uf", ref: "Listas_Validacao!$B$23:$B$25" }
  ];

  const buffer = await fs.readFile(xlsxPath);
  const zip = await JSZip.loadAsync(buffer);

  const workbookXmlPath = "xl/workbook.xml";
  const workbookFile = zip.file(workbookXmlPath);
  if (workbookFile) {
    let workbookXml = await workbookFile.async("string");
    workbookXml = workbookXml.replace(/<x:definedNames>[\s\S]*?<\/x:definedNames>/, "");
    const definedNamesXml = `<x:definedNames>${definedNames
      .map((item) => `<x:definedName name="${item.name}">${item.ref}</x:definedName>`)
      .join("")}</x:definedNames>`;
    const workbookInsertAt = workbookXml.search(/<x:(calcPr|extLst)\b/);
    if (workbookInsertAt >= 0) {
      workbookXml = `${workbookXml.slice(0, workbookInsertAt)}${definedNamesXml}${workbookXml.slice(workbookInsertAt)}`;
    } else {
      workbookXml = workbookXml.replace("</x:workbook>", `${definedNamesXml}</x:workbook>`);
    }
    zip.file(workbookXmlPath, workbookXml);
  }

  for (const [sheetXmlPath, ref] of Object.entries(sheetRefs)) {
    const file = zip.file(sheetXmlPath);
    if (!file) continue;
    let xml = await file.async("string");
    xml = xml.replace(/<x:autoFilter[^>]*\/>/g, "");
    xml = xml.replace(/<x:dataValidations[\s\S]*?<\/x:dataValidations>/g, "");
    const autoFilter = `<x:autoFilter ref="${ref}"/>`;
    const sheetValidations = validations[sheetXmlPath] ?? [];
    const dataValidations = sheetValidations.length
      ? `<x:dataValidations count="${sheetValidations.length}">${sheetValidations
          .map((item) => `<x:dataValidation type="list" allowBlank="1" showDropDown="0" showErrorMessage="1" errorTitle="Valor invalido" error="Selecione uma opcao da lista cadastrada." sqref="${item.sqref}"><x:formula1>${item.formula}</x:formula1></x:dataValidation>`)
          .join("")}</x:dataValidations>`
      : "";
    const insertAt = xml.search(/<x:(mergeCells|conditionalFormatting|dataValidations|hyperlinks|printOptions|pageMargins|pageSetup|headerFooter|drawing|legacyDrawing|tableParts)\b/);
    if (insertAt >= 0) {
      xml = `${xml.slice(0, insertAt)}${autoFilter}${dataValidations}${xml.slice(insertAt)}`;
    } else {
      xml = xml.replace("</x:worksheet>", `${autoFilter}${dataValidations}</x:worksheet>`);
    }
    zip.file(sheetXmlPath, xml);
  }

  const patched = await zip.generateAsync({
    type: "nodebuffer",
    compression: "DEFLATE",
    compressionOptions: { level: 6 }
  });
  await fs.writeFile(xlsxPath, patched);
}
