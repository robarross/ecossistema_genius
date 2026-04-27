import fs from "node:fs/promises";
import path from "node:path";

const modulePath = "E:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/genius_systems_modulares/01_A_Modulos_Administrativo_Corporativo/02_Mod_Gestao_Unidade_Agricola";
const moduleName = "Mod_Gestao_Unidade_Agricola";

function mdTable(headers, rows) {
  return [
    `| ${headers.join(" | ")} |`,
    `| ${headers.map(() => "---").join(" | ")} |`,
    ...rows.map((row) => `| ${row.map((cell) => String(cell ?? "").replaceAll("\n", " ")).join(" | ")} |`)
  ].join("\n");
}

const agents = [
  ["agente_cadastro_unidade", "Cadastro e completude", "Valida dados básicos, campos obrigatórios, duplicidades e status cadastral.", "Cadastro_Propriedades, fractais de cadastro", "cadastro.incompleto, cadastro.validado"],
  ["agente_proprietarios_vinculos", "Proprietários e vínculos", "Confere titulares, possuidores, vínculos, documentos e inconsistências.", "sub_proprietarios_possuidores", "proprietario.vinculado, titularidade.pendente"],
  ["agente_responsaveis_permissoes", "Responsáveis e permissões", "Analisa responsáveis, perfis, autorizações e coerência das permissões.", "sub_responsaveis_gestores, sub_chaves_permissoes", "permissao.inconsistente, responsavel.validado"],
  ["agente_territorial_areas", "Território e áreas", "Valida áreas, talhões, glebas, limites, acessos e relação territorial.", "sub_territorios_areas_producao, sub_limites_acessos", "area.sem_vinculo, territorio.validado"],
  ["agente_documental", "Documentos e vencimentos", "Monitora documentos obrigatórios, vencimentos, anexos e evidências.", "sub_documentacao_unidade", "documento.vencido, documento.validado"],
  ["agente_ativos_estruturais", "Ativos estruturais", "Verifica estruturas, benfeitorias, equipamentos fixos e estado de conservação.", "sub_base_ativos_estruturais_unidade", "ativo.registrado, manutencao.sugerida"],
  ["agente_status_pendencias", "Status e pendências", "Consolida status operacional, riscos, bloqueios e pendências abertas.", "sub_status_operacional_unidade", "pendencia.criada, risco.detectado"],
  ["agente_prestacao_contas", "Prestação de contas", "Gera visão de evidências, conformidade, histórico e prestação de contas.", "sub_prestacao_contas_unidade", "prestacao.atualizada, conformidade.calculada"],
  ["agente_integracao_ecossistema", "Integração", "Sincroniza Hub, DataLake, APIs, dashboards e módulos consumidores.", "fractais de integração, eventos, APIs", "sync.executado, evento.publicado"],
  ["agente_auditor_unidade", "Auditoria", "Revisa trilhas, eventos, alterações, evidências e coerência geral do módulo.", "todos os fractais", "auditoria.alerta, auditoria.concluida"]
];

const automations = [
  ["auto_validar_cadastro_minimo", "Ao criar/atualizar unidade", "Verifica campos mínimos e atualiza status cadastral.", "agente_cadastro_unidade", "cadastro.validado ou cadastro.incompleto"],
  ["auto_alertar_documento_vencido", "Diariamente ou por upload", "Detecta documentos vencidos ou próximos do vencimento.", "agente_documental", "documento.vencido"],
  ["auto_criar_pendencia_documental", "Documento inválido/vencido", "Cria pendência vinculada à unidade e responsável.", "agente_status_pendencias", "pendencia.criada"],
  ["auto_validar_vinculo_proprietario", "Titular criado/alterado", "Confere vínculo com unidade e consistência documental.", "agente_proprietarios_vinculos", "proprietario.vinculado"],
  ["auto_verificar_area_sem_unidade", "Área/talhão criado", "Bloqueia área sem id_unidade_agricola válido.", "agente_territorial_areas", "area.sem_vinculo"],
  ["auto_sugerir_manutencao_ativo", "Ativo estrutural com conservação ruim", "Cria recomendação para manutenção ou inspeção.", "agente_ativos_estruturais", "manutencao.sugerida"],
  ["auto_atualizar_dashboard_status", "Evento de fractal validado", "Atualiza métricas de status, pendências e completude.", "agente_integracao_ecossistema", "dashboard.atualizado"],
  ["auto_publicar_evento_hub", "Registro criado/atualizado/validado", "Publica evento padronizado no Genius Hub.", "agente_integracao_ecossistema", "evento.publicado"],
  ["auto_indexar_datalake", "Evento publicado", "Envia payload e metadados para DataLake.", "agente_integracao_ecossistema", "datalake.indexado"],
  ["auto_gerar_relatorio_conformidade", "Fechamento semanal/mensal", "Gera resumo de conformidade e prestação de contas.", "agente_prestacao_contas", "conformidade.calculada"],
  ["auto_auditar_inconsistencias", "Rotina agendada", "Procura registros órfãos, sync erro, pendências antigas e eventos sem consumo.", "agente_auditor_unidade", "auditoria.alerta"],
  ["auto_liberar_modulos_consumidores", "Unidade validada", "Sinaliza módulos de produção, fiscal, financeiro, territorial e marketplace.", "agente_integracao_ecossistema", "modulos_consumidores.liberados"]
];

