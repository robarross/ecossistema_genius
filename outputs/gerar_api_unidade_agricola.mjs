import fs from "node:fs/promises";
import path from "node:path";

const modulePath = "E:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/genius_systems_modulares/01_A_Modulos_Administrativo_Corporativo/02_Mod_Gestao_Unidade_Agricola";
const moduleName = "Mod_Gestao_Unidade_Agricola";

async function readJson(filePath) {
  return JSON.parse(await fs.readFile(filePath, "utf8"));
}

async function exists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function collectFractals() {
  const dnaPath = path.join(modulePath, "1_DNA_Processo");
  const result = [];
  const centralPath = path.join(dnaPath, "fractais_modulo");
  for (const entry of await fs.readdir(centralPath, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const fractalPath = path.join(centralPath, entry.name);
    result.push({
      nivel: "modulo",
      submodulo: "N/A",
      nome: entry.name,
      manifesto: await readJson(path.join(fractalPath, "manifesto_fractal.json"))
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
      result.push({
        nivel: "submodulo",
        submodulo: sub.name,
        nome: entry.name,
        manifesto: await readJson(path.join(fractalPath, "manifesto_fractal.json"))
      });
    }
  }
  return result.sort((a, b) => `${a.submodulo}/${a.nome}`.localeCompare(`${b.submodulo}/${b.nome}`));
}

function cleanEventName(fractalName) {
  return fractalName.replace(/^\d+_/, "");
}

function mdTable(headers, rows) {
  return [
    `| ${headers.join(" | ")} |`,
    `| ${headers.map(() => "---").join(" | ")} |`,
    ...rows.map((row) => `| ${row.map((cell) => String(cell ?? "").replaceAll("\n", " ")).join(" | ")} |`)
  ].join("\n");
}

const fractals = await collectFractals();
const sampleFractals = fractals.slice(0, 10);
const events = fractals.flatMap((item) => ["criado", "atualizado", "validado", "sincronizado"].map((action) => `unidade_agricola.${cleanEventName(item.nome)}.${action}`));

const openapi = `openapi: 3.1.0
info:
  title: API - Gestão da Unidade Agrícola
  version: 0.1.0
  description: Contrato OpenAPI plug and play do ${moduleName}.
servers:
  - url: https://api.genius.local/v1
    description: Ambiente lógico do ecossistema Genius
security:
  - bearerAuth: []
tags:
  - name: Unidades Agrícolas
  - name: Fractais
  - name: Eventos
  - name: Integrações
paths:
  /unidades-agricolas:
    get:
      tags: [Unidades Agrícolas]
      summary: Lista unidades agrícolas
      parameters:
        - in: query
          name: status_cadastro
          schema: { type: string }
        - in: query
          name: uf
          schema: { type: string }
        - in: query
          name: municipio
          schema: { type: string }
      responses:
        "200":
          description: Lista de unidades agrícolas
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "#/components/schemas/UnidadeAgricola"
    post:
      tags: [Unidades Agrícolas]
      summary: Cria uma unidade agrícola
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/UnidadeAgricolaInput"
      responses:
        "201":
          description: Unidade agrícola criada
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/UnidadeAgricola"
  /unidades-agricolas/{id_unidade_agricola}:
    get:
      tags: [Unidades Agrícolas]
      summary: Busca unidade agrícola por ID
      parameters:
        - $ref: "#/components/parameters/IdUnidadeAgricola"
      responses:
        "200":
          description: Unidade agrícola encontrada
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/UnidadeAgricola"
    patch:
      tags: [Unidades Agrícolas]
      summary: Atualiza unidade agrícola
      parameters:
        - $ref: "#/components/parameters/IdUnidadeAgricola"
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/UnidadeAgricolaInput"
      responses:
        "200":
          description: Unidade agrícola atualizada
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/UnidadeAgricola"
  /unidades-agricolas/{id_unidade_agricola}/fractais:
    get:
      tags: [Fractais]
      summary: Lista registros de fractais vinculados à unidade agrícola
      parameters:
        - $ref: "#/components/parameters/IdUnidadeAgricola"
        - in: query
          name: fractal
          schema: { type: string }
        - in: query
          name: status
          schema: { type: string }
      responses:
        "200":
          description: Registros de fractais
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "#/components/schemas/FractalRegistro"
  /unidades-agricolas/{id_unidade_agricola}/fractais/{nome_fractal}:
    post:
      tags: [Fractais]
      summary: Cria registro em um fractal da unidade agrícola
      parameters:
        - $ref: "#/components/parameters/IdUnidadeAgricola"
        - $ref: "#/components/parameters/NomeFractal"
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/FractalRegistroInput"
      responses:
        "201":
          description: Registro de fractal criado
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/FractalRegistro"
  /eventos:
    get:
      tags: [Eventos]
      summary: Lista eventos publicados pelo módulo
      parameters:
        - in: query
          name: nome_evento
          schema: { type: string }
        - in: query
          name: id_unidade_agricola
          schema: { type: string, format: uuid }
      responses:
        "200":
          description: Eventos do módulo
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "#/components/schemas/EventoFractal"
  /fractais/{nome_fractal}/eventos:
    post:
      tags: [Eventos]
      summary: Publica evento de um fractal
      parameters:
        - $ref: "#/components/parameters/NomeFractal"
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/EventoFractalInput"
      responses:
        "202":
          description: Evento aceito para publicação
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/EventoFractal"
  /integracoes/sync:
    post:
      tags: [Integrações]
      summary: Sincroniza módulo com Hub, DataLake, Supabase e dashboards
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                id_unidade_agricola: { type: string, format: uuid }
                destino:
                  type: string
                  enum: [genius_hub, datalake, dashboards_bi, integracoes_apis, todos]
      responses:
        "202":
          description: Sincronização aceita
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  parameters:
    IdUnidadeAgricola:
      in: path
      name: id_unidade_agricola
      required: true
      schema: { type: string, format: uuid }
    NomeFractal:
      in: path
      name: nome_fractal
      required: true
      schema: { type: string }
  schemas:
    UnidadeAgricolaInput:
      type: object
      required: [codigo_unidade, nome_unidade]
      properties:
        codigo_unidade: { type: string }
        nome_unidade: { type: string }
        tipo_unidade: { type: string }
        status_cadastro: { type: string }
        situacao_operacional: { type: string }
        uf: { type: string }
        municipio: { type: string }
        latitude_sede: { type: number }
        longitude_sede: { type: number }
        area_total_ha: { type: number }
        payload: { type: object, additionalProperties: true }
    UnidadeAgricola:
      allOf:
        - $ref: "#/components/schemas/UnidadeAgricolaInput"
        - type: object
          properties:
            id_unidade_agricola: { type: string, format: uuid }
            sync_status: { type: string }
            created_at: { type: string, format: date-time }
            updated_at: { type: string, format: date-time }
    FractalRegistroInput:
      type: object
      required: [payload]
      properties:
        id_origem: { type: string }
        status: { type: string, enum: [pendente, validado, sincronizado, erro, inativo] }
        payload: { type: object, additionalProperties: true }
        sync_status: { type: string }
    FractalRegistro:
      allOf:
        - $ref: "#/components/schemas/FractalRegistroInput"
        - type: object
          properties:
            id_fractal_registro: { type: string, format: uuid }
            id_unidade_agricola: { type: string, format: uuid }
            nome_fractal: { type: string }
            created_at: { type: string, format: date-time }
            updated_at: { type: string, format: date-time }
    EventoFractalInput:
      type: object
      required: [nome_evento, id_unidade_agricola, fractal_origem]
      properties:
        nome_evento: { type: string }
        id_unidade_agricola: { type: string, format: uuid }
        id_fractal_registro: { type: string, format: uuid }
        modulo_origem: { type: string, default: "${moduleName}" }
        submodulo_origem: { type: string }
        fractal_origem: { type: string }
        status: { type: string }
        payload: { type: object, additionalProperties: true }
    EventoFractal:
      allOf:
        - $ref: "#/components/schemas/EventoFractalInput"
        - type: object
          properties:
            id_evento: { type: string, format: uuid }
            published_at: { type: string, format: date-time }
`;

const apiRows = [
  ["GET", "/unidades-agricolas", "Lista unidades agrícolas para consumo operacional e dashboards."],
  ["POST", "/unidades-agricolas", "Cria unidade agrícola e inicia fluxo dos fractais centrais."],
  ["GET", "/unidades-agricolas/{id}", "Busca unidade agrícola consolidada."],
  ["PATCH", "/unidades-agricolas/{id}", "Atualiza unidade agrícola e publica evento de atualização."],
  ["GET", "/unidades-agricolas/{id}/fractais", "Lista registros dos fractais vinculados à unidade."],
  ["POST", "/unidades-agricolas/{id}/fractais/{nome_fractal}", "Cria registro em fractal específico."],
  ["GET", "/eventos", "Consulta eventos publicados pelo módulo."],
  ["POST", "/fractais/{nome_fractal}/eventos", "Publica evento de fractal para Hub/DataLake/APIs."],
  ["POST", "/integracoes/sync", "Dispara sincronização com Hub, DataLake, dashboards e APIs."]
];

const contractDoc = `# API_CONTRATO_Mod_Gestao_Unidade_Agricola

Este documento explica como outros modulos, plataformas, agentes e automacoes devem consumir o modulo Gestão da Unidade Agrícola.

## Papel da API

A API transforma o modulo em um componente plug and play. Outros modulos nao precisam conhecer a estrutura interna dos 68 fractais; eles podem consumir endpoints padronizados de unidade agricola, fractais e eventos.

## Endpoints principais

${mdTable(["metodo", "endpoint", "funcao"], apiRows)}

## Modulos consumidores prioritarios

- Produção Vegetal: consome unidades, areas, talhoes, status e localizacao.
- Produção Animal/Pecuária: consome unidade, areas, ativos e responsaveis.
- Georreferenciamento: consome limites, areas, coordenadas e referencias territoriais.
- Regularização Fundiária: consome proprietarios, documentos e vinculos.
- Construções Rurais: consome ativos estruturais como base.
- Manutenção: consome ativos, acessos, estruturas e status operacional.
- Financeiro/Fiscal: consome unidade, titulares, documentos e prestacao de contas.
- Marketplace Agrícola: consome unidade validada, status e rastreabilidade.

## Regras de consumo

- Todo consumo deve informar \`id_unidade_agricola\` quando o dado for operacional.
- Todo registro de fractal deve publicar evento quando criado, atualizado, validado ou sincronizado.
- Toda integracao deve respeitar permissoes, RLS e perfil do usuario.
- Payloads flexiveis devem ser estabilizados em schema quando virarem regra de negocio.

## Exemplo de payload para criar unidade

\`\`\`json
{
  "codigo_unidade": "PA-0001",
  "nome_unidade": "Fazenda Santa Clara",
  "tipo_unidade": "Fazenda",
  "status_cadastro": "Ativo",
  "uf": "AM",
  "municipio": "Manaus",
  "area_total_ha": 1250.5
}
\`\`\`
`;

const webhookRows = events.map((eventName) => [
  eventName,
  "POST",
  "/webhooks/genius-hub/unidade-agricola",
  "Genius Hub, DataLake, Dashboards BI, Integracoes APIs"
]);

const webhookDoc = `# WEBHOOKS_EVENTOS_Mod_Gestao_Unidade_Agricola

Este documento define como os eventos dos fractais devem ser publicados para Genius Hub, DataLake, dashboards e outros modulos.

## Endpoint receptor sugerido

\`\`\`text
POST /webhooks/genius-hub/unidade-agricola
\`\`\`

## Headers sugeridos

- \`Authorization: Bearer <token>\`
- \`X-Genius-Module: ${moduleName}\`
- \`X-Genius-Event: <nome_evento>\`
- \`X-Genius-Trace-Id: <uuid>\`

## Payload padrao

\`\`\`json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.fractal_identidade_unidade.criado",
  "id_unidade_agricola": "uuid",
  "id_fractal_registro": "uuid",
  "modulo_origem": "${moduleName}",
  "submodulo_origem": "N/A",
  "fractal_origem": "01_fractal_identidade_unidade",
  "status": "pendente",
  "payload": {},
  "published_at": "timestamp"
}
\`\`\`

## Eventos catalogados

Total de eventos: ${events.length}

${mdTable(["evento", "metodo", "endpoint", "consumidores"], webhookRows)}
`;

const sdkDoc = `# SDK_CLIENT_Mod_Gestao_Unidade_Agricola

Este guia mostra como agentes, automacoes, apps e integracoes podem consumir a API do modulo.

## Cliente logico

\`\`\`ts
type GeniusClientConfig = {
  baseUrl: string;
  token: string;
};

class UnidadeAgricolaClient {
  constructor(private config: GeniusClientConfig) {}

  async listarUnidades(filtros = {}) {
    return request("GET", "/unidades-agricolas", filtros);
  }

  async criarUnidade(payload) {
    return request("POST", "/unidades-agricolas", payload);
  }

  async listarFractais(idUnidadeAgricola: string) {
    return request("GET", \`/unidades-agricolas/\${idUnidadeAgricola}/fractais\`);
  }

  async criarRegistroFractal(idUnidadeAgricola: string, nomeFractal: string, payload) {
    return request("POST", \`/unidades-agricolas/\${idUnidadeAgricola}/fractais/\${nomeFractal}\`, payload);
  }

  async publicarEvento(nomeFractal: string, payload) {
    return request("POST", \`/fractais/\${nomeFractal}/eventos\`, payload);
  }
}
\`\`\`

## Casos de uso para agentes

- Validar se uma unidade agricola esta pronta para producao.
- Verificar documentos pendentes.
- Criar tarefas a partir de pendencias dos fractais.
- Sincronizar dados com DataLake.
- Atualizar dashboards apos mudanca de status.
- Alimentar outros modulos com dados da unidade.

## Fractais disponiveis para consumo inicial

${mdTable(["nivel", "submodulo", "fractal", "descricao"], sampleFractals.map((item) => [item.nivel, item.submodulo, item.nome, item.manifesto.descricao]))}

## Observacao

O SDK real pode ser implementado depois em TypeScript, Python ou Edge Functions. Este arquivo define o contrato de uso para manter agentes e integracoes alinhados.
`;

const outputs = [
  ["OPENAPI_Mod_Gestao_Unidade_Agricola.yaml", openapi],
  ["API_CONTRATO_Mod_Gestao_Unidade_Agricola.md", contractDoc],
  ["WEBHOOKS_EVENTOS_Mod_Gestao_Unidade_Agricola.md", webhookDoc],
  ["SDK_CLIENT_Mod_Gestao_Unidade_Agricola.md", sdkDoc]
];

for (const [file, content] of outputs) {
  await fs.writeFile(path.join(modulePath, file), content, "utf8");
}

for (const [file] of outputs) {
  await fs.access(path.join(modulePath, file));
}

console.log(`FRACTAIS=${fractals.length}`);
console.log(`EVENTOS=${events.length}`);
console.log(`ARQUIVOS_API=${outputs.length}`);
console.log("STATUS=OK");
