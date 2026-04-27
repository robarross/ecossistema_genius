import fs from "node:fs/promises";
import path from "node:path";

const modulePath = "E:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/genius_systems_modulares/01_A_Modulos_Administrativo_Corporativo/02_Mod_Gestao_Unidade_Agricola";
const moduleName = "Mod_Gestao_Unidade_Agricola";

const moduleFractals = [
  ["01_fractal_identidade_unidade", "Identidade da unidade", "Define codigo, nome, tipo, localizacao e identidade operacional da unidade agricola."],
  ["02_fractal_relacionamentos_unidade", "Relacionamentos da unidade", "Conecta unidade agricola com proprietarios, gestores, areas, documentos, ativos e modulos do ecossistema."],
  ["03_fractal_governanca_permissoes", "Governanca e permissoes", "Controla perfis, acessos, responsabilidades, autorizacoes e regras de governanca."],
  ["04_fractal_documental_juridico", "Documental e juridico", "Organiza documentos, certidoes, registros, contratos e evidencias juridicas da unidade."],
  ["05_fractal_operacional_status", "Status operacional", "Controla situacao operacional, produtiva, documental, estrutural e regulatoria da unidade."],
  ["06_fractal_integracao_ecossistema", "Integracao com ecossistema", "Publica e consome dados para producao, financeiro, fiscal, ambiental, dashboards, DataLake, Hub e APIs."],
  ["07_fractal_indicadores_dashboards", "Indicadores e dashboards", "Estrutura indicadores, metricas, visoes gerenciais e sinais de acompanhamento da unidade agricola."],
  ["08_fractal_inteligencia_automacoes", "Inteligencia e automacoes", "Habilita alertas, agentes, recomendacoes, regras, validacoes e automacoes futuras."]
];

