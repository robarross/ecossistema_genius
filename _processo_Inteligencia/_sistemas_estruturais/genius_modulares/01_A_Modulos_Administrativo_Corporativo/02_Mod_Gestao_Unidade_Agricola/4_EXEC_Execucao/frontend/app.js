const config = window.GENIUS_SUPABASE_CONFIG || {};

const state = {
  view: "dashboard",
  units: [],
  selectedCode: null,
  selectedPlugPlayCode: "todos",
  selectedSubmodule: "todos",
  selectedFractal: "todos",
  workspaceContextPending: false,
  editingDraft: null,
  sheetType: "unidade",
  sheetRows: [],
  data: {}
};

const sheetSchemas = {
  unidade: {
    title: "Modo Planilha - Unidade Agrícola",
    key: "genius.unidade_agricola.cadastros_unidade",
    columns: ["codigo_unidade", "nome_unidade", "tipo_unidade", "status_cadastro", "situacao_operacional", "uf", "municipio", "area_total_ha", "latitude_sede", "longitude_sede", "observacoes"]
  },
  proprietario: {
    title: "Modo Planilha - Proprietários/Possuidores",
    key: "genius.unidade_agricola.cadastros_proprietarios",
    columns: ["codigo_unidade", "nome_titular", "tipo_vinculo", "documento", "participacao_percentual", "telefone", "email", "status_vinculo", "observacoes"]
  },
  responsavel: {
    title: "Modo Planilha - Responsáveis/Gestores",
    key: "genius.unidade_agricola.cadastros_responsaveis",
    columns: ["codigo_unidade", "nome_responsavel", "tipo_responsabilidade", "cargo_funcao", "nivel_autorizacao", "principal", "telefone", "email", "observacoes"]
  }
};

const submodules = {
  todos: "Todos os submódulos",
  "01_sub_cadastro_unidades_agricolas": "01 - Cadastro de Unidades Agrícolas",
  "02_sub_proprietarios_possuidores": "02 - Proprietários e Possuidores",
  "03_sub_responsaveis_gestores": "03 - Responsáveis e Gestores",
  "04_sub_territorios_areas_producao": "04 - Territórios e Áreas de Produção",
  "05_sub_limites_acessos": "05 - Limites e Acessos",
  "06_sub_documentacao_unidade": "06 - Documentação da Unidade",
  "07_sub_base_ativos_estruturais_unidade": "07 - Base de Ativos Estruturais",
  "08_sub_chaves_permissoes_operacionais": "08 - Chaves e Permissões Operacionais",
  "09_sub_status_operacional_unidade": "09 - Status Operacional da Unidade",
  "10_sub_prestacao_contas_unidade": "10 - Prestação de Contas da Unidade"
};

const fractalsBySubmodule = {
  "01_sub_cadastro_unidades_agricolas": {
    "01_fractal_dados_basicos_unidade": "01 - Dados Básicos da Unidade",
    "02_fractal_localizacao_referencia_territorial": "02 - Localização e Referência Territorial",
    "03_fractal_classificacao_unidade": "03 - Classificação da Unidade",
    "04_fractal_situacao_cadastral": "04 - Situação Cadastral",
    "05_fractal_validacao_campos_obrigatorios": "05 - Validação de Campos Obrigatórios",
    "06_fractal_integracao_datalake_mapas_modulos": "06 - Integração DataLake, Mapas e Módulos"
  },
  "02_sub_proprietarios_possuidores": {
    "01_fractal_cadastro_proprietarios": "01 - Cadastro de Proprietários",
    "02_fractal_cadastro_possuidores": "02 - Cadastro de Possuidores",
    "03_fractal_documentos_titulares": "03 - Documentos dos Titulares",
    "04_fractal_vinculos_unidade_agricola": "04 - Vínculos com a Unidade Agrícola",
    "05_fractal_historico_titularidade": "05 - Histórico de Titularidade",
    "06_fractal_integracao_contratos_juridico_permissoes": "06 - Integração Contratos, Jurídico e Permissões"
  },
  "03_sub_responsaveis_gestores": {
    "01_fractal_cadastro_responsaveis": "01 - Cadastro de Responsáveis",
    "02_fractal_funcoes_papeis_operacionais": "02 - Funções e Papéis Operacionais",
    "03_fractal_responsabilidade_tecnica": "03 - Responsabilidade Técnica",
    "04_fractal_responsabilidade_administrativa": "04 - Responsabilidade Administrativa",
    "05_fractal_niveis_autorizacao": "05 - Níveis de Autorização",
    "06_fractal_integracao_tarefas_projetos_cowork": "06 - Integração Tarefas, Projetos e Cowork"
  },
  "04_sub_territorios_areas_producao": {
    "01_fractal_areas_produtivas": "01 - Áreas Produtivas",
    "02_fractal_glebas_talhoes": "02 - Glebas e Talhões",
    "03_fractal_uso_atual_area": "03 - Uso Atual da Área",
    "04_fractal_potencial_produtivo": "04 - Potencial Produtivo",
    "05_fractal_historico_ocupacao_uso": "05 - Histórico de Ocupação e Uso",
    "06_fractal_integracao_producao_geo_precisao": "06 - Integração Produção, Geo e Precisão"
  },
  "05_sub_limites_acessos": {
    "01_fractal_limites_fisicos_unidade": "01 - Limites Físicos da Unidade",
    "02_fractal_acessos_internos_externos": "02 - Acessos Internos e Externos",
    "03_fractal_estradas_ramais_porteiras": "03 - Estradas, Ramais e Porteiras",
    "04_fractal_pontos_criticos_acesso": "04 - Pontos Críticos de Acesso",
    "05_fractal_controle_circulacao": "05 - Controle de Circulação",
    "06_fractal_integracao_seguranca_logistica_manutencao": "06 - Integração Segurança, Logística e Manutenção"
  },
  "06_sub_documentacao_unidade": {
    "01_fractal_documentos_fundiarios": "01 - Documentos Fundiários",
    "02_fractal_documentos_ambientais": "02 - Documentos Ambientais",
    "03_fractal_documentos_fiscais_cadastrais": "03 - Documentos Fiscais e Cadastrais",
    "04_fractal_validades_vencimentos": "04 - Validades e Vencimentos",
    "05_fractal_uploads_evidencias": "05 - Uploads e Evidências",
    "06_fractal_integracao_regularizacao_fiscal_storage": "06 - Integração Regularização, Fiscal e Storage"
  },
  "07_sub_base_ativos_estruturais_unidade": {
    "01_fractal_estruturas_existentes": "01 - Estruturas Existentes",
    "02_fractal_benfeitorias_instalacoes_fixas": "02 - Benfeitorias e Instalações Fixas",
    "03_fractal_equipamentos_fixos_unidade": "03 - Equipamentos Fixos da Unidade",
    "04_fractal_estado_conservacao": "04 - Estado de Conservação",
    "05_fractal_relacao_areas_uso_operacional": "05 - Relação com Áreas de Uso Operacional",
    "06_fractal_integracao_construcoes_manutencao": "06 - Integração Construções e Manutenção"
  },
  "08_sub_chaves_permissoes_operacionais": {
    "01_fractal_chaves_fisicas": "01 - Chaves Físicas",
    "02_fractal_acessos_digitais": "02 - Acessos Digitais",
    "03_fractal_perfis_operacionais": "03 - Perfis Operacionais",
    "04_fractal_autorizacoes_area_funcao": "04 - Autorizações por Área e Função",
    "05_fractal_historico_acesso": "05 - Histórico de Acesso",
    "06_fractal_integracao_seguranca_cowork_workspace": "06 - Integração Segurança, Cowork e Workspace"
  },
  "09_sub_status_operacional_unidade": {
    "01_fractal_status_geral_unidade": "01 - Status Geral da Unidade",
    "02_fractal_status_produtivo": "02 - Status Produtivo",
    "03_fractal_status_documental": "03 - Status Documental",
    "04_fractal_status_estrutural": "04 - Status Estrutural",
    "05_fractal_status_risco_pendencia": "05 - Status de Risco e Pendência",
    "06_fractal_integracao_dashboards_alertas_planejamento": "06 - Integração Dashboards, Alertas e Planejamento"
  },
  "10_sub_prestacao_contas_unidade": {
    "01_fractal_resumo_operacional_unidade": "01 - Resumo Operacional da Unidade",
    "02_fractal_evidencias_suporte": "02 - Evidências de Suporte",
    "03_fractal_indicadores_conformidade": "03 - Indicadores de Conformidade",
    "04_fractal_pendencias_abertas": "04 - Pendências Abertas",
    "05_fractal_historico_atualizacoes": "05 - Histórico de Atualizações",
    "06_fractal_integracao_financeiro_admin_auditoria": "06 - Integração Financeiro, Administrativo e Auditoria"
  }
};

