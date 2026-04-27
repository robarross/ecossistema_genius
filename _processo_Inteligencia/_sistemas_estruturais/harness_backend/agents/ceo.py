import os
from typing import Dict, Any, List
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
from utils.resilience import GeniusResilience
import json

def list_result_hub(hub_path: str = "e:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/0_sistema_core/[SYS]__genius_core/_saidas_final") -> str:
    """
    Lista a estrutura de pastas e arquivos no Hub de Resultados para dar contexto ao CEO.
    """
    if not os.path.exists(hub_path):
        return "Erro: Hub de Resultados não encontrado."
    
    structure = []
    for root, dirs, files in os.walk(hub_path):
        level = root.replace(hub_path, '').count(os.sep)
        indent = ' ' * 4 * (level)
        folder_name = os.path.basename(root)
        if folder_name:
            structure.append(f"{indent}📁 {folder_name}/")
        
        sub_indent = ' ' * 4 * (level + 1)
        for f in files:
            structure.append(f"{sub_indent}📄 {f}")
            
    return "\n".join(structure)

def ceo_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #CEO-01 (Estratégia).
    Analisa o Hub de Resultados e gera novos decretos (tarefas).
    """
    print("CEO [CEO] Analisando o Hub de Resultados para nova estratégia...")
    
    hub_content = list_result_hub()
    
    if not os.environ.get("OPENAI_API_KEY"):
        print("   -> Aviso: OPENAI_API_KEY ausente. Simulando decreto.")
        state["final_report"] = "CEO Simulado: Hub analisado. Nenhuma tarefa nova gerada por falta de IA."
        return state

    llm = ChatOpenAI(model="gpt-4o", temperature=0.3)
    
    system_prompt = """
    Você é o #CEO-01 do Ecossistema Genius. Sua função é analisar o Hub de Resultados e decidir os próximos passos.
    Você deve emitir um 'Decreto Estratégico' e gerar novas tarefas para os agentes.
    
    Regras:
    1. Seja incisivo e focado em eficiência.
    2. Gere no máximo 3 tarefas prioritárias.
    3. Retorne a resposta em JSON para que o sistema possa processar.
    
    Formato de Resposta:
    {
      "decreto": "Resumo da visão estratégica atual",
      "new_tasks": [
        {
          "title": "Título da tarefa",
          "description": "Descrição detalhada",
          "priority": "Alta/Normal/Baixa",
          "agent": "#Atlas ou #Sage ou #Flow"
        }
      ]
    }
    """
    
    human_prompt = f"Estado atual do Hub de Resultados:\n{hub_content}"
    
    try:
        # Usar motor de resiliência com auto-cura
        response = GeniusResilience.invoke_with_failover([
            SystemMessage(content=system_prompt),
            HumanMessage(content=human_prompt)
        ])
        
        # Registrar evento de failover se ocorrer
        if "[FAILOVER_ACTIVE]" in response.content:
            if "failover_events" not in state: state["failover_events"] = []
            state["failover_events"].append({"agent": "CEO", "time": datetime.datetime.now().isoformat()})

        content = response.content.strip().replace("[FAILOVER_ACTIVE] ", "")
        if content.startswith("```json"):
            content = content[7:-3].strip()
        elif content.startswith("```"):
            content = content[3:-3].strip()
            
        result = json.loads(content)
        
        decreto = result.get("decreto", "Manter operação.")
        new_tasks = result.get("new_tasks", [])
        
        print(f"   -> Decreto: {decreto}")
        print(f"   -> {len(new_tasks)} novas tarefas geradas.")
        
        # Guardar resultados no estado para o debate
        state["final_report"] = f"DECRETO CEO (PROPOSTA): {decreto}"
        state["board_debate"] = {"ceo_proposal": decreto}
        state["context_data"]["ceo_tasks"] = new_tasks
        
        # Automação: Inserir tarefas no Supabase se o cliente estiver disponível
        from main import supabase
        if supabase and new_tasks:
            # Pegar IDs dos agentes
            agents_data = supabase.table("clickup_agents").select("id, display_id").execute().data
            agent_map = {a['display_id']: a['id'] for a in agents_data}
            
            # Pegar uma lista padrão (ex: a primeira encontrada)
            lists = supabase.table("clickup_lists").select("id").limit(1).execute().data
            if lists:
                list_id = lists[0]['id']
                for task in new_tasks:
                    agent_id = agent_map.get(task['agent'])
                    supabase.table("clickup_tasks").insert({
                        "list_id": list_id,
                        "agent_id": agent_id,
                        "title": task['title'],
                        "description": f"[DECRETO CEO] {task['description']}",
                        "priority": task['priority'],
                        "status": "A Fazer"
                    }).execute()
                    print(f"      + Tarefa criada: {task['title']}")
        
    except Exception as e:
        print(f"   -> Erro no CEO: {e}")
        state["final_report"] = f"Falha na execução do CEO: {str(e)}"
        
    return state