const submodules = [
  ["01_sub_cadastro_unidades_agricolas", [
    ["01_fractal_dados_basicos_unidade", "Dados basicos da unidade", "Registra identificadores, nome, codigo, tipo, categoria e dados essenciais da unidade agricola."],
    ["02_fractal_localizacao_referencia_territorial", "Localizacao e referencia territorial", "Registra endereco, coordenadas, municipio, UF, comunidade, acesso e referencias territoriais."],
    ["03_fractal_classificacao_unidade", "Classificacao da unidade", "Classifica a unidade por tipo, porte, finalidade, uso predominante e perfil produtivo."],
    ["04_fractal_situacao_cadastral", "Situacao cadastral", "Controla status cadastral, pendencias, revisoes, validacoes e historico de atualizacao."],
    ["05_fractal_validacao_campos_obrigatorios", "Validacao de campos obrigatorios", "Define regras minimas de preenchimento, consistencia e liberacao para integracoes."],
    ["06_fractal_integracao_datalake_mapas_modulos", "Integracao DataLake mapas modulos", "Conecta o cadastro da unidade ao DataLake, mapas, Hub, dashboards e modulos dependentes."]
  ]],
  ["02_sub_proprietarios_possuidores", [
    ["01_fractal_cadastro_proprietarios", "Cadastro de proprietarios", "Registra proprietarios pessoas fisicas ou juridicas vinculados a unidade agricola."],
    ["02_fractal_cadastro_possuidores", "Cadastro de possuidores", "Registra possuidores, ocupantes, arrendatarios e demais titulares operacionais da unidade."],
    ["03_fractal_documentos_titulares", "Documentos dos titulares", "Organiza documentos pessoais, empresariais, fundiarios e cadastrais dos titulares."],
    ["04_fractal_vinculos_unidade_agricola", "Vinculos com unidade agricola", "Define tipo de vinculo, percentual, periodo, responsabilidade e status da relacao."],
    ["05_fractal_historico_titularidade", "Historico de titularidade", "Mantem historico de alteracoes, transferencias, substituicoes e revisoes de titularidade."],
    ["06_fractal_integracao_contratos_juridico_permissoes", "Integracao contratos juridico permissoes", "Integra titulares com contratos, juridico, fiscal, permissoes, usuarios e auditoria."]
  ]],
  ["03_sub_responsaveis_gestores", [
    ["01_fractal_cadastro_responsaveis", "Cadastro de responsaveis", "Registra responsaveis administrativos, tecnicos, operacionais e financeiros."],
    ["02_fractal_funcoes_papeis_operacionais", "Funcoes e papeis operacionais", "Define papeis, funcoes, alcadas e responsabilidades praticas na unidade."],
    ["03_fractal_responsabilidade_tecnica", "Responsabilidade tecnica", "Controla responsaveis tecnicos, registros, areas de atuacao e vigencia."],
    ["04_fractal_responsabilidade_administrativa", "Responsabilidade administrativa", "Organiza responsaveis por documentos, compras, contratos, prestacao de contas e rotina administrativa."],
    ["05_fractal_niveis_autorizacao", "Niveis de autorizacao", "Define niveis de aprovacao, acesso, decisao e assinatura por perfil."],
    ["06_fractal_integracao_tarefas_projetos_cowork", "Integracao tarefas projetos cowork", "Conecta responsaveis com tarefas, projetos, workspace, cowork, alertas e permissoes."]
  ]],
  ["04_sub_territorios_areas_producao", [
    ["01_fractal_areas_produtivas", "Areas produtivas", "Registra areas produtivas vinculadas a unidade agricola e sua situacao de uso."],
    ["02_fractal_glebas_talhoes", "Glebas e talhoes", "Organiza glebas, talhoes, codigos, dimensoes e relacionamentos territoriais."],
    ["03_fractal_uso_atual_area", "Uso atual da area", "Registra uso atual, cultura, atividade, ocupacao, restricoes e disponibilidade."],
    ["04_fractal_potencial_produtivo", "Potencial produtivo", "Avalia aptidao, capacidade produtiva, limitacoes e oportunidades de uso."],
    ["05_fractal_historico_ocupacao_uso", "Historico de ocupacao e uso", "Mantem historico de culturas, atividades, rotacoes, pausas e alteracoes de uso."],
    ["06_fractal_integracao_producao_geo_precisao", "Integracao producao geo precisao", "Integra areas com producao vegetal, animal, georreferenciamento e agricultura de precisao."]
  ]],
  ["05_sub_limites_acessos", [
    ["01_fractal_limites_fisicos_unidade", "Limites fisicos da unidade", "Registra limites, confrontacoes, cercas, marcos, pontos e referencias fisicas."],
    ["02_fractal_acessos_internos_externos", "Acessos internos e externos", "Mapeia entradas, saidas, acessos internos, acessos externos e condicoes de trafego."],
    ["03_fractal_estradas_ramais_porteiras", "Estradas ramais porteiras", "Registra estradas, ramais, porteiras, pontes, passagens e pontos de controle."],
    ["04_fractal_pontos_criticos_acesso", "Pontos criticos de acesso", "Identifica riscos, gargalos, bloqueios, manutencoes e vulnerabilidades de acesso."],
    ["05_fractal_controle_circulacao", "Controle de circulacao", "Controla circulacao de pessoas, veiculos, maquinas, cargas e visitantes."],
    ["06_fractal_integracao_seguranca_logistica_manutencao", "Integracao seguranca logistica manutencao", "Integra acessos com seguranca, logistica, mapas, manutencao e monitoramento."]
  ]],
  ["06_sub_documentacao_unidade", [
    ["01_fractal_documentos_fundiarios", "Documentos fundiarios", "Organiza matriculas, posses, contratos, CCIR e demais registros fundiarios."],
    ["02_fractal_documentos_ambientais", "Documentos ambientais", "Organiza CAR, licencas, autorizacoes, reservas, APPs e documentos ambientais."],
    ["03_fractal_documentos_fiscais_cadastrais", "Documentos fiscais e cadastrais", "Organiza ITR, inscricoes, certidoes fiscais, cadastros oficiais e comprovantes."],
    ["04_fractal_validades_vencimentos", "Validades e vencimentos", "Controla prazos, vencimentos, alertas, renovacoes e situacao documental."],
    ["05_fractal_uploads_evidencias", "Uploads e evidencias", "Gerencia arquivos, anexos, evidencias, URLs, metadados e storage."],
    ["06_fractal_integracao_regularizacao_fiscal_storage", "Integracao regularizacao fiscal storage", "Integra documentos com regularizacao fundiaria, ambiental, fiscal, Supabase e storage."]
  ]],
  ["07_sub_base_ativos_estruturais_unidade", [
    ["01_fractal_estruturas_existentes", "Estruturas existentes", "Registra estruturas, edificacoes, instalacoes e bases fisicas existentes na unidade."],
    ["02_fractal_benfeitorias_instalacoes_fixas", "Benfeitorias e instalacoes fixas", "Organiza benfeitorias, cercas, currais, galpoes, reservatorios e instalacoes fixas."],
    ["03_fractal_equipamentos_fixos_unidade", "Equipamentos fixos da unidade", "Registra equipamentos instalados de forma fixa ou estrutural na unidade agricola."],
    ["04_fractal_estado_conservacao", "Estado de conservacao", "Avalia conservacao, risco, manutencao necessaria e prioridade de intervencao."],
    ["05_fractal_relacao_areas_uso_operacional", "Relacao com areas e uso operacional", "Relaciona ativos estruturais com areas, talhoes, operacoes e uso produtivo."],
    ["06_fractal_integracao_construcoes_manutencao", "Integracao construcoes manutencao", "Serve de base para Construcoes Rurais e integra com Manutencao, ativos e dashboards."]
  ]],
  ["08_sub_chaves_permissoes_operacionais", [
    ["01_fractal_chaves_fisicas", "Chaves fisicas", "Controla chaves fisicas, copias, responsaveis, locais e historico de entrega."],
    ["02_fractal_acessos_digitais", "Acessos digitais", "Controla senhas, acessos, credenciais, sistemas, tokens e autorizacoes digitais."],
    ["03_fractal_perfis_operacionais", "Perfis operacionais", "Define perfis de usuario, niveis de acesso e responsabilidades operacionais."],
    ["04_fractal_autorizacoes_area_funcao", "Autorizacoes por area ou funcao", "Regula acessos conforme area, funcao, modulo, unidade e tipo de operacao."],
    ["05_fractal_historico_acesso", "Historico de acesso", "Registra logs, retiradas, devolucoes, acessos concedidos e acessos revogados."],
    ["06_fractal_integracao_seguranca_cowork_workspace", "Integracao seguranca cowork workspace", "Integra chaves e permissoes com seguranca da informacao, cowork, workspace e usuarios."]
  ]],
  ["09_sub_status_operacional_unidade", [
    ["01_fractal_status_geral_unidade", "Status geral da unidade", "Define status consolidado da unidade agricola e sua prontidao operacional."],
    ["02_fractal_status_produtivo", "Status produtivo", "Controla condicao produtiva, areas ativas, ciclos e disponibilidade de producao."],
    ["03_fractal_status_documental", "Status documental", "Consolida pendencias, validades, riscos e aprovacao documental."],
    ["04_fractal_status_estrutural", "Status estrutural", "Consolida situacao de estruturas, benfeitorias, acessos e ativos fixos."],
    ["05_fractal_status_risco_pendencia", "Status de risco e pendencia", "Identifica riscos, bloqueios, inconformidades, alertas e tarefas pendentes."],
    ["06_fractal_integracao_dashboards_alertas_planejamento", "Integracao dashboards alertas planejamento", "Publica status para dashboards, alertas, planejamento, tarefas e agentes."]
  ]],
  ["10_sub_prestacao_contas_unidade", [
    ["01_fractal_resumo_operacional_unidade", "Resumo operacional da unidade", "Gera visao resumida da operacao, status, indicadores e eventos relevantes."],
    ["02_fractal_evidencias_suporte", "Evidencias e suporte", "Organiza evidencias, comprovantes, fotos, documentos e anexos de suporte."],
    ["03_fractal_indicadores_conformidade", "Indicadores de conformidade", "Calcula indicadores de conformidade cadastral, documental, estrutural e operacional."],
    ["04_fractal_pendencias_abertas", "Pendencias abertas", "Lista pendencias, responsaveis, prazos, prioridades e status de resolucao."],
    ["05_fractal_historico_atualizacoes", "Historico de atualizacoes", "Mantem trilha de alteracoes, revisoes, aprovacoes e auditoria da unidade."],
    ["06_fractal_integracao_financeiro_admin_auditoria", "Integracao financeiro administrativo auditoria", "Integra prestacao de contas com financeiro, administrativo, dashboards, auditoria e DataLake."]
  ]]
];