const rules = [
  ["RN-001", "Cadastro mínimo", "Unidade só pode ficar Ativa se tiver código, nome, município, UF, status e responsável principal.", "Bloquear ativação e criar pendência."],
  ["RN-002", "Unicidade de código", "codigo_unidade/codigo_propriedade deve ser único no escopo da organização.", "Impedir duplicidade."],
  ["RN-003", "Área vinculada", "Área, talhão ou gleba precisa estar vinculada a uma unidade agrícola válida.", "Marcar registro como erro."],
  ["RN-004", "Documento vencido", "Documento vencido altera status documental e gera pendência.", "Criar evento documento.vencido."],
  ["RN-005", "Responsável autorizado", "Responsável só pode executar ações compatíveis com perfil e permissão.", "Bloquear ação e registrar auditoria."],
  ["RN-006", "Ativo estrutural vinculado", "Ativo estrutural precisa ter unidade, localização ou área operacional vinculada.", "Manter como pendente."],
  ["RN-007", "Status consolidado", "Status operacional deve considerar cadastro, documentos, áreas, ativos, pendências e sync.", "Atualizar dashboard de status."],
  ["RN-008", "Sync obrigatório", "Registro validado deve ser enviado para Hub/DataLake/APIs conforme configuração.", "Criar evento sincronizado ou erro."],
  ["RN-009", "Payload auditável", "Payload flexível deve manter origem, usuário, data e status.", "Bloquear payload sem metadados mínimos."],
  ["RN-010", "Prestação de contas", "Pendências críticas impedem fechamento de prestação de contas como concluída.", "Manter status em revisão."],
  ["RN-011", "Integração com Construções Rurais", "Ativos estruturais da unidade servem de base, mas detalhamento técnico é do módulo Construções Rurais.", "Publicar evento para módulo consumidor."],
  ["RN-012", "Integração com Produção", "Módulos produtivos só devem consumir unidade/área validada.", "Liberar consumo após status validado."]
];

const playbookSteps = [
  ["01", "Cadastrar unidade agrícola", "Criar registro raiz da unidade com dados mínimos e localização.", "Unidade criada com status pendente ou em validação."],
  ["02", "Cadastrar proprietários e possuidores", "Vincular titulares, documentos e tipo de relação com a unidade.", "Titularidade estruturada."],
  ["03", "Cadastrar responsáveis e gestores", "Definir responsáveis administrativos, técnicos e operacionais.", "Responsabilidades e permissões iniciais definidas."],
  ["04", "Cadastrar áreas, talhões e glebas", "Informar áreas produtivas, usos, coordenadas e vínculos.", "Base territorial operacional criada."],
  ["05", "Registrar limites e acessos", "Mapear acessos, porteiras, ramais, pontos críticos e circulação.", "Acessos operacionais rastreáveis."],
  ["06", "Anexar documentação da unidade", "Cadastrar documentos fundiários, ambientais, fiscais e evidências.", "Status documental calculável."],
  ["07", "Registrar ativos estruturais", "Cadastrar estruturas, benfeitorias, equipamentos fixos e conservação.", "Base para Construções Rurais e Manutenção."],
  ["08", "Configurar chaves e permissões", "Definir acessos físicos/digitais, perfis e autorizações.", "Governança operacional aplicada."],
  ["09", "Validar status operacional", "Consolidar cadastro, documentos, áreas, ativos, riscos e pendências.", "Unidade pronta ou com pendências claras."],
  ["10", "Publicar eventos e sincronizar", "Enviar eventos para Hub, DataLake, dashboards e APIs.", "Ecossistema atualizado."],
  ["11", "Revisar dashboards e KPIs", "Acompanhar status, completude, riscos, documentos e integrações.", "Gestão visual pronta para decisão."],
  ["12", "Fechar prestação de contas", "Consolidar evidências, pendências, histórico e conformidade.", "Ciclo operacional auditável."]
];