const titles = {
  dashboard: ["Dashboard", "Visão executiva do módulo Gestão da Unidade Agrícola."],
  workspace: ["Workspace", "Ambiente de contexto, Cowork, submódulos e fractais do módulo."],
  liberacao: ["Liberação Plug and Play", "Prova operacional de que o módulo está pronto para conversar com o Ecossistema Genius."],
  cadastros: ["Cadastros", "Entrada e manutenção dos cadastros estruturantes da unidade agrícola."],
  gerenciamento: ["Gerenciamento do Módulo", "Governança, contratos, status plug and play e encaixe na Plataforma Genius."],
  agentes: ["Agentes de IA", "Agentes previstos para validação, auditoria, importação e integração do módulo."],
  ferramentas: ["Ferramentas", "Ferramentas operacionais para apoiar execução, validação e monitoramento."],
  relatorios: ["Relatórios", "Relatórios próprios do módulo e bases para dashboards do ecossistema."],
  bancoDados: ["Banco de Dados", "Schema, views, eventos e status das integrações com Supabase."],
  configuracoes: ["Configurações", "Conexão, contexto, permissões e preparação para a Plataforma Genius."],
  unidades: ["Unidades", "Unidades prontas, bloqueadas e liberadas para o ecossistema."],
  detalhe: ["Detalhe da Unidade", "Proprietários, responsáveis, áreas e eventos por unidade."],
  auditoria: ["Auditoria", "Qualidade dos dados, pendências e bloqueios."],
  importacoes: ["Importações", "Status dos lotes de planilha e submódulos."]
};

const views = {
  dashboard: document.querySelector("#dashboardView"),
  workspace: document.querySelector("#workspaceView"),
  liberacao: document.querySelector("#liberacaoView"),
  cadastros: document.querySelector("#cadastrosView"),
  gerenciamento: document.querySelector("#gerenciamentoView"),
  agentes: document.querySelector("#agentesView"),
  ferramentas: document.querySelector("#ferramentasView"),
  relatorios: document.querySelector("#relatoriosView"),
  bancoDados: document.querySelector("#bancoDadosView"),
  configuracoes: document.querySelector("#configuracoesView"),
  unidades: document.querySelector("#unidadesView"),
  detalhe: document.querySelector("#detalheView"),
  auditoria: document.querySelector("#auditoriaView"),
  importacoes: document.querySelector("#importacoesView")
};

const gerenciamentoViews = ["gerenciamento", "unidades", "detalhe", "auditoria", "importacoes"];
const configuracoesViews = ["configuracoes", "bancoDados"];
const workspaceViews = ["workspace", "liberacao"];

document.querySelectorAll(".nav-item").forEach((button) => {
  button.addEventListener("click", () => requestSidebarView(button.dataset.view));
});
document.querySelectorAll(".section-tab[data-view-target]").forEach((button) => {
  button.addEventListener("click", () => setView(button.dataset.viewTarget));
});
document.querySelectorAll(".cadastro-tabs .section-tab").forEach((button) => {
  button.addEventListener("click", () => setCadastroPanel(button.dataset.cadastroTarget));
});

document.querySelector("#refreshButton").addEventListener("click", handleRefreshClick);
document.querySelector("#agentChatToggle").addEventListener("click", toggleAgentChat);
document.querySelector("#agentChatForm").addEventListener("submit", handleAgentChatSubmit);
document.querySelectorAll(".agent-panel-tab").forEach((button) => {
  button.addEventListener("click", () => setAgentPanel(button.dataset.agentPanel));
});
document.querySelector("#cadastroUnidadeForm").addEventListener("submit", handleCadastroUnidadeSubmit);
document.querySelector("#cadastroProprietarioForm").addEventListener("submit", handleCadastroProprietarioSubmit);
document.querySelector("#cadastroResponsavelForm").addEventListener("submit", handleCadastroResponsavelSubmit);
document.querySelector("#limparCadastroUnidade").addEventListener("click", () => document.querySelector("#cadastroUnidadeForm").reset());
document.querySelector("#limparCadastroProprietario").addEventListener("click", () => document.querySelector("#cadastroProprietarioForm").reset());
document.querySelector("#limparCadastroResponsavel").addEventListener("click", () => document.querySelector("#cadastroResponsavelForm").reset());
document.querySelector("#closePreviewButton").addEventListener("click", closeA4Preview);
document.querySelector("#printPreviewButton").addEventListener("click", printA4Preview);
document.querySelector("#generatePdfButton").addEventListener("click", printA4Preview);
document.querySelector("#closeSheetButton").addEventListener("click", closeSheetMode);
document.querySelector("#addSheetRowButton").addEventListener("click", addSheetRow);
document.querySelector("#saveSheetButton").addEventListener("click", saveSheetRows);
document.querySelector("#importSheetButton").addEventListener("click", () => document.querySelector("#sheetImportInput").click());
document.querySelector("#printSheetButton").addEventListener("click", printSheetMode);
document.querySelector("#sheetImportInput").addEventListener("change", importSheetFile);
document.querySelectorAll("[data-sheet-type]").forEach((button) => {
  button.addEventListener("click", () => openSheetMode(button.dataset.sheetType));
});
document.querySelector("#submoduleSelect").addEventListener("change", (event) => {
  state.selectedSubmodule = event.target.value;
  state.selectedFractal = "todos";
  fillFractalSelect();
  updateActiveSubmodule();
  markWorkspaceContextPending();
});
document.querySelector("#fractalSelect").addEventListener("change", (event) => {
  state.selectedFractal = event.target.value;
  updateActiveFractal();
  markWorkspaceContextPending();
});
document.querySelector("#unitSelect").addEventListener("change", (event) => {
  state.selectedCode = event.target.value;
  renderDetail();
});
document.querySelector("#plugPlayUnitFilter").addEventListener("change", (event) => {
  state.selectedPlugPlayCode = event.target.value;
  renderPlugPlayRelease();
});
document.querySelector("#unitSearch").addEventListener("input", renderUnits);
document.addEventListener("click", handleDraftAction);
document.addEventListener("click", handleDatabaseSheetAction);

loadAll();
fillSubmoduleSelect();
fillFractalSelect();
updateActiveSubmodule();
updateActiveFractal();
renderCadastroDrafts();
renderProprietarioDrafts();
renderResponsavelDrafts();

function fillSubmoduleSelect() {
  const select = document.querySelector("#submoduleSelect");
  select.innerHTML = Object.entries(submodules)
    .map(([value, label]) => `<option value="${escapeHtml(value)}">${escapeHtml(label)}</option>`)
    .join("");
  select.value = state.selectedSubmodule;
}

function requestSidebarView(view) {
  if (state.workspaceContextPending && view !== "workspace") {
    showAlert("Você escolheu um Submódulo ou Fractal no Workspace. Clique no botão Atualizar para entrar no Dashboard do produto escolhido.");
    setView("workspace");
    return;
  }

  setView(view);
}

function markWorkspaceContextPending() {
  state.workspaceContextPending = true;
  setConnection("Contexto pendente", "warn");
}

function handleRefreshClick() {
  loadAll({ enterSelectedProduct: state.workspaceContextPending });
}

async function loadAll(options = {}) {
  clearAlert();
  setConnection("Acessando Supabase...", "");

  if (!isConfigured()) {
    setConnection("Configuração pendente", "error");
    showAlert("Configure a anon key em frontend/config.js antes de consultar o Supabase.");
    return;
  }

  try {
    const [
      dashboard,
      release,
      matrix,
      audit,
      plugPlayRelease,
      moduleConsolidated
    ] = await Promise.all([
      fetchView("vw_dashboard_executivo_unidade_agricola"),
      fetchView("vw_unidades_agricolas_prontas_ecossistema", "select=*&order=codigo_unidade.asc"),
      fetchView("vw_matriz_consumo_modulos_unidade_agricola", "select=*&order=modulo_consumidor.asc"),
      fetchView("vw_auditoria_qualidade_resumo"),
      fetchView("vw_modulo_unidade_agricola_liberacao_ecossistema", "select=*&order=codigo_unidade.asc,ordem_consumo.asc"),
      fetchView("vw_modulo_unidade_agricola_consolidado", "select=*&order=codigo_unidade.asc")
    ]);

    state.data = { ...state.data, dashboard, release, matrix, audit, plugPlayRelease, moduleConsolidated };
    state.units = release;
    if (!state.selectedCode && state.units.length) state.selectedCode = state.units[0].codigo_unidade;
    fillUnitSelect();
    fillCadastroUnitOptions();
    renderDashboard();
    renderPlugPlayRelease();
    renderManagement();
    renderDatabase();
    renderUnits();
    renderDetail();
    renderAudit();
    renderImports();
    if (options.enterSelectedProduct) {
      state.workspaceContextPending = false;
      setView("dashboard");
    }
    setConnection("Conectado", "ok");
    window.setTimeout(loadSecondaryData, 800);
  } catch (error) {
    setConnection("Erro de conexão", "error");
    showAlert(error.message);
  }
}

