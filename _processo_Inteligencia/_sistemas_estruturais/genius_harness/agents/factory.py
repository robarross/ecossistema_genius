import os
import re
import time
from typing import Dict, Any

def factory_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Factory-01 (Fábrica).
    Cria a estrutura física de um novo módulo com Blueprints Setoriais.
    Suporta produção individual ou em lote (via planilha).
    """
    # 0. Verificar se é uma produção em lote (Planilha)
    queue = state.get("context_data", {}).get("production_queue", [])
    if queue:
        # Ordenar por nível para garantir hierarquia
        level_map = {"SISTEMA": 1, "MODULO": 2, "FRACTAL": 3}
        queue.sort(key=lambda x: level_map.get(x.get("nivel", "FRACTAL"), 3))
        
        print(f"FACTORY [BATCH] Iniciando esteira industrial para {len(queue)} itens.")
        batch_report = ["### 🚜 Relatório de Safra Digital\n| Item | Nível | Status | Detalhes |", "| :--- | :--- | :--- | :--- |"]
        success_count = 0
        
        for item in queue:
            name = item.get("nome", "Sem_Nome")
            nivel = item.get("nivel", "FRACTAL")
            try:
                # Tenta produzir o módulo individualmente
                res_path = _produce_single_module(item, state)
                batch_report.append(f"| {name} | {nivel} | ✅ SUCESSO | Criado em {os.path.basename(res_path)} |")
                success_count += 1
            except Exception as e:
                batch_report.append(f"| {name} | {nivel} | ❌ FALHA | Erro: {str(e)} |")
                print(f"   [BATCH] ⚠️ Falha no item {name}: {e}")
        
        state["final_report"] = "\n".join(batch_report)
        state["final_report"] += f"\n\n**Resumo:** {success_count}/{len(queue)} módulos ativados com sucesso."
        state["context_data"]["production_queue"] = []
        state["status"] = "completed"
        return state

    # Produção Individual
    ticket = {
        "nome": state.get("task_input", "Novo_Modulo"),
        "nivel": "MODULO",
        "pai": ""
    }
    _produce_single_module(ticket, state)
    return state

def _produce_single_module(ticket: Dict[str, Any], state: Dict[str, Any]) -> str:
    """
    Lógica interna de produção hierárquica.
    """
    module_name_raw = ticket.get("nome", "Sem_Nome")
    nivel = ticket.get("nivel", "MODULO")
    pai = ticket.get("pai", "")
    if isinstance(module_name_raw, bytes):
        module_name_raw = module_name_raw.decode('utf-8', errors='ignore')
    
    # 1. Detecção de Setor (Blueprints)
    sector = "PADRÃO"
    if "AGRO" in module_name_raw.upper():
        sector = "AGRO"
    elif "SISTEMA" in module_name_raw.upper() or "COD" in module_name_raw.upper():
        sector = "SISTEMA"
    elif "FINANC" in module_name_raw.upper() or "CUSTO" in module_name_raw.upper():
        sector = "FINANCEIRO"

    # 2. Normalizar nome e definir Caminho Hierárquico
    prefix = f"[{nivel}]_"
    clean_name = re.sub(r'[^\w\-]', '_', module_name_raw).upper()
    module_folder = f"{prefix}{clean_name}"
    
    base_path = "e:/Diretorios/Diretorio_Agentes/_processo_Inteligencia"
    
    # Se tiver pai, buscar o caminho do pai
    if pai:
        # Busca simples: assume que a pasta do pai existe na raiz ou um nível abaixo
        # Em um sistema real, usaríamos o Genius DNS para encontrar o physical_path do pai
        parent_folder = f"[SISTEMA]_{pai.upper()}" if nivel == "MODULO" else f"[MODULO]_{pai.upper()}"
        # Tenta localizar o pai
        potential_parent = os.path.join(base_path, parent_folder)
        if os.path.exists(potential_parent):
            module_path = os.path.join(potential_parent, module_folder)
        else:
            module_path = os.path.join(base_path, module_folder) # Fallback para raiz
    else:
        module_path = os.path.join(base_path, module_folder)
    
    # TELEMETRIA: Início
    from utils.event_bus import GeniusEventBus
    bus = GeniusEventBus()
    bus.publish("FACTORY", "PRODUCTION_STARTED", {"module": clean_name, "level": nivel})
    
    # 3. Templates de DNA por Setor (Enriquecido com Skills da Planilha/Matcher)
    ticket_skills = ticket.get("skills", [])
    skills_str = "\n".join([f"- {s}" for s in ticket_skills]) if ticket_skills else "- Skill 1\n- Skill 2"
    
    templates = {
        "AGRO": f"# 🧬 DNA AGRO: {module_name_raw}\n\n## 🌾 Métricas de Produtividade\n- Eficiência por Hectare\n- Ciclo de Safra\n- Gestão de Insumos\n\n## 🛠️ Skills\n{skills_str}\n",
        "SISTEMA": f"# 🧬 DNA SISTEMA: {module_name_raw}\n\n## 💻 Padrões de Código\n- Arquitetura LEGO Clean\n- Documentação Automática\n- Testes Unitários\n\n## 🛠️ Skills\n{skills_str}\n",
        "FINANCEIRO": f"# 🧬 DNA FINANCEIRO: {module_name_raw}\n\n## 💰 KPIs de ROI\n- Fluxo de Caixa\n- Auditoria de Tokens\n- Margem Operacional\n\n## 🛠️ Skills\n{skills_str}\n",
        "PADRÃO": f"# 🧬 DNA: {module_name_raw}\n\n## 🎭 Papel\nDefinição do propósito deste módulo...\n\n## 🛠️ Skills\n{skills_str}\n"
    }
    
    blueprint = templates.get(sector, templates["PADRÃO"])
    
    # 4. Criar estrutura LEGO
    subfolders = ["0-IN", "1-DNA", "2-OUT", "3-LIB"]
    
    try:
        os.makedirs(module_path, exist_ok=True)
        for sub in subfolders:
            os.makedirs(os.path.join(module_path, sub), exist_ok=True)
            
        # 5. Gerar DNA com Blueprint
        dna_path = os.path.join(module_path, "1-DNA", f"DNA_{module_folder}.md")
        with open(dna_path, "w", encoding="utf-8") as f:
            f.write(blueprint)
        bus.publish("FACTORY", "DNA_GENERATED", {"module": clean_name})

        # 6. Gerar Protocolo Socket-LEGO (socket.json)
        ticket_inputs = ticket.get("inputs", ["task_input", "context_data"])
        ticket_outputs = ticket.get("outputs", ["final_report", "status"])
        
        socket_contract = {
            "module_id": module_folder,
            "protocol": "LEGO-V1",
            "sector": sector,
            "io_contract": {
                "input": ticket_inputs,
                "output": ticket_outputs
            }
        }
            
        with open(os.path.join(module_path, "socket.json"), "w", encoding="utf-8") as f:
            json.dump(socket_contract, f, indent=4)

        # 7. Seed de Conhecimento (Micro-RAG Local)
        lib_seed = {
            "AGRO": "### 🌾 Glossário Agro\n- Safrinha: Segunda safra do ano.\n- ROI por Hectare: Métrica chave de rentabilidade.",
            "SISTEMA": "### 💻 Padrões LEGO\n- IN: Pasta de entrada de dados.\n- DNA: Lógica central do fractal.",
            "FINANCEIRO": "### 💰 Regras Fiscais\n- Tributação Rural: Alíquotas base 2024.\n- Fluxo de Caixa: Padrão Genius."
        }
        
        seed_content = lib_seed.get(sector, "### 📚 Conhecimento Geral\nPadrões operacionais Genius.")
        seed_path = os.path.join(module_path, "3-LIB", "00_base_knowledge.md")
        with open(seed_path, "w", encoding="utf-8") as f:
            f.write(seed_content)
            
        # 8. Gerar Orçamento Local (Micro-CFO)
        budget_config = {
            "module_id": module_folder,
            "monthly_limit": 5.00,
            "current_spend": 0.0,
            "currency": "USD",
            "last_reset": time.strftime("%Y-%m-01"),
            "last_update": time.strftime("%Y-%m-%d %H:%M:%S")
        }
        with open(os.path.join(module_path, "budget.json"), "w", encoding="utf-8") as f:
            json.dump(budget_config, f, indent=4)
            
        from utils.time_machine import FractalTimeMachine
        version = FractalTimeMachine.create_snapshot(module_path, reason="initial_production")
        bus.publish("FACTORY", "PRODUCTION_COMPLETED", {"module": clean_name, "version": version})
            
        state["status"] = "completed"
        state["last_produced_path"] = module_path
        state["final_report"] = f"✅ **Fábrica Genius:** Módulo {module_folder} (Blueprint {sector}) gerado e imortalizado (Versão {version})."
        
    except Exception as e:
        state["status"] = "failed"
        state["final_report"] = f"❌ **Falha na Fábrica:** Erro ao processar blueprint {sector} para {module_folder}: {e}"

    return state
