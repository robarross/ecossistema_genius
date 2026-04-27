import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.42.0'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  // Tratamento de requisições OPTIONS (CORS Pré-flight)
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 1. Chaves de Nuvem
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    )
    const geminiApiKey = Deno.env.get('GEMINI_API_KEY') ?? '';

    // 2. Extrai Payload enviado
    const payload = await req.json()
    const documentText = payload.documento_texto;
    
    if (!documentText) {
      throw new Error("Parâmetro 'documento_texto' ausente. Envie o texto do contrato.");
    }
    
    console.log(`[VERA] Acionada. Preparando Cognição LLM...`);

    // 3. Prompt de Cognição VERA
    const prompt = `
Você é a VERA, a Secretária de Gestão Administrativa Especialista em Agronegócio do Ecossistema Genius.
Sua missão é ler o contrato de trabalho ou arrendamento a seguir e extrair as três informações mais vitais. 
Gere a resposta estritamente em um objeto JSON válido (sem blocos de código markdown \`\`\`), seguindo essa estrutura:
{
  "fornecedor": "Qual o nome da empresa ou arrendatário? Ex: João da Silva",
  "maquinario": "O que foi alugado ou comprado? Ex: Trator John Deere",
  "valor": "O valor monetário encontrado. Ex: R$ 15.000,00 mensais"
}

Contrato / Texto:
"${documentText}"
`;

    // 4. Chamada de Rede ao Cérebro (Google Gemini 1.5 Flash API)
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${geminiApiKey}`;
    
    const geminiRes = await fetch(geminiUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }]
      })
    });

    if (!geminiRes.ok) {
       throw new Error(`Falha na API Gemini: ${geminiRes.statusText}`);
    }

    const geminiData = await geminiRes.json();
    const rawText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || "{}";
    
    // Limpeza de blocos de marcação que a LLM eventualmente retorna 
    const cleanedJsonText = rawText.replace(/```json/g, '').replace(/```/g, '').trim();
    const extractedData = JSON.parse(cleanedJsonText);

    // 5. Salva na Cadeia de Memória do Genius Bus
    const logs = [
      {
        event_type: 'SYSTEM_AUDIT',
        payload: { 
           acao: 'leitura_contrato_ia', 
           diagnostico: 'Extração Concluída pelo Gemini',
           detalhes: extractedData 
        },
        criticality: 'INFO'
      },
      {
        event_type: 'XP_GAIN',
        payload: { 
           agente: 'VERA', 
           pontos: 300, 
           razao: 'Cognição Administrativa Efetuada com Sucesso' 
        },
        criticality: 'INFO'
      }
    ];

    const { error: eventsError } = await supabaseClient.from('genius_system_events').insert(logs);
    if (eventsError) throw eventsError;
    
    // 6. Retorna para quem chamou (Front-End/Zapier)
    return new Response(
      JSON.stringify({ 
        agente: 'VERA',
        motor_cognitivo: 'Google Gemini 1.5 Flash',
        status: 'SUCESSO_IA',
        dados_extraidos: extractedData,
        xp_gerado: 300
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    )
  } catch (error) {
    return new Response(JSON.stringify({ erro: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})