async function loadSecondaryData() {
  try {
    const [
      summary,
      owners,
      managers,
      areas,
      events,
      blocked,
      importUnits,
      importSubmodules
    ] = await Promise.all([
      fetchView("vw_unidade_relacional_resumo", "select=*&order=codigo_unidade.asc"),
      fetchView("vw_unidade_proprietarios", "select=*&order=codigo_unidade.asc"),
      fetchView("vw_unidade_responsaveis", "select=*&order=codigo_unidade.asc"),
      fetchView("vw_unidade_areas_produtivas", "select=*&order=codigo_unidade.asc"),
      fetchView("vw_unidade_eventos_timeline", "select=*&order=published_at.desc"),
      fetchView("vw_unidades_bloqueadas_ecossistema", "select=*&order=codigo_unidade.asc"),
      fetchView("vw_importacao_planilha_unidades_status", "select=*&order=lote_importacao.asc"),
      fetchView("vw_importacao_submodulos_base_status", "select=*&order=origem.asc")
    ]);

    state.data = { ...state.data, summary, owners, managers, areas, events, blocked, importUnits, importSubmodules };
    renderDatabase();
    renderUnits();
    renderDetail();
    renderImports();
  } catch (error) {
    showAlert(`Dados complementares ainda não carregaram: ${error.message}`);
  }
}

function isConfigured() {
  return config.url && config.anonKey && !config.anonKey.includes("COLE_AQUI");
}

async function fetchView(view, query = "select=*") {
  const url = `${config.url}/rest/v1/${view}?${query}`;
  const controller = new AbortController();
  const timeout = window.setTimeout(() => controller.abort(), 12000);
  const response = await fetch(url, {
    signal: controller.signal,
    headers: {
      apikey: config.anonKey,
      Authorization: `Bearer ${config.anonKey}`,
      "Accept-Profile": config.schema,
      "Content-Profile": config.schema
    }
  }).finally(() => window.clearTimeout(timeout));

  if (!response.ok) {
    const detail = await response.text();
    if (response.status === 406 && detail.includes("PGRST106")) {
      throw new Error(
        `O schema ${config.schema} ainda nao esta exposto na Data API do Supabase. ` +
        `Em Project Settings > API > Data API, adicione ${config.schema} em Exposed schemas, salve e recarregue a pagina. ` +
        `Resposta original ao consultar ${view}: ${detail}`
      );
    }

    throw new Error(`Falha ao consultar ${view}: ${response.status} ${detail}`);
  }

  return response.json();
}

function setView(view) {
  state.view = view;
  document.querySelectorAll(".nav-item").forEach((button) => {
    const target = button.dataset.view;
    const isGerenciamentoChild = target === "gerenciamento" && gerenciamentoViews.includes(view);
    const isConfiguracoesChild = target === "configuracoes" && configuracoesViews.includes(view);
    const isWorkspaceChild = target === "workspace" && workspaceViews.includes(view);
    button.classList.toggle("active", target === view || isGerenciamentoChild || isConfiguracoesChild || isWorkspaceChild);
  });
  document.querySelectorAll(".section-tab").forEach((button) => {
    button.classList.toggle("active", button.dataset.viewTarget === view);
  });
  Object.entries(views).forEach(([key, element]) => {
    element.classList.toggle("active", key === view);
  });
  document.querySelector("#viewTitle").textContent = titles[view][0];
  document.querySelector("#viewSubtitle").textContent = titles[view][1];
  updateActiveSubmodule();
}

function updateActiveSubmodule() {
  document.querySelector("#activeSubmodule").textContent = submodules[state.selectedSubmodule] || "Todos os submódulos";
  updateBrandProductContext();
}

function fillFractalSelect() {
  const select = document.querySelector("#fractalSelect");
  const entries = Object.entries(getAvailableFractals());
  select.innerHTML = [
    `<option value="todos">Todos os fractais</option>`,
    ...entries.map(([value, label]) => `<option value="${escapeHtml(value)}">${escapeHtml(label)}</option>`)
  ].join("");
  select.value = state.selectedFractal;
  updateActiveFractal();
}

function getAvailableFractals() {
  if (state.selectedSubmodule !== "todos") return fractalsBySubmodule[state.selectedSubmodule] || {};

  return Object.values(fractalsBySubmodule).reduce((acc, fractals) => {
    Object.entries(fractals).forEach(([key, label]) => {
      acc[key] = label;
    });
    return acc;
  }, {});
}

function updateActiveFractal() {
  const label = state.selectedFractal === "todos"
    ? "Todos os fractais"
    : getAvailableFractals()[state.selectedFractal] || "Todos os fractais";
  document.querySelector("#activeFractal").textContent = label;
  updateBrandProductContext();
  updateFractalTone();
}

function updateBrandProductContext() {
  const element = document.querySelector("#brandProductContext");
  const submoduleLabel = state.selectedSubmodule === "todos"
    ? "Meu Submódulo"
    : productLabel(submodules[state.selectedSubmodule] || "Meu Submódulo");
  const fractalLabel = state.selectedFractal === "todos"
    ? "Meu Fractal"
    : productLabel(getAvailableFractals()[state.selectedFractal] || "Todos os fractais");

  element.innerHTML = `
    <span>${escapeHtml(submoduleLabel)}</span>
    <strong>${escapeHtml(fractalLabel)}</strong>
  `;
}

function productLabel(value) {
  return String(value || "")
    .replace(/^\d+\s*-\s*/, "")
    .replace("Todos os submódulos", "Portfólio do Módulo")
    .replace("Todos os fractais", "Portfólio de Fractais");
}

function updateFractalTone() {
  const tones = ["fractal-tone-0", "fractal-tone-1", "fractal-tone-2", "fractal-tone-3", "fractal-tone-4", "fractal-tone-5"];
  document.body.classList.remove(...tones);

  if (state.selectedFractal === "todos") {
    document.body.classList.add("fractal-tone-0");
    return;
  }

  const match = state.selectedFractal.match(/^(\d+)/);
  const number = match ? Number(match[1]) : 1;
  const index = ((number - 1) % 5) + 1;
  document.body.classList.add(`fractal-tone-${index}`);
}

function fillUnitSelect() {
  const select = document.querySelector("#unitSelect");
  select.innerHTML = state.units.map((unit) => {
    const selected = unit.codigo_unidade === state.selectedCode ? "selected" : "";
    return `<option value="${escapeHtml(unit.codigo_unidade)}" ${selected}>${escapeHtml(unit.codigo_unidade)} - ${escapeHtml(unit.nome_unidade)}</option>`;
  }).join("");
}

function fillCadastroUnitOptions() {
  const options = [
    `<option value="">Selecione uma unidade</option>`,
    ...(state.units || []).map((unit) => `<option value="${escapeHtml(unit.codigo_unidade)}">${escapeHtml(unit.codigo_unidade)} - ${escapeHtml(unit.nome_unidade)}</option>`)
  ].join("");

  document.querySelectorAll(".unit-options").forEach((select) => {
    const current = select.value;
    select.innerHTML = options;
    if (current) select.value = current;
  });
}

function setCadastroPanel(panelId) {
  document.querySelectorAll(".cadastro-tabs .section-tab").forEach((button) => {
    button.classList.toggle("active", button.dataset.cadastroTarget === panelId);
  });
  document.querySelectorAll(".cadastro-panel").forEach((panel) => {
    panel.classList.toggle("active", panel.id === panelId);
  });
}

