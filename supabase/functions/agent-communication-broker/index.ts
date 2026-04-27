import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const BOT_TOKEN = Deno.env.get('TELEGRAM_BOT_TOKEN')
const ALLOWED_ID = Deno.env.get('ALLOWED_TELEGRAM_ID')
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

const supabase = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
)

serve(async (req) => {
  try {
    const payload = await req.json()
    const message = payload.message

    if (!message || String(message.from.id) !== ALLOWED_ID) {
      console.log("Acesso negado ou mensagem vazia.")
      return new Response(JSON.stringify({ ok: false, error: "Unauthorized" }), { status: 200 })
    }

    const text = message.text
    const chatId = message.chat.id

    // Lógica Cognitiva (Gemini 1.5 Flash)
    // Aqui o Agente #30 interpretaria o texto e executaria ações no banco.
    // Exemplo Simples de Resposta:
    let responseText = "Comando recebido. Estou processando via Gemini..."

    if (text.toLowerCase().includes("quem é você")) {
      responseText = "Olá! Sou o Agente #30, seu Broker de Comunicação Extraterritorial do Ecossistema Genius. 🛰️"
    } else if (text.toLowerCase().includes("buscar") || text.toLowerCase().includes("pesquisar") || text.toLowerCase().includes("onde está")) {
      const query = text.replace(/buscar|pesquisar|onde está/gi, "").trim();
      
      const { data: assets } = await supabase
        .from('library_assets')
        .select('file_name, file_path, summary')
        .or(`file_name.ilike.%${query}%,tags.cs.{${query}}`)
      
      if (assets && assets.length > 0) {
        responseText = `🔍 Encontrei ${assets.length} ativo(s) para "${query}":\n\n` + 
          assets.map(a => `📄 *${a.file_name}*\n📍 _${a.file_path}_\n📝 ${a.summary}`).join('\n\n');
      } else {
        responseText = `❌ Não encontrei nenhum ativo relacionado a "${query}" na biblioteca.`;
      }
    } else if (text.toLowerCase().includes("status")) {
      // Exemplo de consulta ao banco
      const { data: agents } = await supabase.from('agents').select('display_id, status')
      responseText = "📊 Status dos Agentes Principais:\n" + 
        agents?.map(a => `${a.display_id}: ${a.status}`).join('\n')
    }

    // Enviar Resposta via Telegram API
    await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chat_id: chatId,
        text: responseText
      })
    })

    return new Response(JSON.stringify({ ok: true }), { status: 200 })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})
