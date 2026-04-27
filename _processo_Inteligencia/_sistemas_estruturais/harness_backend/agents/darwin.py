import os
from typing import Dict, Any
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
from utils.time_machine import FractalTimeMachine

def darwin_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Darwin-01 (Evolução Darwiniana).
    Analisa falhas do Sage e aplica mutações corretivas no DNA.
    """
    audit_results = state.get("audit_results", {})
    module_path = state.get("last_produced_path")
    
    # Só evolui se houver falhas críticas ou se o Sage sugeriu melhorias
    if not module_path or audit_results.get("structural_score", 100) >= 90:
        return state
        
    print(f"DARWIN [EVOLUÇÃO] Detectada necessidade de mutação para: {os.path.basename(module_path)}")
    
    # 1. Snapshot de Segurança antes da mutação
    FractalTimeMachine.create_snapshot(module_path, reason="darwin_mutation_attempt")
    
    # 2. Ler DNA Atual
    dna_dir = os.path.join(module_path, "1-DNA")
    dna_files = [f for f in os.listdir(dna_dir) if f.endswith(".md")]
    if not dna_files: return state
    
    dna_path = os.path.join(dna_dir, dna_files[0])
    with open(dna_path, "r", encoding="utf-8") as f:
        current_dna = f.read()
        
    # 3. Gerar Mutação via LLM
    llm = ChatOpenAI(model="gpt-4o", temperature=0.5)
    
    system_prompt = """
    Você é o Agente #Darwin-01, o Geneticista Digital do Ecossistema Genius.
    Sua missão é realizar uma 'MUTÁÇÃO' no DNA de um módulo para corrigir falhas apontadas pelo Auditor Sage.
    
    REGRAS:
    1. Mantenha a essência do módulo.
    2. Corrija especificamente os erros de estrutura ou lógica citados.
    3. Retorne APENAS o novo conteúdo do arquivo DNA.md.
    """
    
    human_prompt = f"""
    DNA ATUAL:
    {current_dna}
    
    CRÍTICAS DO AUDITOR SAGE:
    {audit_results.get('audit_report', 'Falha estrutural não especificada.')}
    
    Gere o DNA MUTADO:
    """
    
    try:
        response = llm.invoke([
            SystemMessage(content=system_prompt),
            HumanMessage(content=human_prompt)
        ])
        
        mutated_dna = response.content.strip()
        
        # 4. Aplicar Mutação (Sobrescrever DNA)
        with open(dna_path, "w", encoding="utf-8") as f:
            f.write(mutated_dna)
            
        print(f"   -> DNA Mutado com sucesso. Evolução concluída para v2.")
        state["final_report"] += "\n\n🧬 **Evolução Darwiniana:** O DNA do módulo foi auto-corrigido para sanar falhas detectadas pelo Sage."
        
    except Exception as e:
        print(f"   -> Falha na evolução: {e}")

    return state
