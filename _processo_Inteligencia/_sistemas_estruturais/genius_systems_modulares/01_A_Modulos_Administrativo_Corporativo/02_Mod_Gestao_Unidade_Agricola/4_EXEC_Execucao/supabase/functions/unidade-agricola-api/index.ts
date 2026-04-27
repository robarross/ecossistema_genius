// Supabase Edge Function: unidade-agricola-api
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
