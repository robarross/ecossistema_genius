import os
from typing import Dict, Any
import datetime

def archon_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Archon (Bibliotecário/Guardião da Memória).
    Persiste o relatório final e aprendizados no Segundo Cérebro (Obsidian).
    """
    print("ARCHON [ARCHON] Persistindo aprendizados operacionais...")
    
    final_report = state.get("final_report", "")
    execution_id = state.get("execution_id", "unknown")
    
    # Caminho do fractal de aprendizado
    vault_path = "e:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_aprendizado_continuo"
    file_path = os.path.join(vault_path, "aprendizados_operacionais.md")
    
    # Criar o fractal no padrão LEGO
    now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    fractal_content = f"""
---
# 🧩 Fractal de Aprendizado: {execution_id}
**Data:** {now}
**Pipeline:** {state.get('pipeline_id')}

## 0-IN (Entrada)
- **ID Execução:** {execution_id}
- **Input Original:** {state.get('task_input')}

## 1-DNA (Processamento)
### Resumo da Execução
{final_report}

## 2-OUT (Saída/Conhecimento)
- **Status Final:** {state.get('status', 'completed')}
- **Gargalos Detectados:** {state.get('audit_results', {}).get('coo_audit', {}).get('bottlenecks', 'Nenhum')}

---
"""
    
    try:
        # Garantir que o diretório existe
        os.makedirs(vault_path, exist_ok=True)
        
        # Append ao arquivo de aprendizados (ou criar novo se preferir)
        # Aqui vamos usar Append para manter um log histórico
        with open(file_path, "a", encoding="utf-8") as f:
            f.write(fractal_content)
            
        print(f"   -> Memória Fractal persistida em: {file_path}")
        state["final_report"] += f"\n\n✅ **Memória Fractal Persistida:** Os aprendizados desta sessão foram arquivados no Segundo Cérebro por #Archon."
        
    except Exception as e:
        print(f"   -> ERROR [ARCHON] Falha ao persistir memória: {e}")
        state["final_report"] += f"\n\n❌ **Erro de Memória:** #Archon falhou ao persistir o fractal no Segundo Cérebro."

    return state
