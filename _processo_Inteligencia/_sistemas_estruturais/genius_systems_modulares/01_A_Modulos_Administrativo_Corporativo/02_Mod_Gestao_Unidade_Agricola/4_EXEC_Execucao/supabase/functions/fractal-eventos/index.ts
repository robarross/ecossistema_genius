// Supabase Edge Function: fractal-eventos
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
