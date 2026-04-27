import fs from "node:fs/promises";
import path from "node:path";

const modulePath = "E:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/genius_systems_modulares/01_A_Modulos_Administrativo_Corporativo/02_Mod_Gestao_Unidade_Agricola";
const execPath = path.join(modulePath, "4_EXEC_Execucao");
const sourceSql = path.join(modulePath, "SUPABASE_SCHEMA_Mod_Gestao_Unidade_Agricola.sql");

async function write(filePath, content) {
  await fs.mkdir(path.dirname(filePath), { recursive: true });
  await fs.writeFile(filePath, content, "utf8");
}

const migrationSql = await fs.readFile(sourceSql, "utf8");

const seedSql = `-- seed_unidade_agricola.sql
-- Dados mínimos para testar o Mod_Gestao_Unidade_Agricola após executar a migration.

insert into unidade_agricola.unidades_agricolas (
  codigo_unidade,
  nome_unidade,
  tipo_unidade,
  status_cadastro,
  situacao_operacional,
  uf,
  municipio,
  latitude_sede,
  longitude_sede,
  area_total_ha,
  payload,
  sync_status
) values (
  'PA-SEED-0001',
  'Fazenda Piloto Genius',
  'Fazenda',
  'Ativo',
  'Em operacao',
  'AM',
  'Manaus',
  -3.1190,
  -60.0210,
  1250.50,
  '{"origem":"seed","modulo":"Mod_Gestao_Unidade_Agricola"}'::jsonb,
  'validado'
)
on conflict (codigo_unidade) do update set
  nome_unidade = excluded.nome_unidade,
  status_cadastro = excluded.status_cadastro,
  sync_status = excluded.sync_status,
  updated_at = now();

with unidade as (
  select id_unidade_agricola
  from unidade_agricola.unidades_agricolas
  where codigo_unidade = 'PA-SEED-0001'
  limit 1
), fractal as (
  insert into unidade_agricola.fractal_identidade_unidade (
    id_unidade_agricola,
    id_origem,
    status,
    payload,
    sync_status
  )
  select
    id_unidade_agricola,
    'seed_identidade_001',
    'validado',
    '{"codigo":"PA-SEED-0001","nome":"Fazenda Piloto Genius","tipo":"Fazenda"}'::jsonb,
    'validado'
  from unidade
  returning id_fractal_registro, id_unidade_agricola
)
insert into unidade_agricola.fractal_eventos_log (
  nome_evento,
  id_unidade_agricola,
  id_fractal_registro,
  modulo_origem,
  submodulo_origem,
  fractal_origem,
  status,
  payload
)
select
  'unidade_agricola.fractal_identidade_unidade.validado',
  id_unidade_agricola,
  id_fractal_registro,
  'Mod_Gestao_Unidade_Agricola',
  null,
  '01_fractal_identidade_unidade',
  'validado',
  '{"origem":"seed","acao":"validacao_inicial"}'::jsonb
from fractal;
`;

const testsSql = `-- TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql
-- Consultas rápidas para validar se a migration e o seed foram aplicados.

select 'schemas' as teste, count(*) as total
from information_schema.schemata
where schema_name = 'unidade_agricola';

select 'tabelas_unidade_agricola' as teste, count(*) as total
from information_schema.tables
where table_schema = 'unidade_agricola';

select 'eventos_catalogados' as teste, count(*) as total
from unidade_agricola.fractal_eventos_catalogo;

select 'unidades_seed' as teste, count(*) as total
from unidade_agricola.unidades_agricolas
where codigo_unidade = 'PA-SEED-0001';

select 'eventos_seed' as teste, count(*) as total
from unidade_agricola.fractal_eventos_log
where payload->>'origem' = 'seed';

select
  u.codigo_unidade,
  u.nome_unidade,
  u.status_cadastro,
  f.status as status_fractal_identidade,
  f.sync_status
from unidade_agricola.unidades_agricolas u
left join unidade_agricola.fractal_identidade_unidade f
  on f.id_unidade_agricola = u.id_unidade_agricola
where u.codigo_unidade = 'PA-SEED-0001';
`;

const apiFunction = `// Supabase Edge Function: unidade-agricola-api
// Endpoints lógicos:
// GET /unidade-agricola-api/unidades
// GET /unidade-agricola-api/unidades/:id/fractais
// POST /unidade-agricola-api/unidades

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  const supabase = createClient(supabaseUrl, supabaseKey, {
    global: { headers: { Authorization: req.headers.get("Authorization") ?? "" } },
  });

  const url = new URL(req.url);
  const parts = url.pathname.split("/").filter(Boolean);

  try {
    if (req.method === "GET" && parts.at(-1) === "unidades") {
      const { data, error } = await supabase
        .schema("unidade_agricola")
        .from("unidades_agricolas")
        .select("*")
        .order("created_at", { ascending: false });
      if (error) throw error;
      return json(data);
    }

    if (req.method === "POST" && parts.at(-1) === "unidades") {
      const payload = await req.json();
      const { data, error } = await supabase
        .schema("unidade_agricola")
        .from("unidades_agricolas")
        .insert(payload)
        .select("*")
        .single();
      if (error) throw error;
      return json(data, 201);
    }

    const fractaisIndex = parts.findIndex((part) => part === "fractais");
    if (req.method === "GET" && fractaisIndex > 0) {
      const idUnidade = parts[fractaisIndex - 1];
      const { data, error } = await supabase
        .schema("unidade_agricola")
        .from("fractal_eventos_log")
        .select("*")
        .eq("id_unidade_agricola", idUnidade)
        .order("published_at", { ascending: false });
      if (error) throw error;
      return json(data);
    }

    return json({ error: "rota_nao_encontrada" }, 404);
  } catch (error) {
    return json({ error: String(error?.message ?? error) }, 500);
  }
});

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
`;