function renderDashboard() {
  const data = state.data.dashboard?.[0] || {};
  const release = state.data.release || [];
  const matrix = state.data.matrix || [];

  document.querySelector("#kpiGrid").innerHTML = [
    kpi("Unidades", data.total_unidades, "ok"),
    kpi("Prontas", data.unidades_ativas, "ok"),
    kpi("Área total ha", formatNumber(data.area_total_ha), "ok"),
    kpi("Status", data.status_executivo || "-", data.status_executivo === "saudavel" ? "ok" : "warn"),
    kpi("Eventos", data.eventos_publicados, "ok"),
    kpi("Eventos validados", `${data.perc_eventos_validados || 0}%`, "ok"),
    kpi("Municípios", data.total_municipios, "ok"),
    kpi("Com erro", data.eventos_com_erro, data.eventos_com_erro ? "warn" : "ok")
  ].join("");

  const grouped = groupBy(matrix, "modulo_consumidor");
  const rows = Object.entries(grouped).map(([modulo, items]) => ({
    modulo_consumidor: modulo,
    total_unidades_liberadas: items.length
  }));
  document.querySelector("#ecosystemMatrix").innerHTML = table(rows, ["modulo_consumidor", "total_unidades_liberadas"]);
}

function renderPlugPlayRelease() {
  const rows = state.data.plugPlayRelease || [];
  const consolidated = state.data.moduleConsolidated || [];
  const unitCodes = [...new Set(rows.map((row) => row.codigo_unidade).filter(Boolean))];
  const select = document.querySelector("#plugPlayUnitFilter");

  if (state.selectedPlugPlayCode !== "todos" && !unitCodes.includes(state.selectedPlugPlayCode)) {
    state.selectedPlugPlayCode = "todos";
  }

  select.innerHTML = [
    `<option value="todos">Todas as unidades</option>`,
    ...unitCodes.map((code) => {
      const unit = rows.find((row) => row.codigo_unidade === code) || {};
      return `<option value="${escapeHtml(code)}">${escapeHtml(code)} - ${escapeHtml(unit.nome_unidade || "Unidade")}</option>`;
    })
  ].join("");
  select.value = state.selectedPlugPlayCode;

  const filteredRows = state.selectedPlugPlayCode === "todos"
    ? rows
    : rows.filter((row) => row.codigo_unidade === state.selectedPlugPlayCode);
  const selectedConsolidated = state.selectedPlugPlayCode === "todos"
    ? consolidated
    : consolidated.filter((row) => row.codigo_unidade === state.selectedPlugPlayCode);

  const totalConsumers = filteredRows.length;
  const totalReleased = filteredRows.filter((row) => row.liberado).length;
  const totalBlocked = totalConsumers - totalReleased;
  const readyUnits = selectedConsolidated.filter((row) => row.pronto_para_ecossistema_genius).length;
  const totalUnits = selectedConsolidated.length || unitCodes.length;
  const percentReleased = totalConsumers ? Math.round((totalReleased / totalConsumers) * 100) : 0;
  const mainUnit = selectedConsolidated[0] || filteredRows[0] || {};
  const healthy = totalConsumers > 0 && totalBlocked === 0;

  document.querySelector("#plugPlayHero").innerHTML = `
    <div>
      <span class="plug-eyebrow">Módulo plug and play</span>
      <h2>${healthy ? "Pronto para o Ecossistema Genius" : "Liberação com pendências"}</h2>
      <p>${escapeHtml(mainUnit.nome_unidade || "As unidades liberadas")} ${healthy ? "já possui contrato visual de consumo com os módulos dependentes." : "ainda possui bloqueios que precisam ser resolvidos antes do consumo geral."}</p>
    </div>
    <strong class="plug-score">${escapeHtml(percentReleased)}%</strong>
  `;

  document.querySelector("#plugPlayKpis").innerHTML = [
    kpi("Módulos consumidores", totalConsumers, "ok"),
    kpi("Liberados", totalReleased, totalBlocked ? "warn" : "ok"),
    kpi("Bloqueados", totalBlocked, totalBlocked ? "warn" : "ok"),
    kpi("Unidades prontas", `${readyUnits}/${totalUnits || 0}`, readyUnits === totalUnits ? "ok" : "warn")
  ].join("");

  document.querySelector("#plugPlayConsumerGrid").innerHTML = filteredRows.length
    ? filteredRows.map(plugPlayConsumerCard).join("")
    : empty("Nenhuma liberação encontrada para a seleção atual.");
}

function plugPlayConsumerCard(row) {
  const submodules = Array.isArray(row.submodulos_chave) ? row.submodulos_chave : [];
  return `
    <article class="plug-consumer-card ${row.liberado ? "released" : "blocked"}">
      <div class="plug-consumer-head">
        <div>
          <span>${escapeHtml(row.categoria_consumo || "consumidor")}</span>
          <strong>${escapeHtml(row.modulo_consumidor || "-")}</strong>
        </div>
        ${badge(row.liberado ? "Liberado" : "Bloqueado", row.liberado ? "ok" : "warn")}
      </div>
      <p>${escapeHtml(row.motivo || "Sem motivo informado.")}</p>
      <div class="plug-consumer-meta">
        <span>Unidade</span>
        <strong>${escapeHtml(row.codigo_unidade || "-")}</strong>
      </div>
      <div class="plug-submodules">
        ${submodules.length ? submodules.map((item) => `<span>${escapeHtml(item)}</span>`).join("") : "<span>sem submódulos chave</span>"}
      </div>
    </article>
  `;
}

function renderManagement() {
  const data = state.data.dashboard?.[0] || {};
  const audit = state.data.audit?.[0] || {};
  const release = state.data.release || [];
  const ready = release.filter((unit) => unit.pronta_ecossistema).length;

  document.querySelector("#moduleManagementSummary").innerHTML = [
    ["Módulo", "Mod_Gestao_Unidade_Agricola"],
    ["Modo standalone", "Ativo"],
    ["Modo plataforma", "Preparado"],
    ["Schema Supabase", config.schema || "-"],
    ["Unidades prontas", `${ready}/${release.length || 0}`],
    ["Status executivo", data.status_executivo || "-"],
    ["Status qualidade", audit.status_qualidade || "-"],
    ["Eventos publicados", data.eventos_publicados ?? "-"]
  ].map(([label, value]) => `<div class="summary-item"><span>${escapeHtml(label)}</span><strong>${escapeHtml(value)}</strong></div>`).join("");
}

function renderDatabase() {
  const release = state.data.release || [];
  const owners = state.data.owners || [];
  const managers = state.data.managers || [];
  const areas = state.data.areas || [];
  const events = state.data.events || [];

  document.querySelector("#databaseSheets").innerHTML = databaseSheetsHtml([
    {
      title: "Unidades Agrícolas",
      table: "unidades_agricolas",
      total: release.length,
      key: "codigo_unidade",
      sheet: "unidades",
      description: "Cadastro principal. Cada propriedade, fazenda, sítio ou unidade operacional nasce aqui."
    },
    {
      title: "Proprietários/Possuidores",
      table: "proprietarios_possuidores",
      total: owners.length,
      key: "codigo_unidade",
      sheet: "proprietarios",
      description: "Pessoas ou empresas vinculadas juridicamente ou operacionalmente a uma unidade."
    },
    {
      title: "Responsáveis/Gestores",
      table: "responsaveis_gestores",
      total: managers.length,
      key: "codigo_unidade",
      sheet: "responsaveis",
      description: "Quem administra, responde tecnicamente ou opera a unidade agrícola."
    },
    {
      title: "Áreas Produtivas",
      table: "territorios_areas_producao",
      total: areas.length,
      key: "codigo_unidade",
      sheet: "areas",
      description: "Áreas, glebas, talhões e usos produtivos ligados à unidade."
    },
    {
      title: "Eventos dos Fractais",
      table: "eventos_modulo",
      total: events.length,
      key: "codigo_unidade + fractal_origem",
      sheet: "eventos",
      description: "Linha do tempo de validações, integrações e mudanças publicadas pelos fractais."
    },
    {
      title: "Liberação para Ecossistema",
      table: "vw_unidades_prontas_ecossistema",
      total: release.filter((unit) => unit.pronta_ecossistema).length,
      key: "codigo_unidade",
      sheet: "liberacao",
      description: "Mostra se a unidade pode ser consumida por outros módulos do Ecossistema Genius."
    }
  ]);
  document.querySelector("#databaseRelations").innerHTML = databaseRelationsHtml();
}

