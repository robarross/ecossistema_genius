import os
import re
from typing import Dict, Any

def atlas_linker_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Atlas (Auto-Linker Semântico).
    Cria conexões [[ ]] automáticas entre módulos relacionados no Obsidian.
    """
    module_path = state.get("last_produced_path")
    if not module_path or not os.path.exists(module_path):
        print("ATLAS [ATLAS] Erro: Caminho do módulo não encontrado para linkagem.")
        return state

    print(f"ATLAS [ATLAS] Construindo Teia de Conhecimento para: {os.path.basename(module_path)}")
    
    base_vault = os.path.dirname(module_path)
    
    # 1. Identificar alvos potenciais (outros módulos no vault)
    targets = [d for d in os.listdir(base_vault) if os.path.isdir(os.path.join(base_vault, d)) and not d.startswith("_")]
    
    # 2. Ler o DNA do novo módulo
    dna_file = [f for f in os.listdir(os.path.join(module_path, "1-DNA")) if f.endswith(".md")][0]
    dna_path = os.path.join(module_path, "1-DNA", dna_file)
    
    with open(dna_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    # 3. Buscar menções aos alvos e criar conexões
    connections = []
    for target in targets:
        # Evitar linkar consigo mesmo
        if target == os.path.basename(module_path):
            continue
            
        # Busca insensível a maiúsculas (ex: busca "LOGISTICA" em "Modulo de Logistica")
        # Usamos uma busca simples de substring para maior alcance semântico inicial
        clean_target = target.replace("_", " ").upper()
        if clean_target in content.upper() or target.upper() in content.upper():
            connections.append(f"- [[{target}]]")
            
    # 4. Injetar Seção de Conexões se houver algo
    if connections:
        print(f"   -> {len(connections)} conexões semânticas encontradas.")
        connections_str = "\n## 🌐 Conexões Semânticas (Auto-Linked)\n" + "\n".join(connections) + "\n"
        
        with open(dna_path, "a", encoding="utf-8") as f:
            f.write(connections_str)
            
        state["final_report"] += f"\n\n🌐 **Teia de Conhecimento:** #Atlas criou {len(connections)} links automáticos para outros módulos."
    else:
        print("   -> Nenhuma conexão semântica óbvia detectada.")

    return state
