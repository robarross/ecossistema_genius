import os
from typing import Dict, Any, List

def entropy_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Entropy-01 (Guardião da Ordem).
    Varre o vault em busca de órfãos e redundâncias.
    """
    vault_path = "e:/Diretorios/Diretorio_Agentes/_processo_Inteligencia"
    print(f"ENTROPY [ENTROPY] Iniciando varredura anti-entropia em: {vault_path}")
    
    if not os.path.exists(vault_path):
        print("   -> Erro: Vault não encontrado.")
        return state
        
    all_items = os.listdir(vault_path)
    modules = [d for d in all_items if os.path.isdir(os.path.join(vault_path, d)) and not d.startswith("_") and d != ".vscode"]
    
    orphans = []
    redundancies = []
    
    # 1. Busca por Órfãos e Redundâncias
    for i, module in enumerate(modules):
        module_full_path = os.path.join(vault_path, module)
        dna_dir = os.path.join(module_full_path, "1-DNA")
        
        # Verificar se tem DNA
        if not os.path.exists(dna_dir) or not os.listdir(dna_dir):
            orphans.append(f"{module} (Faltando DNA)")
            continue
            
        # 2. Checar se outros módulos citam este (Busca simples de link [[Module]])
        is_linked = False
        link_pattern = f"[[{module}]]"
        
        for other in modules:
            if other == module: continue
            other_dna_dir = os.path.join(vault_path, other, "1-DNA")
            if os.path.exists(other_dna_dir):
                for f in os.listdir(other_dna_dir):
                    with open(os.path.join(other_dna_dir, f), "r", encoding="utf-8", errors="ignore") as file:
                        if link_pattern in file.read():
                            is_linked = True
                            break
            if is_linked: break
            
        if not is_linked:
            orphans.append(module)
            
        # 3. Detector de Similaridade (Redundância)
        for other in modules[i+1:]:
            # Se o nome for 80% similar (simplificado: se um nome está contido no outro)
            if module in other or other in module:
                redundancies.append(f"{module} <-> {other}")

    # 4. Gerar Proposta de Refatoração
    report = "### 🕸️ Relatório Anti-Entropia Genius\n"
    if orphans:
        report += "\n#### 🏚️ Módulos Órfãos (Sem conexões):\n" + "\n".join([f"- {m}" for m in orphans])
    else:
        report += "\n#### ✅ Nenhum módulo órfão detectado."
        
    if redundancies:
        report += "\n\n#### 👯 Redundâncias Detectadas (Sugestão de Fusão):\n" + "\n".join([f"- {r}" for r in redundancies])
    else:
        report += "\n\n#### ✅ Nenhuma redundância óbvia detectada."

    state["final_report"] = report
    print("   -> Varredura finalizada. Relatório gerado.")
    
    return state