function databaseSheetsHtml(items) {
  return items.map((item) => `
    <article class="database-sheet-card">
      <div>
        <strong>${escapeHtml(item.title)}</strong>
        <span>${escapeHtml(item.table)}</span>
      </div>
      <p>${escapeHtml(item.description)}</p>
      <dl>
        <div><dt>Registros</dt><dd>${escapeHtml(item.total)}</dd></div>
        <div><dt>Chave de ligação</dt><dd>${escapeHtml(item.key)}</dd></div>
      </dl>
      <button type="button" class="button-secondary database-sheet-button" data-database-sheet="${escapeHtml(item.sheet)}">Visualizar Planilha</button>
    </article>
  `).join("");
}

function databaseRelationsHtml() {
  return `
    <div class="brain-map" aria-label="Mapa relacional das planilhas do modulo">
      <svg class="brain-wires" viewBox="0 0 1000 520" preserveAspectRatio="none" aria-hidden="true">
        <path d="M500 250 C330 120 230 95 130 100" />
        <path d="M500 250 C500 105 500 80 500 70" />
        <path d="M500 250 C670 120 770 95 870 100" />
        <path d="M500 250 C300 250 220 250 130 250" />
        <path d="M500 250 C700 250 780 250 870 250" />
        <path d="M500 250 C330 380 230 425 130 420" />
        <path d="M500 250 C500 390 500 430 500 450" />
        <path d="M500 250 C670 380 770 425 870 420" />
        <path class="wire-strong" d="M870 250 C930 250 940 250 970 250" />
        <circle cx="500" cy="250" r="8" />
      </svg>

      <div class="brain-node brain-center" style="--x: 50%; --y: 48%;">
        <strong>Unidade Agrícola</strong>
        <span>chave central: codigo_unidade</span>
      </div>
      <div class="brain-node" style="--x: 13%; --y: 18%;">
        <strong>Proprietários/Possuidores</strong>
        <span>titularidade e vínculo</span>
      </div>
      <div class="brain-node" style="--x: 50%; --y: 10%;">
        <strong>Responsáveis/Gestores</strong>
        <span>gestão e autorização</span>
      </div>
      <div class="brain-node" style="--x: 87%; --y: 18%;">
        <strong>Áreas Produtivas</strong>
        <span>glebas, talhões e uso</span>
      </div>
      <div class="brain-node" style="--x: 13%; --y: 48%;">
        <strong>Documentos</strong>
        <span>fundiário, ambiental e fiscal</span>
      </div>
      <div class="brain-node" style="--x: 87%; --y: 48%;">
        <strong>Eventos dos Fractais</strong>
        <span>validações e histórico</span>
      </div>
      <div class="brain-node" style="--x: 13%; --y: 80%;">
        <strong>Ativos Estruturais</strong>
        <span>benfeitorias e instalações</span>
      </div>
      <div class="brain-node" style="--x: 50%; --y: 86%;">
        <strong>Submódulos e Fractais</strong>
        <span>estrutura plug and play</span>
      </div>
      <div class="brain-node brain-ecosystem" style="--x: 87%; --y: 80%;">
        <strong>Ecossistema Genius</strong>
        <span>BI, Hub, DataLake e módulos</span>
      </div>
    </div>
  `;
}

function renderUnits() {
  const term = document.querySelector("#unitSearch").value.toLowerCase();
  const rows = (state.data.release || []).filter((unit) => {
    return [unit.codigo_unidade, unit.nome_unidade, unit.municipio, unit.status_cadastro].some((value) => String(value || "").toLowerCase().includes(term));
  }).map((unit) => ({
    codigo_unidade: unit.codigo_unidade,
    nome_unidade: unit.nome_unidade,
    municipio: unit.municipio,
    area_total_ha: formatNumber(unit.area_total_ha),
    pronta: badge(unit.pronta_ecossistema ? "Sim" : "Não", unit.pronta_ecossistema ? "ok" : "warn"),
    modulos: unit.modulos_consumidores_liberados?.length || 0
  }));

  document.querySelector("#unitsTable").innerHTML = table(rows, ["codigo_unidade", "nome_unidade", "municipio", "area_total_ha", "pronta", "modulos"]);
}

function renderDetail() {
  const code = state.selectedCode;
  const summary = (state.data.summary || []).find((item) => item.codigo_unidade === code);
  const owners = (state.data.owners || []).filter((item) => item.codigo_unidade === code);
  const managers = (state.data.managers || []).filter((item) => item.codigo_unidade === code);
  const areas = (state.data.areas || []).filter((item) => item.codigo_unidade === code);
  const events = (state.data.events || []).filter((item) => item.codigo_unidade === code);

  document.querySelector("#unitSummary").innerHTML = summary ? summaryHtml(summary) : empty("Selecione uma unidade.");
  document.querySelector("#ownersTable").innerHTML = table(owners, ["nome_titular", "tipo_vinculo", "telefone", "email"]);
  document.querySelector("#managersTable").innerHTML = table(managers, ["nome_responsavel", "tipo_responsabilidade", "cargo_funcao", "principal"]);
  document.querySelector("#areasTable").innerHTML = table(areas.map((area) => ({ ...area, area_ha: formatNumber(area.area_ha) })), ["codigo_area", "nome_area", "tipo_area", "area_ha", "uso_atual"]);
  document.querySelector("#eventsTimeline").innerHTML = events.length ? events.map(eventHtml).join("") : empty("Sem eventos.");
}

function renderAudit() {
  const audit = state.data.audit?.[0] || {};
  document.querySelector("#auditGrid").innerHTML = [
    kpi("Status qualidade", audit.status_qualidade || "-", audit.status_qualidade === "saudavel" ? "ok" : "warn"),
    kpi("Incompletas", audit.unidades_incompletas, audit.unidades_incompletas ? "warn" : "ok"),
    kpi("Sem vínculos", audit.unidades_sem_vinculos, audit.unidades_sem_vinculos ? "warn" : "ok"),
    kpi("Eventos erro", audit.eventos_com_erro, audit.eventos_com_erro ? "warn" : "ok"),
    kpi("Sem identidade", audit.unidades_sem_identidade, audit.unidades_sem_identidade ? "warn" : "ok"),
    kpi("Áreas inconsistentes", audit.areas_inconsistentes, audit.areas_inconsistentes ? "warn" : "ok"),
    kpi("Importações pendentes", audit.importacoes_pendentes_erro, audit.importacoes_pendentes_erro ? "warn" : "ok")
  ].join("");

  document.querySelector("#blockedTable").innerHTML = table(state.data.blocked || [], ["codigo_unidade", "nome_unidade", "motivos_bloqueio"]);
}

function renderImports() {
  document.querySelector("#importUnitsTable").innerHTML = table(state.data.importUnits || [], ["lote_importacao", "status_importacao", "total_linhas", "total_com_unidade"]);
  document.querySelector("#importSubmodulesTable").innerHTML = table(state.data.importSubmodules || [], ["origem", "lote_importacao", "status_importacao", "total"]);
}

function handleCadastroUnidadeSubmit(event) {
  event.preventDefault();
  const form = event.currentTarget;
  const data = Object.fromEntries(new FormData(form).entries());
  const normalized = normalizeCadastroUnidade(data);
  const errors = validateCadastroUnidade(normalized);

  if (errors.length) {
    showAlert(errors.join(" "));
    return;
  }

  saveDraft("unidade", normalized);
  form.reset();
  state.editingDraft = null;
  clearAlert();
  renderCadastroDrafts();
}

function normalizeCadastroUnidade(data) {
  return {
    codigo_unidade: String(data.codigo_unidade || "").trim().toUpperCase(),
    nome_unidade: String(data.nome_unidade || "").trim(),
    tipo_unidade: String(data.tipo_unidade || "").trim(),
    status_cadastro: String(data.status_cadastro || "Ativo").trim(),
    situacao_operacional: String(data.situacao_operacional || "").trim(),
    uf: String(data.uf || "").trim().toUpperCase(),
    municipio: String(data.municipio || "").trim(),
    area_total_ha: data.area_total_ha ? Number(data.area_total_ha) : null,
    latitude_sede: data.latitude_sede ? Number(data.latitude_sede) : null,
    longitude_sede: data.longitude_sede ? Number(data.longitude_sede) : null,
    observacoes: String(data.observacoes || "").trim()
  };
}

