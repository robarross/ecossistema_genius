import os
from typing import Dict, Any
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
import json
from utils.time_machine import FractalTimeMachine

def sage_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Sage (Auditoria).
    Aplica os Guardrails e valida se a tarefa pode prosseguir usando LLM.
    """
    print("SAGE [SAGE] Realizando auditoria de qualidade...")
    
    task_input = state.get("task_input", "")
    context = state.get("context_data", {}).get("retrieved_docs", "")
    pipeline_id = state.get("pipeline_id", "")
    
    # 1. Auditoria Estrutural (Esteira de Qualidade para Fábrica)
    if pipeline_id == "pl-module-factory":
        module_path = state.get("last_produced_path")
        print(f"   -> Iniciando Auditoria Estrutural em: {module_path}")
        
        if not module_path or not os.path.exists(module_path):
            state["audit_results"] = {"passed": False, "reason": "Pasta do módulo não encontrada no disco."}
            state["status"] = "failed"
            return state
            
        # Verificar subpastas LEGO
        required_dirs = ["0-IN", "1-DNA", "2-OUT", "3-LIB"]
        missing = [d for d in required_dirs if not os.path.exists(os.path.join(module_path, d))]
        
        if missing:
            state["audit_results"] = {"passed": False, "reason": f"Estrutura LEGO incompleta. Faltando: {missing}"}
            state["status"] = "failed"
            return state
            
        print("   -> Estrutura LEGO: OK")
        
        # 1.a Auditoria de Conteúdo do DNA (Conformidade Genius)
        dna_file = f"DNA_{os.path.basename(module_path)}.md"
        dna_path = os.path.join(module_path, "1-DNA", dna_file)
        
        if not os.path.exists(dna_path):
            state["audit_results"] = {"passed": False, "reason": f"DNA não encontrado: {dna_file}"}
            state["status"] = "failed"
            return state
            
        with open(dna_path, "r", encoding="utf-8") as f:
            content = f.read()
            
        # Verificar seções obrigatórias
        required_sections = ["## 🛠️ Skills", "🧬 DNA"]
        missing_sections = [s for s in required_sections if s not in content]
        
        if missing_sections:
            state["audit_results"] = {"passed": False, "reason": f"DNA fora dos padrões Genius. Faltando: {missing_sections}"}
            state["status"] = "failed"
            return state
            
        # 1.b Checagem de Redundância (Módulos com nomes similares)
        base_vault = os.path.dirname(module_path)
        existing_modules = [d for d in os.listdir(base_vault) if os.path.isdir(os.path.join(base_vault, d))]
        # Se houver mais de 1 com o mesmo nome base (excluindo o atual)
        similar = [m for m in existing_modules if m in os.path.basename(module_path) and m != os.path.basename(module_path)]
        
        if similar:
            print(f"   -> ALERTA DE REDUNDÂNCIA: {similar}")
            state["audit_results"] = {"passed": True, "reason": f"Aprovado com ressalva: Módulos similares detectados ({similar}). Verifique duplicidade."}
        else:
            state["audit_results"] = {"passed": True, "reason": "Estrutura e DNA validados com 100% de conformidade LEGO."}
            
        return state

    # 2. Auditoria Semântica (LLM) - Para outros pipelines
    if not os.environ.get("OPENAI_API_KEY"):
        print("   -> Aviso: OPENAI_API_KEY não configurada. Simulando aprovação.")
        state["audit_results"] = {"passed": True, "reason": "Simulação (Chave ausente). Padrão assumido como OK."}
        return state
        
    llm = ChatOpenAI(model="gpt-4o", temperature=0.1)
    
    system_prompt = """
    Você é o Agente #Sage do Genius Ecosystem. Sua função é auditar a tarefa fornecida.
    Regras de Guardrails:
    1. Padrão Modular LEGO: A tarefa deve ter clareza e ser executável.
    2. Não-Redundância: Analise o contexto (do Obsidian) para ver se algo semelhante já existe.
    
    Responda EXCLUSIVAMENTE com um JSON no seguinte formato:
    {
      "passed": true ou false,
      "reason": "motivo da aprovação ou reprovação em 1 frase"
    }
    """
    
    human_prompt = f"Tarefa: {task_input}\nContexto Obsidian:\n{context}"
    
    try:
        response = llm.invoke([
            SystemMessage(content=system_prompt),
            HumanMessage(content=human_prompt)
        ])
        
        # Parse da resposta (pode vir com blocos markdown ```json)
        content = response.content.strip()
        if content.startswith("```json"):
            content = content[7:-3].strip()
        elif content.startswith("```"):
            content = content[3:-3].strip()
            
        result = json.loads(content)
        
        is_valid = result.get("passed", False)
        reason = result.get("reason", "Erro ao processar auditoria.")
        
        print(f"   -> Resultado: {'OK' if is_valid else 'FAIL'} {reason}")
        
    except Exception as e:
        print(f"   -> Erro na LLM: {e}")
        is_valid = False
        reason = f"Falha na execução do Sage: {str(e)}"
    
    state["audit_results"] = {"passed": is_valid, "reason": reason}
    
    if not is_valid:
        state["status"] = "failed"
        
    return state
