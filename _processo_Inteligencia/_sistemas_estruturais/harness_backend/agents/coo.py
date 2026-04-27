import os
from typing import Dict, Any, List
from supabase import create_client, Client
from dotenv import load_dotenv
import datetime

load_dotenv()

def coo_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #COO-01 (Operações).
    Analisa a carga de trabalho atual e orquestra a execução da Safra Digital.
    """
    print("COO [COO] Iniciando orquestração operacional...")
    
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_SERVICE_KEY")
    supabase: Client = create_client(url, key)
    
    # 1. Buscar tarefas ativas
    res = supabase.table("v_clickup_tasks_enhanced").select("*").not_.in_("status", ["Concluído", "Fechado", "Done"]).execute()
    tasks = res.data
    
    # 2. Analisar carga por agente
    workload = {}
    for task in tasks:
        agent = task.get("agent_display_id") or task.get("agent_id") or "Não Atribuído"
        workload[agent] = workload.get(agent, 0) + 1
    
    print(f"   -> Carga atual: {workload}")
    
    # 3. Identificar gargalos e gerar recomendações
    recommendations = []
    bottlenecks = [agent for agent, count in workload.items() if count > 3 and agent != "Não Atribuído"]
    
    if bottlenecks:
        print(f"   -> Gargalo detectado nos agentes: {bottlenecks}")
        for agent in bottlenecks:
            recommendations.append(f"Agente {agent} está sobrecarregado ({workload[agent]} tarefas). Sugerido redistribuição.")
    else:
        recommendations.append("Carga de trabalho equilibrada entre os agentes.")
        
    # 4. Verificar tarefas prioritárias sem agente
    unassigned = workload.get("Não Atribuído", 0)
    if unassigned > 0:
        recommendations.append(f"Existem {unassigned} tarefas sem agente atribuído. CEO deve definir responsáveis.")

    # 5. Gerar relatório operacional
    report = f"""
### ⚙️ Relatório Operacional: Genius COO
**Data:** {datetime.datetime.now().strftime('%d/%m/%Y %H:%M')}

#### 📊 Carga de Trabalho Atual
{chr(10).join([f"- **{agent}**: {count} tarefas" for agent, count in workload.items()])}

#### 🛠️ Recomendações e Ajustes
{chr(10).join([f"- {rec}" for rec in recommendations])}

> Operação Safra Digital 1.0 em andamento.
"""
    
    # Atualizar o estado com as descobertas do COO
    state["audit_results"]["coo_audit"] = {
        "workload": workload,
        "bottlenecks": bottlenecks,
        "recommendations": recommendations
    }
    
    # Adicionar ao debate do conselho
    state["board_debate"]["coo_feedback"] = " | ".join(recommendations)
    
    # Adicionar ao relatório final
    state["final_report"] += "\n" + report.strip()
    
    return state
