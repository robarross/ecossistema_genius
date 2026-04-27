from typing import Dict, Any

def echo_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Echo (Feedback).
    Gera relatórios em Markdown e formata a saída final.
    """
    print("📣 [ECHO] Compilando relatório final...")
    
    audit = state.get("audit_results", {})
    context_str = state.get("context_data", {}).get("retrieved_docs", "Nenhum contexto encontrado.")
    task_input = state.get("task_input", "Sem título")
    
    status_icon = "✅ Aprovado" if audit.get("passed") else "❌ Reprovado"
    reason = audit.get("reason", "Sem motivo especificado.")
    
    report = f"""
### 📊 Relatório de Auditoria: Safra Digital 1.0

**Tarefa:** {task_input}

#### 🛡️ Parecer do Agente #Sage
- **Status:** {status_icon}
- **Motivo:** {reason}

#### 🤖 Contexto Encontrado (Agente #Atlas)
```text
{context_str}
```

> Relatório gerado automaticamente pelo Ecossistema Genius.
"""
    
    state["final_report"] = report.strip()
    
    # Se já não estiver failed pelo Sage, define como completed
    if state.get("status") != "failed":
        state["status"] = "completed"
        
    return state