const eventFunction = `// Supabase Edge Function: fractal-eventos
// POST /fractal-eventos
// Publica um evento no log do modulo Gestão da Unidade Agrícola.

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return json({ error: "metodo_nao_permitido" }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
  const supabase = createClient(supabaseUrl, supabaseKey);

  try {
    const payload = await req.json();
    const required = ["nome_evento", "id_unidade_agricola", "fractal_origem"];
    for (const field of required) {
      if (!payload[field]) return json({ error: "campo_obrigatorio", field }, 400);
    }

    const { data, error } = await supabase
      .schema("unidade_agricola")
      .from("fractal_eventos_log")
      .insert({
        nome_evento: payload.nome_evento,
        id_unidade_agricola: payload.id_unidade_agricola,
        id_fractal_registro: payload.id_fractal_registro ?? null,
        modulo_origem: payload.modulo_origem ?? "Mod_Gestao_Unidade_Agricola",
        submodulo_origem: payload.submodulo_origem ?? null,
        fractal_origem: payload.fractal_origem,
        status: payload.status ?? "pendente",
        payload: payload.payload ?? {},
      })
      .select("*")
      .single();

    if (error) throw error;
    return json(data, 202);
  } catch (error) {
    return json({ error: String(error?.message ?? error) }, 500);
  }
});

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
`;

const supabaseConfig = `project_id = "mod-gestao-unidade-agricola"

[api]
enabled = true
schemas = ["public", "unidade_agricola"]
extra_search_path = ["public", "extensions"]

[functions.unidade-agricola-api]
verify_jwt = true

[functions.fractal-eventos]
verify_jwt = true
`;

const readme = `# 4_EXEC_Execucao - Mod_Gestao_Unidade_Agricola

Esta pasta contém a primeira camada executável do módulo Gestão da Unidade Agrícola.

## Conteúdo

- \`supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql\`: migration principal com schema, tabelas dos fractais, catálogo e log de eventos.
- \`supabase/seed/seed_unidade_agricola.sql\`: seed mínimo para testar uma unidade agrícola e um fractal.
- \`supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql\`: consultas de validação pós-implantação.
- \`supabase/functions/unidade-agricola-api/index.ts\`: Edge Function inicial para unidades e eventos relacionados.
- \`supabase/functions/fractal-eventos/index.ts\`: Edge Function inicial para publicação de eventos.
- \`GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola.md\`: passo a passo de implantação.

## Estado atual

Este pacote ainda não foi aplicado em um projeto Supabase real. Ele está pronto para revisão, teste em ambiente de desenvolvimento e posterior implantação.
`;

const guide = `# GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola

## Pré-requisitos

- Projeto Supabase criado.
- Supabase CLI instalada.
- Variáveis de ambiente configuradas para Edge Functions.
- Permissões revisadas antes de ativar RLS em produção.

## Passo 1 - Revisar a migration

Arquivo:

\`\`\`text
supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql
\`\`\`

Essa migration cria:

- schema \`unidade_agricola\`;
- tabela raiz \`unidades_agricolas\`;
- catálogo de eventos;
- log de eventos;
- 68 tabelas sugeridas para fractais;
- índices básicos;
- função \`set_updated_at\`.

## Passo 2 - Executar em ambiente de desenvolvimento

Via Supabase SQL Editor ou Supabase CLI:

\`\`\`powershell
supabase db push
\`\`\`

## Passo 3 - Aplicar seed

\`\`\`sql
-- executar o conteúdo de:
supabase/seed/seed_unidade_agricola.sql
\`\`\`

## Passo 4 - Validar implantação

Executar:

\`\`\`sql
-- executar o conteúdo de:
supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql
\`\`\`

Resultados esperados:

- schema \`unidade_agricola\` existente;
- tabelas criadas;
- 272 eventos catalogados;
- unidade seed criada;
- evento seed criado.

## Passo 5 - Deploy das Edge Functions

\`\`\`powershell
supabase functions deploy unidade-agricola-api
supabase functions deploy fractal-eventos
\`\`\`

## Passo 6 - Próxima etapa

Depois de validar o banco e as funções, conectar:

- planilha/formulário de cadastro;
- dashboard;
- agentes/automações;
- Genius Hub;
- DataLake;
- módulos consumidores.
`;

await write(path.join(execPath, "README.md"), readme);
await write(path.join(execPath, "GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola.md"), guide);
await write(path.join(execPath, "supabase", "config.toml"), supabaseConfig);
await write(path.join(execPath, "supabase", "migrations", "202604260001_mod_gestao_unidade_agricola.sql"), migrationSql);
await write(path.join(execPath, "supabase", "seed", "seed_unidade_agricola.sql"), seedSql);
await write(path.join(execPath, "supabase", "tests", "TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql"), testsSql);
await write(path.join(execPath, "supabase", "functions", "unidade-agricola-api", "index.ts"), apiFunction);
await write(path.join(execPath, "supabase", "functions", "fractal-eventos", "index.ts"), eventFunction);

const expected = [
  "README.md",
  "GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola.md",
  "supabase/config.toml",
  "supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql",
  "supabase/seed/seed_unidade_agricola.sql",
  "supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql",
  "supabase/functions/unidade-agricola-api/index.ts",
  "supabase/functions/fractal-eventos/index.ts",
];

let missing = 0;
for (const relative of expected) {
  try {
    await fs.access(path.join(execPath, relative));
  } catch {
    missing += 1;
  }
}

console.log(`EXEC_PATH=${execPath}`);
console.log(`ARQUIVOS_ESPERADOS=${expected.length}`);
console.log(`AUSENTES=${missing}`);
console.log("STATUS=OK");