const agentsDoc = `# AGENTES_Mod_Gestao_Unidade_Agricola

Este catálogo define os agentes operacionais do módulo Gestão da Unidade Agrícola.

## Papel dos agentes

Os agentes executam validações, alertas, auditorias, sincronizações e recomendações sobre os fractais do módulo.

## Agentes recomendados

${mdTable(["agente", "area", "funcao", "fontes", "eventos"], agents)}

## Regra de atuação

Cada agente deve operar sobre um conjunto claro de fractais, publicar eventos padronizados, respeitar permissões/RLS e alimentar dashboards.
`;

const automationsDoc = `# AUTOMACOES_Mod_Gestao_Unidade_Agricola

Este documento define automações operacionais e inteligentes do módulo.

## Automações recomendadas

${mdTable(["automacao", "gatilho", "acao", "agente_responsavel", "saida"], automations)}

## Prioridade de implantação

1. Validação de cadastro mínimo.
2. Alerta de documentos vencidos.
3. Publicação de eventos no Hub.
4. Atualização de dashboards.
5. Sincronização DataLake/APIs.
6. Auditoria de inconsistências.
`;

const rulesDoc = `# REGRAS_NEGOCIO_Mod_Gestao_Unidade_Agricola

Este documento define as regras de negócio mínimas para tornar o módulo consistente e plug and play.

## Regras

${mdTable(["codigo", "regra", "descricao", "acao"], rules)}

## Regra central

A unidade agrícola deve ser tratada como entidade base do ecossistema. Módulos produtivos, territoriais, financeiros, fiscais, construtivos e comerciais podem consumir seus dados, mas devem respeitar status, permissões e eventos publicados.
`;

const playbookDoc = `# PLAYBOOK_OPERACIONAL_Mod_Gestao_Unidade_Agricola

Este playbook orienta a operação prática do módulo Gestão da Unidade Agrícola.

## Sequência operacional

${mdTable(["ordem", "etapa", "acao", "resultado"], playbookSteps)}

## Critérios de unidade pronta

- Cadastro mínimo preenchido.
- Proprietário/possuidor vinculado.
- Responsável principal definido.
- Área ou localização operacional cadastrada.
- Documentos mínimos anexados ou pendências registradas.
- Status operacional calculado.
- Eventos publicados no Hub.
- Dados indexados no DataLake.
- Dashboards atualizados.

## Saída esperada

Uma unidade agrícola pronta para ser consumida por produção vegetal, produção animal, georreferenciamento, regularização fundiária, construções rurais, manutenção, financeiro, fiscal, marketplace e dashboards executivos.
`;

const outputs = [
  ["AGENTES_Mod_Gestao_Unidade_Agricola.md", agentsDoc],
  ["AUTOMACOES_Mod_Gestao_Unidade_Agricola.md", automationsDoc],
  ["REGRAS_NEGOCIO_Mod_Gestao_Unidade_Agricola.md", rulesDoc],
  ["PLAYBOOK_OPERACIONAL_Mod_Gestao_Unidade_Agricola.md", playbookDoc]
];

for (const [file, content] of outputs) {
  await fs.writeFile(path.join(modulePath, file), content, "utf8");
}

for (const [file] of outputs) {
  await fs.access(path.join(modulePath, file));
}

console.log(`AGENTES=${agents.length}`);
console.log(`AUTOMACOES=${automations.length}`);
console.log(`REGRAS=${rules.length}`);
console.log(`PLAYBOOK_ETAPAS=${playbookSteps.length}`);
console.log(`ARQUIVOS=${outputs.length}`);
console.log("STATUS=OK");