function validateCadastroUnidade(data) {
  const errors = [];
  if (!data.codigo_unidade) errors.push("Informe o código da unidade.");
  if (!data.nome_unidade) errors.push("Informe o nome da unidade.");
  if (!data.tipo_unidade) errors.push("Selecione o tipo da unidade.");
  if (data.uf && data.uf.length !== 2) errors.push("UF deve ter 2 letras.");
  if (data.area_total_ha !== null && data.area_total_ha < 0) errors.push("Área total não pode ser negativa.");
  if (data.latitude_sede !== null && (data.latitude_sede < -90 || data.latitude_sede > 90)) errors.push("Latitude deve estar entre -90 e 90.");
  if (data.longitude_sede !== null && (data.longitude_sede < -180 || data.longitude_sede > 180)) errors.push("Longitude deve estar entre -180 e 180.");
  return errors;
}

function getCadastroDrafts() {
  try {
    return JSON.parse(localStorage.getItem("genius.unidade_agricola.cadastros_unidade") || "[]");
  } catch {
    return [];
  }
}

function renderCadastroDrafts() {
  const drafts = getCadastroDrafts().map((item, index) => ({
    codigo_unidade: item.codigo_unidade,
    nome_unidade: item.nome_unidade,
    tipo_unidade: item.tipo_unidade,
    uf: item.uf || "-",
    municipio: item.municipio || "-",
    area_total_ha: formatNumber(item.area_total_ha),
    status_envio: item.status_envio,
    acoes: draftActions("unidade", index)
  }));
  document.querySelector("#cadastroDrafts").innerHTML = table(drafts, ["codigo_unidade", "nome_unidade", "tipo_unidade", "uf", "municipio", "area_total_ha", "status_envio", "acoes"]);
}

function handleCadastroProprietarioSubmit(event) {
  event.preventDefault();
  const form = event.currentTarget;
  const data = normalizeCadastroProprietario(Object.fromEntries(new FormData(form).entries()));
  const errors = validateCadastroProprietario(data);

  if (errors.length) {
    showAlert(errors.join(" "));
    return;
  }

  saveDraft("proprietario", data);
  form.reset();
  state.editingDraft = null;
  clearAlert();
  renderProprietarioDrafts();
}

function normalizeCadastroProprietario(data) {
  return {
    codigo_unidade: String(data.codigo_unidade || "").trim(),
    nome_titular: String(data.nome_titular || "").trim(),
    tipo_vinculo: String(data.tipo_vinculo || "").trim(),
    documento: String(data.documento || "").trim(),
    participacao_percentual: data.participacao_percentual ? Number(data.participacao_percentual) : null,
    telefone: String(data.telefone || "").trim(),
    email: String(data.email || "").trim(),
    status_vinculo: String(data.status_vinculo || "Ativo").trim(),
    observacoes: String(data.observacoes || "").trim()
  };
}

function validateCadastroProprietario(data) {
  const errors = [];
  if (!data.codigo_unidade) errors.push("Selecione a unidade agrícola.");
  if (!data.nome_titular) errors.push("Informe o nome do titular.");
  if (!data.tipo_vinculo) errors.push("Selecione o tipo de vínculo.");
  if (data.participacao_percentual !== null && (data.participacao_percentual < 0 || data.participacao_percentual > 100)) errors.push("Participação deve estar entre 0 e 100%.");
  return errors;
}

function renderProprietarioDrafts() {
  const drafts = getLocalDrafts("genius.unidade_agricola.cadastros_proprietarios").map((item, index) => ({
    codigo_unidade: item.codigo_unidade,
    nome_titular: item.nome_titular,
    tipo_vinculo: item.tipo_vinculo,
    documento: item.documento || "-",
    participacao_percentual: item.participacao_percentual ?? "-",
    status_envio: item.status_envio,
    acoes: draftActions("proprietario", index)
  }));
  document.querySelector("#proprietarioDrafts").innerHTML = table(drafts, ["codigo_unidade", "nome_titular", "tipo_vinculo", "documento", "participacao_percentual", "status_envio", "acoes"]);
}

function handleCadastroResponsavelSubmit(event) {
  event.preventDefault();
  const form = event.currentTarget;
  const data = normalizeCadastroResponsavel(Object.fromEntries(new FormData(form).entries()));
  const errors = validateCadastroResponsavel(data);

  if (errors.length) {
    showAlert(errors.join(" "));
    return;
  }

  saveDraft("responsavel", data);
  form.reset();
  state.editingDraft = null;
  clearAlert();
  renderResponsavelDrafts();
}

function normalizeCadastroResponsavel(data) {
  return {
    codigo_unidade: String(data.codigo_unidade || "").trim(),
    nome_responsavel: String(data.nome_responsavel || "").trim(),
    tipo_responsabilidade: String(data.tipo_responsabilidade || "").trim(),
    cargo_funcao: String(data.cargo_funcao || "").trim(),
    nivel_autorizacao: String(data.nivel_autorizacao || "Operacional").trim(),
    principal: String(data.principal || "Não").trim(),
    telefone: String(data.telefone || "").trim(),
    email: String(data.email || "").trim(),
    observacoes: String(data.observacoes || "").trim()
  };
}

function validateCadastroResponsavel(data) {
  const errors = [];
  if (!data.codigo_unidade) errors.push("Selecione a unidade agrícola.");
  if (!data.nome_responsavel) errors.push("Informe o nome do responsável.");
  if (!data.tipo_responsabilidade) errors.push("Selecione o tipo de responsabilidade.");
  return errors;
}

function renderResponsavelDrafts() {
  const drafts = getLocalDrafts("genius.unidade_agricola.cadastros_responsaveis").map((item, index) => ({
    codigo_unidade: item.codigo_unidade,
    nome_responsavel: item.nome_responsavel,
    tipo_responsabilidade: item.tipo_responsabilidade,
    cargo_funcao: item.cargo_funcao || "-",
    principal: item.principal,
    status_envio: item.status_envio,
    acoes: draftActions("responsavel", index)
  }));
  document.querySelector("#responsavelDrafts").innerHTML = table(drafts, ["codigo_unidade", "nome_responsavel", "tipo_responsabilidade", "cargo_funcao", "principal", "status_envio", "acoes"]);
}

function getLocalDrafts(key) {
  try {
    return JSON.parse(localStorage.getItem(key) || "[]");
  } catch {
    return [];
  }
}

function setLocalDrafts(key, drafts) {
  localStorage.setItem(key, JSON.stringify(drafts.slice(0, 25)));
}

function draftActions(type, index) {
  return `<div class="row-actions">
    <button type="button" class="button-small button-secondary" data-draft-action="view" data-draft-type="${type}" data-draft-index="${index}">Visualizar</button>
    <button type="button" class="button-small" data-draft-action="edit" data-draft-type="${type}" data-draft-index="${index}">Editar</button>
    <button type="button" class="button-small button-danger" data-draft-action="delete" data-draft-type="${type}" data-draft-index="${index}">Excluir</button>
  </div>`;
}

function handleDraftAction(event) {
  const button = event.target.closest("[data-draft-action]");
  if (!button) return;

  const type = button.dataset.draftType;
  const index = Number(button.dataset.draftIndex);
  const action = button.dataset.draftAction;
  const drafts = getDraftsByType(type);
  const draft = drafts[index];
  if (!draft) return;

  if (action === "view") {
    openA4Preview(type, draft);
    return;
  }

  if (action === "edit") {
    loadDraftIntoForm(type, draft, index);
    return;
  }

  if (action === "delete") {
    const confirmed = window.confirm("Excluir este rascunho local? Esta ação remove apenas o rascunho salvo neste navegador.");
    if (!confirmed) return;
    drafts.splice(index, 1);
    setLocalDrafts(getDraftKey(type), drafts);
    renderDraftsByType(type);
    clearAlert();
  }
}

function saveDraft(type, data) {
  const key = getDraftKey(type);
  const drafts = getLocalDrafts(key);
  const payload = {
    ...data,
    status_envio: "rascunho_local",
    criado_em: new Date().toISOString()
  };

  if (state.editingDraft?.type === type) {
    drafts[state.editingDraft.index] = payload;
  } else {
    drafts.unshift(payload);
  }

  setLocalDrafts(key, drafts);
}

function getDraftsByType(type) {
  return getLocalDrafts(getDraftKey(type));
}

function getDraftKey(type) {
  const keys = {
    unidade: "genius.unidade_agricola.cadastros_unidade",
    proprietario: "genius.unidade_agricola.cadastros_proprietarios",
    responsavel: "genius.unidade_agricola.cadastros_responsaveis"
  };
  return keys[type];
}

function renderDraftsByType(type) {
  if (type === "unidade") renderCadastroDrafts();
  if (type === "proprietario") renderProprietarioDrafts();
  if (type === "responsavel") renderResponsavelDrafts();
}

