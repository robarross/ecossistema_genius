import os
from typing import Dict, Any, List
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage

def matcher_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Matcher-01 (Validador de Blueprints).
    Enriquece tickets incompletos com especificações técnicas inteligentes.
    """
    queue = state.get("context_data", {}).get("production_queue", [])
    if not queue:
        return state
        
    print(f"MATCHER [MATCHER] Validando e enriquecendo {len(queue)} tickets de produção.")
    
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0.3)
    
    enriched_queue = []
    for ticket in queue:
        # Se o ticket já estiver completo, pula a pesquisa
        if ticket.get("inputs") and ticket.get("skills"):
            enriched_queue.append(ticket)
            continue
            
        print(f"   -> Projetando especificações técnicas para: {ticket['nome']}")
        
        system_prompt = """
        Você é o #Matcher-01 do Ecossistema Genius. 
        Sua tarefa é projetar os Sockets (I/O) e as Skills de um módulo baseado apenas no seu Nome e Setor.
        
        Retorne um JSON com:
        - inputs: lista de dados de entrada necessários.
        - outputs: lista de dados de saída gerados.
        - skills: lista de competências do agente.
        """
        
        human_prompt = f"MÓDULO: {ticket['nome']}\nSETOR: {ticket['setor']}\nOBJETIVO: {ticket.get('objetivo', 'Não especificado')}"
        
        try:
            response = llm.invoke([
                SystemMessage(content=system_prompt),
                HumanMessage(content=human_prompt)
            ])
            
            # Parsing simples do JSON (assumindo que o LLM respeita o formato)
            import json
            # Limpeza de markdown se necessário
            clean_res = response.content.replace("```json", "").replace("```", "").strip()
            specs = json.loads(clean_res)
            
            # Enriquecer o ticket
            ticket["inputs"] = specs.get("inputs", [])
            ticket["outputs"] = specs.get("outputs", [])
            ticket["skills"] = specs.get("skills", [])
            
            enriched_queue.append(ticket)
        except Exception as e:
            print(f"   ⚠️ Falha ao enriquecer {ticket['nome']}: {e}")
            enriched_queue.append(ticket) # Mantém o original se falhar

    state["context_data"]["production_queue"] = enriched_queue
    return state
