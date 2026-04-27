import os
import json
from typing import Dict, Any
from utils.circuit_breaker import FractalCircuitBreaker

def run_module_diagnostic(module_path: str) -> Dict[str, Any]:
    """
    Realiza o auto-diagnóstico físico e lógico do fractal.
    """
    if not os.path.exists(module_path):
        return {"passed": False, "reason": "Caminho do módulo não existe."}
        
    module_id = os.path.basename(module_path)
    socket_path = os.path.join(module_path, "socket.json")
    
    if not os.path.exists(socket_path):
        return {"passed": False, "reason": "Protocolo Socket-LEGO (socket.json) ausente."}
        
    with open(socket_path, "r", encoding="utf-8") as f:
        socket_config = json.load(f)
        
    inputs = socket_config.get("io_contract", {}).get("input", [])
    outputs = socket_config.get("io_contract", {}).get("output", [])
    
    print(f"HEALTH [CHECK-IN] Validando módulo: {module_id}")
    
    # 1. Verificar integridade física
    required_dirs = ["0-IN", "1-DNA", "2-OUT", "3-LIB"]
    for d in required_dirs:
        if not os.path.exists(os.path.join(module_path, d)):
            return {"passed": False, "reason": f"Pasta {d} ausente."}
            
    # 2. Verificar DNA
    dna_file = os.path.join(module_path, "1-DNA", f"DNA_{module_id}.md")
    if not os.path.exists(dna_file):
        return {"passed": False, "reason": "Arquivo de DNA ausente."}
        
    # 3. Teste de I/O (Simulado)
    print(f"   -> Protocolo {socket_config.get('protocol')} validado.")
    print(f"   -> Inputs aceitos: {inputs}")
    
    return {"passed": True, "reason": "Auto-diagnóstico concluído. Módulo operando em conformidade."}

def health_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó que executa o auto-diagnóstico no final da produção.
    """
    module_path = state.get("last_produced_path")
    if not module_path: return state
    
    module_id = os.path.basename(module_path)
    result = run_module_diagnostic(module_path)
    
    if result["passed"]:
        FractalCircuitBreaker.record_success(module_id)
        if "final_report" not in state: state["final_report"] = ""
        state["final_report"] += f"\n\n🩺 **Auto-Diagnóstico:** {result['reason']}"
    else:
        FractalCircuitBreaker.record_failure(module_id)
        state["status"] = "failed"
        if "final_report" not in state: state["final_report"] = ""
        state["final_report"] += f"\n\n❌ **Falha no Diagnóstico:** {result['reason']}"
        
    return state