function tableName(folder) {
  return folder.replace(/^\d+_fractal_/, "fractal_");
}

async function writeFractalFiles(fractalPath, folder, title, description, scope, parentSubmodule) {
  await fs.mkdir(fractalPath, { recursive: true });

  await fs.writeFile(path.join(fractalPath, "README.md"), `# ${folder}

## Nome
${title}

## Funcao
${description}

## Escopo
${scope}

## Padrao plug and play
Este fractal possui contrato, manifesto, schema de dados e eventos proprios para poder ser ativado, reutilizado, versionado e integrado aos demais modulos do ecossistema Genius.

## Entradas esperadas
- Dados cadastrais ou operacionais relacionados ao escopo do fractal.
- Identificadores do modulo, submodulo, unidade agricola e usuario responsavel.
- Eventos consumidos de outros fractais, quando aplicavel.

## Saidas geradas
- Registros validados para uso interno e integracao.
- Eventos publicados para Hub, DataLake, dashboards e APIs.
- Indicadores e status para acompanhamento operacional.
`, "utf8");

  const manifest = {
    nome_fractal: folder,
    titulo: title,
    descricao: description,
    status: "proposto",
    versao: "0.1.0",
    escopo: scope,
    modulo_pai: moduleName,
    submodulo_pai: parentSubmodule,
    plug_and_play: true,
    entradas_esperadas: ["dados_origem", "id_unidade_agricola", "id_usuario_responsavel", "contexto_operacional"],
    saidas_geradas: ["registro_validado", "evento_publicado", "indicador_atualizado"],
    depende_de: ["Mod_Gestao_Genius_Hub", "Mod_Gestao_Dados_DataLake"],
    integra_com: ["Mod_Gestao_Dashboards_BI", "Mod_Gestao_Integracoes_APIs", "Mod_Gestao_Unidade_Agricola"],
    permissoes_perfis: ["admin_ecossistema", "gestor_unidade_agricola", "operador_autorizado"],
    dashboards_proprios: ["dashboard_status_fractal", "dashboard_pendencias_fractal"]
  };
  await fs.writeFile(path.join(fractalPath, "manifesto_fractal.json"), `${JSON.stringify(manifest, null, 2)}\n`, "utf8");

  await fs.writeFile(path.join(fractalPath, "contrato_integracao.md"), `# Contrato de Integracao - ${folder}

## Objetivo
${description}

## Entradas
- id_unidade_agricola
- id_registro_origem
- dados_origem
- usuario_responsavel
- data_evento

## Saidas
- registro_validado
- status_processamento
- evento_publicado
- payload_integracao

## Eventos publicados
- unidade_agricola.${folder}.criado
- unidade_agricola.${folder}.atualizado
- unidade_agricola.${folder}.validado

## Eventos consumidos
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- usuario.permissao_atualizada

## Integracoes obrigatorias
- Genius Hub
- DataLake
- Integracoes APIs
- Dashboards BI

## Regra plug and play
O fractal deve funcionar de forma independente dentro do seu submodulo, mas publicar eventos e dados padronizados para permitir integracao com outros fractais, submodulos e modulos.
`, "utf8");

  const schema = {
    tabela_sugerida: tableName(folder),
    primary_key: "id_fractal_registro",
    campos: [
      { nome: "id_fractal_registro", tipo: "uuid", obrigatorio: true, descricao: "Identificador unico do registro do fractal." },
      { nome: "id_unidade_agricola", tipo: "uuid/text", obrigatorio: true, descricao: "Referencia da unidade agricola." },
      { nome: "id_origem", tipo: "text", obrigatorio: false, descricao: "Referencia externa ou registro de origem." },
      { nome: "status", tipo: "text", obrigatorio: true, descricao: "Status do registro dentro do fractal." },
      { nome: "payload", tipo: "jsonb", obrigatorio: false, descricao: "Dados flexiveis do fractal." },
      { nome: "created_at", tipo: "timestamptz", obrigatorio: true, descricao: "Data de criacao." },
      { nome: "updated_at", tipo: "timestamptz", obrigatorio: true, descricao: "Data de atualizacao." },
      { nome: "sync_status", tipo: "text", obrigatorio: true, descricao: "Status de sincronizacao com Supabase/DataLake." }
    ],
    relacionamentos: [
      { campo: "id_unidade_agricola", referencia: "propriedades_agricolas.id_unidade_agricola" }
    ]
  };
  await fs.writeFile(path.join(fractalPath, "schema_dados.json"), `${JSON.stringify(schema, null, 2)}\n`, "utf8");

  await fs.writeFile(path.join(fractalPath, "eventos_fractal.md"), `# Eventos do Fractal - ${folder}

## Publica
- unidade_agricola.${folder}.criado
- unidade_agricola.${folder}.atualizado
- unidade_agricola.${folder}.validado
- unidade_agricola.${folder}.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
\`\`\`json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.${folder}.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "${moduleName}",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
\`\`\`
`, "utf8");
}

