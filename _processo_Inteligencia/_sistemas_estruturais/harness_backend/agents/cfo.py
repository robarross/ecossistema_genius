import os
from typing import Dict, Any
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
import json

def cfo_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #CFO-01 (Financeiro/Eficiência).
    Audita as execuções recentes e sugere otimizações.
    """
    print("CFO [CFO] Auditando eficiência do ecossistema...")
    
    from main import supabase
    if not supabase:
        print("   -> Erro: Supabase não conectado.")
        return state
        
    # Buscar as últimas 10 execuções para análise
    executions = supabase.table("harness_chat_executions").select("*").order("created_at", desc=True).limit(10).execute().data
    
    if not os.environ.get("OPENAI_API_KEY"):
        print("   -> Aviso: OPENAI_API_KEY ausente. Simulando auditoria.")
        return state

    llm = ChatOpenAI(model="gpt-4o", temperature=0.1)
    
    system_prompt = """
    Você é o #CFO-01 do Ecossistema Genius. Sua função é garantir o ROI (Retorno sobre Investimento) da inteligência.
    Analise o histórico de execuções fornecido e identifique:
    1. Agentes redundantes.
    2. Falhas recorrentes que desperdiçam tokens.
    3. Oportunidades de trocar modelos caros por mais baratos (Flash).
    
    Responda em JSON:
    {
      "auditoria": "Resumo da saúde financeira/técnica",
      "optimization_tasks": [
        {
          "title": "Título da melhoria",
          "description": "Explicação técnica da economia",
          "priority": "Urgente/Normal"
        }
      ]
    }
    """
    
    human_prompt = f"Histórico de Execuções:\n{json.dumps(executions, indent=2)}"
    
    try:
        response = llm.invoke([
            SystemMessage(content=system_prompt),
            HumanMessage(content=human_prompt)
        ])
        
        content = response.content.strip()
        if content.startswith("```json"):
            content = content[7:-3].strip()
        elif content.startswith("```"):
            content = content[3:-3].strip()
            
        result = json.loads(content)
        
        audit_summary = result.get("auditoria", "Sistema eficiente.")
        optimizations = result.get("optimization_tasks", [])
        
        print(f"   -> Auditoria: {audit_summary}")
        print(f"   -> {len(optimizations)} otimizações sugeridas.")
        
        # Inserir tarefas de otimização se necessário
        if optimizations:
            # Pegar uma lista padrão
            lists = supabase.table("clickup_lists").select("id").limit(1).execute().data
            # Pegar o ID do Agente #Flow (para automação/manutenção)
            flow_agent = supabase.table("clickup_agents").select("id").eq("display_id", "#Flow").execute().data
            
            if lists and flow_agent:
                list_id = lists[0]['id']
                agent_id = flow_agent[0]['id']
                for opt in optimizations:
                    supabase.table("clickup_tasks").insert({
                        "list_id": list_id,
                        "agent_id": agent_id,
                        "title": opt['title'],
                        "description": f"[AUDITORIA CFO] {opt['description']}",
                        "priority": opt['priority'],
                        "status": "A Fazer"
                    }).execute()
                    print(f"      + Otimização agendada: {opt['title']}")
                    
        # Adicionar ao debate do conselho
        state["board_debate"]["cfo_feedback"] = audit_summary
        
        # Adicionar ao relatório final do pipeline
        state["final_report"] += f"\n\nAUDITORIA CFO: {audit_summary}"
        
    except Exception as e:
        print(f"   -> Erro no CFO: {e}")
        
    return state