function loadDraftIntoForm(type, draft, index) {
  const formIds = {
    unidade: "cadastroUnidadeForm",
    proprietario: "cadastroProprietarioForm",
    responsavel: "cadastroResponsavelForm"
  };
  const panels = {
    unidade: "cadastroUnidadePanel",
    proprietario: "cadastroProprietariosPanel",
    responsavel: "cadastroResponsaveisPanel"
  };

  setCadastroPanel(panels[type]);
  const form = document.querySelector(`#${formIds[type]}`);
  Object.entries(draft).forEach(([key, value]) => {
    const field = form.elements[key];
    if (field) field.value = value ?? "";
  });
  state.editingDraft = { type, index };
  showAlert("Rascunho carregado para edição. Ao salvar, ele substituirá o rascunho atual.");
}

function formatDraftForView(draft) {
  return Object.entries(draft)
    .filter(([key]) => !["criado_em"].includes(key))
    .map(([key, value]) => `${labelize(key)}: ${value ?? "-"}`)
    .join(" | ");
}

function openA4Preview(type, draft) {
  const overlay = document.querySelector("#a4PreviewOverlay");
  const page = document.querySelector("#a4PreviewPage");
  const title = {
    unidade: "Cadastro da Unidade Agrícola",
    proprietario: "Cadastro de Proprietário/Possuidor",
    responsavel: "Cadastro de Responsável/Gestor"
  }[type] || "Cadastro";

  page.classList.remove("sheet-print-page");
  page.innerHTML = `
    <header class="a4-header">
      <div>
        <strong>Ecossistema Genius</strong>
        <span>Mod_Gestao_Unidade_Agricola</span>
      </div>
      <div>
        <strong>${escapeHtml(title)}</strong>
        <span>${escapeHtml(new Date().toLocaleString("pt-BR"))}</span>
      </div>
    </header>
    <h1>${escapeHtml(title)}</h1>
    <div class="a4-fields">
      ${Object.entries(draft)
        .filter(([key]) => !["criado_em"].includes(key))
        .map(([key, value]) => `
          <div>
            <span>${escapeHtml(labelize(key))}</span>
            <strong>${escapeHtml(value ?? "-")}</strong>
          </div>
        `).join("")}
    </div>
    <footer class="a4-footer">
      <span>Documento gerado a partir de rascunho local do frontend do módulo.</span>
      <span>Status: ${escapeHtml(draft.status_envio || "rascunho_local")}</span>
    </footer>
  `;
  overlay.classList.remove("hidden");
  overlay.setAttribute("aria-hidden", "false");
  document.body.classList.add("preview-open");
}

function closeA4Preview() {
  const overlay = document.querySelector("#a4PreviewOverlay");
  overlay.classList.add("hidden");
  overlay.setAttribute("aria-hidden", "true");
  document.body.classList.remove("preview-open");
  document.querySelector("#a4PreviewPage").classList.remove("sheet-print-page");
}

function printA4Preview() {
  window.print();
}

function openSheetMode(type) {
  const schema = sheetSchemas[type];
  if (!schema) return;

  setSheetToolbarMode("edit");
  state.sheetType = type;
  state.sheetRows = getLocalDrafts(schema.key).map((row) => ({ ...row }));
  if (!state.sheetRows.length) state.sheetRows = [emptySheetRow(schema.columns)];

  document.querySelector("#sheetModeTitle").textContent = schema.title;
  document.querySelector("#sheetModeOverlay").classList.remove("hidden");
  document.querySelector("#sheetModeOverlay").setAttribute("aria-hidden", "false");
  renderSheetGrid();
}

function closeSheetMode() {
  document.querySelector("#sheetModeOverlay").classList.add("hidden");
  document.querySelector("#sheetModeOverlay").setAttribute("aria-hidden", "true");
  setSheetToolbarMode("edit");
}

function addSheetRow() {
  const schema = sheetSchemas[state.sheetType];
  state.sheetRows.push(emptySheetRow(schema.columns));
  renderSheetGrid();
}

function emptySheetRow(columns) {
  return columns.reduce((acc, column) => {
    acc[column] = "";
    return acc;
  }, {});
}

function renderSheetGrid() {
  const schema = sheetSchemas[state.sheetType];
  const header = schema.columns.map((column) => `<th>${escapeHtml(labelize(column))}</th>`).join("");
  const body = state.sheetRows.map((row, rowIndex) => {
    const cells = schema.columns.map((column) => {
      return `<td><input data-sheet-row="${rowIndex}" data-sheet-column="${escapeHtml(column)}" value="${escapeHtml(row[column] ?? "")}" /></td>`;
    }).join("");
    return `<tr>${cells}</tr>`;
  }).join("");

  document.querySelector("#sheetGrid").innerHTML = `<table><thead><tr>${header}</tr></thead><tbody>${body}</tbody></table>`;
  document.querySelectorAll("#sheetGrid input").forEach((input) => {
    input.addEventListener("input", updateSheetCell);
  });
}

function updateSheetCell(event) {
  const input = event.target;
  const rowIndex = Number(input.dataset.sheetRow);
  const column = input.dataset.sheetColumn;
  state.sheetRows[rowIndex][column] = input.value;
}

function saveSheetRows() {
  const schema = sheetSchemas[state.sheetType];
  const rows = state.sheetRows
    .map((row) => normalizeSheetRow(state.sheetType, row))
    .filter((row) => Object.values(row).some((value) => value !== "" && value !== null));

  const drafts = rows.map((row) => ({
    ...row,
    status_envio: "rascunho_local",
    criado_em: new Date().toISOString()
  }));

  setLocalDrafts(schema.key, drafts);
  renderDraftsByType(state.sheetType);
  state.sheetRows = [...drafts, emptySheetRow(schema.columns)];
  renderSheetGrid();
  clearAlert();
}

