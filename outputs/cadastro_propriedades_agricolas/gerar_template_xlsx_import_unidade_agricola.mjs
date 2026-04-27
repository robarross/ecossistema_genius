import path from "node:path";
import fs from "node:fs/promises";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const outputPath = "E:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/genius_systems_modulares/01_A_Modulos_Administrativo_Corporativo/02_Mod_Gestao_Unidade_Agricola/4_EXEC_Execucao/imports/template_importacao_unidades_agricolas.xlsx";

const headers = [
  "lote_importacao",
  "linha_origem",
  "codigo_unidade",
  "nome_unidade",
  "tipo_unidade",
  "status_cadastro",
  "situacao_operacional",
  "uf",
  "municipio",
  "latitude_sede",
  "longitude_sede",
  "area_total_ha",
  "proprietario_nome",
  "proprietario_documento",
  "telefone_principal",
  "email_principal",
  "observacoes"
];

const rows = [
  headers,
  ["lote_planilha_robusta_001", 1, "PA-IMP-0002", "Fazenda Importada Completa", "Fazenda", "Ativo", "Em operacao", "AM", "Manaus", -3.13, -60.03, 940.25, "Produtor Completo", "00000000000272", "+55 92 99999-2002", "completo@genius.local", "Linha completa importada por planilha"],
  ["lote_planilha_robusta_001", 2, "PA-IMP-0003", "Sitio Importado Modelo", "Sitio", "Ativo", "Em implantacao", "AM", "Iranduba", -3.28, -60.18, 72.4, "Produtor Modelo", "00000000000353", "+55 92 99999-2003", "modelo@genius.local", "Segunda linha para testar lote com mais de um registro"]
];

const dictRows = [
  ["campo", "obrigatorio", "descricao"],
  ["lote_importacao", "Sim", "Identifica o lote de importacao."],
  ["linha_origem", "Nao", "Linha original da planilha."],
  ["codigo_unidade", "Sim", "Codigo unico da unidade agricola."],
  ["nome_unidade", "Sim", "Nome da unidade agricola."],
  ["tipo_unidade", "Nao", "Fazenda, Sitio, Chacara, Lote rural etc."],
  ["status_cadastro", "Nao", "Ativo, Pendente, Em validacao."],
  ["situacao_operacional", "Nao", "Em operacao, Em implantacao, Em regularizacao."],
  ["uf", "Nao", "Unidade federativa."],
  ["municipio", "Nao", "Municipio."],
  ["latitude_sede", "Nao", "Latitude decimal."],
  ["longitude_sede", "Nao", "Longitude decimal."],
  ["area_total_ha", "Nao", "Area total em hectares."],
  ["proprietario_nome", "Nao", "Nome do proprietario ou responsavel."],
  ["proprietario_documento", "Nao", "CPF/CNPJ/documento do proprietario."],
  ["telefone_principal", "Nao", "Telefone principal."],
  ["email_principal", "Nao", "Email principal."],
  ["observacoes", "Nao", "Observacoes livres."]
];

const wb = Workbook.create();
const sheet = wb.worksheets.add("import_unidades");
sheet.getRange(`A1:Q${rows.length}`).values = rows;

const dict = wb.worksheets.add("dicionario_campos");
dict.getRange(`A1:C${dictRows.length}`).values = dictRows;

const instructions = wb.worksheets.add("instrucoes");
instructions.getRange("A1:B8").values = [
  ["Uso", "Preencher a aba import_unidades e exportar como CSV UTF-8."],
  ["Destino Supabase", "unidade_agricola.import_planilha_unidades_agricolas"],
  ["Processar lote", "select * from unidade_agricola.processar_importacao_planilha_unidades_agricolas('lote_planilha_robusta_001');"],
  ["Prevalidar lote", "select * from unidade_agricola.prevalidar_lote_importacao_planilha_unidades('lote_planilha_robusta_001');"],
  ["Campos obrigatorios", "lote_importacao, codigo_unidade, nome_unidade"],
  ["Numeros", "Usar ponto decimal em latitude, longitude e area_total_ha."],
  ["Status recomendado", "Ativo ou Pendente"],
  ["Observacao", "Manter os nomes das colunas exatamente iguais."]
];

const output = await SpreadsheetFile.exportXlsx(wb);
await fs.mkdir(path.dirname(outputPath), { recursive: true });
await output.save(outputPath);
console.log(`SAVED:${outputPath}`);
