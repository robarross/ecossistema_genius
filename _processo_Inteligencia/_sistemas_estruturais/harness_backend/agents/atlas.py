import os
import glob
from typing import Dict, Any
from utils.genius_dns import GeniusDNS

def search_obsidian(query: str, vault_path: str = "e:/Diretorios/Diretorio_Agentes", max_results: int = 3) -> str:
    """
    Busca simples nos arquivos Markdown do Obsidian para encontrar contexto relevante.
    """
    if not os.path.exists(vault_path):
        return "Erro: Vault não encontrado."
        
    keywords = [k.lower() for k in query.split() if len(k) > 3]
    if not keywords:
        return "Consulta muito curta para busca."
        
    results = []
    # Busca recursiva por arquivos .md
    for filepath in glob.glob(os.path.join(vault_path, "**/*.md"), recursive=True):
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
                content_lower = content.lower()
                
                # Conta quantos keywords aparecem no texto
                match_score = sum(1 for k in keywords if k in content_lower)
                
                if match_score > 0:
                    filename = os.path.basename(filepath)
                    snippet = content[:300].replace('\n', ' ').strip()
                    results.append((match_score, filename, snippet))
        except Exception:
            pass
            
    results.sort(key=lambda x: x[0], reverse=True)
    top_results = results[:max_results]
    
    if not top_results:
        return "Nenhum contexto relevante encontrado no Obsidian."
        
    formatted_context = ""
    for score, fname, snippet in top_results:
        formatted_context += f"- **{fname}** (Matches: {score}): {snippet}...\n"
        
    return formatted_context

def atlas_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Atlas (Coordenador de Conhecimento).
    Busca contexto no Obsidian e capacidades no Genius DNS.
    """
    task_input = state.get("task_input", "")
    print(f"ATLAS [ATLAS] Coordenando contexto para: {task_input[:50]}...")
    
    # 1. Busca de Conhecimento (Obsidian)
    context_found = search_obsidian(task_input)
    
    # 2. Busca de Capacidades (Genius DNS)
    dns = GeniusDNS()
    capabilities = dns.lookup(task_input[:30]) # Busca simplificada
    
    dns_context = "Nenhum módulo especializado encontrado no DNS."
    if capabilities:
        dns_context = "\n".join([f"- {m['module_id']} [{m['sector']}]: {m['physical_path']}" for m in capabilities])
    
    print(f"   -> Contexto Obsidian: OK")
    print(f"   -> Módulos DNS encontrados: {len(capabilities)}")
    
    # Atualiza o estado
    state["context_data"] = {
        "retrieved_docs": context_found,
        "discovered_capabilities": dns_context
    }
    return state
