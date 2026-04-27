import os
import re
from typing import Dict, Any
from supabase import create_client

def deployer_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Deployer (Ativação Digital).
    Registra agentes e listas no Supabase para tornar o módulo operacional.
    """
    module_path = state.get("last_produced_path")
    if not module_path or not os.path.exists(module_path):
        print("DEPLOYER [DEPLOYER] Erro: Caminho do módulo não encontrado para ativação.")
        return state

    print(f"DEPLOYER [DEPLOYER] Ativando módulo: {os.path.basename(module_path)}")
    
    # 1. Conectar ao Supabase
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_SERVICE_KEY")
    if not url or not key:
        print("   -> DEPLOYER ERROR: Credenciais Supabase ausentes.")
        return state
        
    supabase = create_client(url, key)
    
    # 2. Ler DNA para extrair metadados do Agente
    dna_file = [f for f in os.listdir(os.path.join(module_path, "1-DNA")) if f.endswith(".md")][0]
    dna_path = os.path.join(module_path, "1-DNA", dna_file)
    
    with open(dna_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Extrair Nome e Skills (Regex simples para o padrão do Blueprint)
    agent_name = os.path.basename(module_path).replace("MODULO_", "").replace("_", " ").title()
    skills_match = re.search(r"## 🛠️ Skills\n(.*?)(?:\n\n|$)", content, re.DOTALL)
    skills = []
    if skills_match:
        skills = [s.strip("- ").strip() for s in skills_match.group(1).split("\n") if s.strip()]

    try:
        # 3. Registrar Agente no Supabase
        print(f"   -> Registrando Agente: {agent_name}")
        agent_data = {
            "name": agent_name,
            "display_id": f"#{agent_name.replace(' ', '')}",
            "skills": skills,
            "status": "Online",
            "metadata": {"source": "Auto-Deploy", "module_path": module_path}
        }
        supabase.table("clickup_agents").upsert(agent_data, on_conflict="display_id").execute()
        
        # 4. Registrar Lista no Supabase (Simulando ativação no ClickUp)
        print(f"   -> Criando Lista Operacional: {agent_name}")
        list_data = {
            "name": agent_name,
            "status": "active",
            "metadata": {"module": os.path.basename(module_path)}
        }
        supabase.table("clickup_lists").upsert(list_data, on_conflict="name").execute()
        
        state["final_report"] += f"\n\n🚀 **Ativação Digital:** Agente `#{agent_name.replace(' ', '')}` e sua Lista Operacional foram registrados no Supabase e estão ONLINE."
        
    except Exception as e:
        print(f"   -> DEPLOYER ERROR: Falha ao registrar no Supabase: {e}")
        state["final_report"] += f"\n\n⚠️ **Falha na Ativação:** Erro ao registrar agente no Supabase: {e}"

    # 5. Registrar no Genius DNS (Descoberta Automática)
    try:
        import json
        from utils.genius_dns import GeniusDNS
        socket_path = os.path.join(module_path, "socket.json")
        
        if os.path.exists(socket_path):
            with open(socket_path, "r", encoding="utf-8") as f:
                socket_data = json.load(f)
                
            dns = GeniusDNS()
            dns.register(
                module_id=os.path.basename(module_path),
                sector=socket_data.get("sector", "DESCONHECIDO"),
                sockets=socket_data.get("io_contract", {}),
                path=module_path
            )
    except Exception as e:
        print(f"   [DEPLOYER] Erro no registro DNS: {e}")

    # 6. Publicar evento no Barramento Global
    try:
        from utils.event_bus import GeniusEventBus
        bus = GeniusEventBus()
        bus.publish(
            source="DEPLOYER", 
            event_type="MODULE_ACTIVATED", 
            payload={"module_id": os.path.basename(module_path), "path": module_path}
        )
    except Exception as e:
        print(f"   [DEPLOYER] Erro ao notificar barramento: {e}")

    return state