function importSheetFile(event) {
  const file = event.target.files?.[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = () => {
    const schema = sheetSchemas[state.sheetType];
    const imported = parseCsv(String(reader.result || ""), schema.columns);
    state.sheetRows = imported.length ? [...imported, emptySheetRow(schema.columns)] : state.sheetRows;
    renderSheetGrid();
    event.target.value = "";
  };
  reader.readAsText(file, "utf-8");
}

function parseCsv(text, columns) {
  const lines = text.split(/\r?\n/).filter((line) => line.trim());
  if (!lines.length) return [];

  const first = splitCsvLine(lines[0]).map((value) => value.trim());
  const hasHeader = first.some((value) => columns.includes(value));
  const headers = hasHeader ? first : columns;
  const dataLines = hasHeader ? lines.slice(1) : lines;

  return dataLines.map((line) => {
    const values = splitCsvLine(line);
    return columns.reduce((acc, column) => {
      const index = headers.indexOf(column);
      acc[column] = index >= 0 ? values[index] || "" : "";
      return acc;
    }, {});
  });
}

function splitCsvLine(line) {
  const result = [];
  let current = "";
  let quoted = false;

  for (const char of line) {
    if (char === "\"") {
      quoted = !quoted;
    } else if (char === "," && !quoted) {
      result.push(current);
      current = "";
    } else {
      current += char;
    }
  }

  result.push(current);
  return result.map((value) => value.trim());
}

function printSheetMode() {
  const schema = sheetSchemas[state.sheetType];
  const rows = state.sheetRows
    .map((row) => normalizeSheetRow(state.sheetType, row))
    .filter((row) => Object.values(row).some((value) => value !== "" && value !== null));
  const overlay = document.querySelector("#a4PreviewOverlay");
  const page = document.querySelector("#a4PreviewPage");

  page.classList.add("sheet-print-page");
  page.innerHTML = `
    <header class="a4-header">
      <div>
        <strong>Ecossistema Genius</strong>
        <span>Mod_Gestao_Unidade_Agricola</span>
      </div>
      <div>
        <strong>${escapeHtml(schema.title.replace("Modo Planilha - ", "Planilha - "))}</strong>
        <span>${escapeHtml(new Date().toLocaleString("pt-BR"))}</span>
      </div>
    </header>
    <h1>Visualização de Impressão da Planilha</h1>
    <div class="sheet-print-wrap">
      <table class="sheet-print-table">
        <thead>
          <tr>${schema.columns.map((column) => `<th>${escapeHtml(labelize(column))}</th>`).join("")}</tr>
        </thead>
        <tbody>
          ${rows.map((row) => `
            <tr>${schema.columns.map((column) => `<td>${escapeHtml(row[column] ?? "-")}</td>`).join("")}</tr>
          `).join("")}
        </tbody>
      </table>
    </div>
    <footer class="a4-footer">
      <span>Visualização gerada a partir do Modo Planilha.</span>
      <span>Total de linhas: ${rows.length}</span>
    </footer>
  `;

  overlay.classList.remove("hidden");
  overlay.setAttribute("aria-hidden", "false");
  document.body.classList.add("preview-open");
}

function normalizeSheetRow(type, row) {
  if (type === "unidade") return normalizeCadastroUnidade(row);
  if (type === "proprietario") return normalizeCadastroProprietario(row);
  if (type === "responsavel") return normalizeCadastroResponsavel(row);
  return row;
}

function handleDatabaseSheetAction(event) {
  const button = event.target.closest("[data-database-sheet]");
  if (!button) return;
  openDatabaseSheetView(button.dataset.databaseSheet);
}

function openDatabaseSheetView(sheet) {
  const source = getDatabaseSheetSource(sheet);
  if (!source) return;

  setSheetToolbarMode("view");
  document.querySelector("#sheetModeTitle").textContent = `Visualizar Planilha - ${source.title}`;
  document.querySelector("#sheetModeOverlay").classList.remove("hidden");
  document.querySelector("#sheetModeOverlay").setAttribute("aria-hidden", "false");
  document.querySelector("#sheetGrid").innerHTML = readonlySheetTable(source.rows, source.columns);
}

function getDatabaseSheetSource(sheet) {
  const sources = {
    unidades: {
      title: "Unidades Agrícolas",
      rows: state.data.release || [],
      columns: ["codigo_unidade", "nome_unidade", "tipo_unidade", "status_cadastro", "situacao_operacional", "uf", "municipio", "area_total_ha", "sync_status"]
    },
    proprietarios: {
      title: "Proprietários/Possuidores",
      rows: state.data.owners || [],
      columns: ["codigo_unidade", "nome_titular", "tipo_vinculo", "telefone", "email"]
    },
    responsaveis: {
      title: "Responsáveis/Gestores",
      rows: state.data.managers || [],
      columns: ["codigo_unidade", "nome_responsavel", "tipo_responsabilidade", "cargo_funcao", "principal"]
    },
    areas: {
      title: "Áreas Produtivas",
      rows: state.data.areas || [],
      columns: ["codigo_unidade", "codigo_area", "nome_area", "tipo_area", "area_ha", "uso_atual"]
    },
    eventos: {
      title: "Eventos dos Fractais",
      rows: state.data.events || [],
      columns: ["codigo_unidade", "fractal_origem", "nome_evento", "status", "published_at"]
    },
    liberacao: {
      title: "Liberação para Ecossistema",
      rows: state.data.release || [],
      columns: ["codigo_unidade", "nome_unidade", "pronta_ecossistema", "modulos_consumidores_liberados"]
    }
  };
  return sources[sheet];
}

function readonlySheetTable(rows, columns) {
  if (!rows.length) return empty("Nenhum registro encontrado.");
  return `<table><thead><tr>${columns.map((column) => `<th>${escapeHtml(labelize(column))}</th>`).join("")}</tr></thead><tbody>${rows.map((row) => `<tr>${columns.map((column) => `<td>${formatCell(row[column])}</td>`).join("")}</tr>`).join("")}</tbody></table>`;
}

function setSheetToolbarMode(mode) {
  const editOnly = mode === "edit";
  document.querySelector("#importSheetButton").classList.toggle("hidden", !editOnly);
  document.querySelector("#addSheetRowButton").classList.toggle("hidden", !editOnly);
  document.querySelector("#saveSheetButton").classList.toggle("hidden", !editOnly);
}

function kpi(label, value, mode = "") {
  return `<div class="kpi ${mode}"><span>${escapeHtml(label)}</span><strong>${escapeHtml(value ?? "-")}</strong></div>`;
}

function table(rows, columns) {
  if (!rows?.length) return empty("Nenhum registro encontrado.");
  return `<table><thead><tr>${columns.map((column) => `<th>${escapeHtml(labelize(column))}</th>`).join("")}</tr></thead><tbody>${rows.map((row) => `<tr>${columns.map((column) => `<td>${formatCell(row[column])}</td>`).join("")}</tr>`).join("")}</tbody></table>`;
}

function summaryHtml(row) {
  const fields = [
    ["Código", row.codigo_unidade],
    ["Nome", row.nome_unidade],
    ["Status", row.status_cadastro],
    ["Município", `${row.municipio || "-"} / ${row.uf || "-"}`],
    ["Área total ha", formatNumber(row.area_total_ha)],
    ["Proprietários", row.total_proprietarios_possuidores],
    ["Responsáveis", row.total_responsaveis_gestores],
    ["Áreas", row.total_areas_produtivas],
    ["Eventos", row.total_eventos],
    ["Eventos com erro", row.eventos_com_erro]
  ];
  return fields.map(([label, value]) => `<div class="summary-item"><span>${escapeHtml(label)}</span><strong>${escapeHtml(value ?? "-")}</strong></div>`).join("");
}

function eventHtml(event) {
  return `<div class="event"><strong>${escapeHtml(event.fractal_origem)}</strong><small>${escapeHtml(event.nome_evento)} · ${escapeHtml(event.status)} · ${formatDate(event.published_at)}</small></div>`;
}

function empty(message) {
  return `<div class="summary-item"><span>${escapeHtml(message)}</span></div>`;
}

function badge(text, mode) {
  return `<span class="badge ${mode}">${escapeHtml(text)}</span>`;
}

function formatCell(value) {
  if (Array.isArray(value)) return value.length ? value.map((item) => badge(item, "ok")).join(" ") : "-";
  if (typeof value === "boolean") return badge(value ? "Sim" : "Não", value ? "ok" : "warn");
  if (String(value).startsWith("<span")) return value;
  if (String(value).startsWith("<div class=\"row-actions\"")) return value;
  return escapeHtml(value ?? "-");
}

function formatNumber(value) {
  const number = Number(value);
  if (!Number.isFinite(number)) return value ?? "-";
  return number.toLocaleString("pt-BR", { maximumFractionDigits: 2 });
}

function formatDate(value) {
  if (!value) return "-";
  return new Date(value).toLocaleString("pt-BR");
}

function labelize(key) {
  return String(key).replaceAll("_", " ");
}

function groupBy(items, key) {
  return items.reduce((acc, item) => {
    const value = item[key] || "-";
    acc[value] = acc[value] || [];
    acc[value].push(item);
    return acc;
  }, {});
}

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function showAlert(message) {
  const alert = document.querySelector("#alert");
  alert.textContent = message;
  alert.classList.remove("hidden");
}

function clearAlert() {
  const alert = document.querySelector("#alert");
  alert.textContent = "";
  alert.classList.add("hidden");
}

function setConnection(text, mode) {
  document.querySelector("#connectionText").textContent = text;
  const dot = document.querySelector("#connectionStatus");
  dot.className = `status-dot ${mode}`;
}

function toggleAgentChat() {
  const panel = document.querySelector("#agentChatPanel");
  const isOpen = panel.classList.toggle("open");
  panel.classList.toggle("collapsed", !isOpen);
  document.body.classList.toggle("chat-open", isOpen);
  document.querySelector("#agentChatToggle").setAttribute("aria-expanded", String(isOpen));
}

function setAgentPanel(panelName) {
  document.querySelectorAll(".agent-panel-tab").forEach((button) => {
    button.classList.toggle("active", button.dataset.agentPanel === panelName);
  });
  document.querySelectorAll(".agent-panel-section").forEach((section) => {
    section.classList.toggle("active", section.dataset.agentSection === panelName);
  });
  document.querySelector("#agentChatForm").classList.toggle("hidden", panelName !== "reuniao");
}

function handleAgentChatSubmit(event) {
  event.preventDefault();
  const input = document.querySelector("#agentChatInput");
  const text = input.value.trim();
  if (!text) return;

  appendChatMessage("Você", text, "user");
  input.value = "";
  appendChatMessage(
    "Agente Genius",
    "Mensagem registrada no ambiente local do módulo. Na próxima etapa, este canal poderá ser conectado aos agentes reais e ao Genius Hub.",
    "agent"
  );
}

function appendChatMessage(author, text, type) {
  const messages = document.querySelector("#agentChatMessages");
  const item = document.createElement("div");
  item.className = `chat-message ${type}`;
  item.innerHTML = `<strong>${escapeHtml(author)}</strong><span>${escapeHtml(text)}</span>`;
  messages.appendChild(item);
  messages.scrollTop = messages.scrollHeight;
}