const centralPath = path.join(modulePath, "1_DNA_Processo", "fractais_modulo");
for (const [folder, title, description] of moduleFractals) {
  await writeFractalFiles(path.join(centralPath, folder), folder, title, description, "fractal_central_modulo", "N/A");
}

for (const [submodule, fractals] of submodules) {
  const fractalsPath = path.join(modulePath, "1_DNA_Processo", "submodulos", submodule, "fractais");
  for (const [folder, title, description] of fractals) {
    await writeFractalFiles(path.join(fractalsPath, folder), folder, title, description, "fractal_submodulo", submodule);
  }
}

const catalog = [
  "# Catalogo de Fractais - Mod_Gestao_Unidade_Agricola",
  "",
  "Este catalogo lista os fractais centrais do modulo e os fractais de cada submodulo.",
  "",
  "## Fractais centrais do modulo",
  ...moduleFractals.map(([folder, , description]) => `- ${folder}: ${description}`),
  "",
  "## Fractais por submodulo",
  ...submodules.flatMap(([submodule, fractals]) => [
    "",
    `### ${submodule}`,
    ...fractals.map(([folder, , description]) => `- ${folder}: ${description}`)
  ])
].join("\n");
await fs.writeFile(path.join(modulePath, "CATALOGO_FRACTAIS_Mod_Gestao_Unidade_Agricola.md"), `${catalog}\n`, "utf8");

const allFractals = [
  ...moduleFractals.map(([folder]) => path.join(centralPath, folder)),
  ...submodules.flatMap(([submodule, fractals]) => fractals.map(([folder]) => path.join(modulePath, "1_DNA_Processo", "submodulos", submodule, "fractais", folder)))
];
const requiredFiles = ["README.md", "manifesto_fractal.json", "contrato_integracao.md", "schema_dados.json", "eventos_fractal.md"];
let missing = 0;
for (const fractalPath of allFractals) {
  for (const file of requiredFiles) {
    try {
      await fs.access(path.join(fractalPath, file));
    } catch {
      missing += 1;
    }
  }
}

console.log(`CENTRAIS=${moduleFractals.length}`);
console.log(`SUBMODULOS=${submodules.reduce((sum, [, fractals]) => sum + fractals.length, 0)}`);
console.log(`TOTAL_FRACTAIS=${allFractals.length}`);
console.log(`ARQUIVOS_ESPERADOS=${allFractals.length * requiredFiles.length}`);
console.log(`ARQUIVOS_AUSENTES=${missing}`);
