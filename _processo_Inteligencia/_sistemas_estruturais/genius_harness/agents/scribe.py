import os
from typing import Dict, Any
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage

def scribe_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Scribe-01 (Documentação Viva).
    Lê os resultados e atualiza o manual do módulo.
    """
    module_path = state.get("last_produced_path")
    if not module_path or state.get("status") != "completed":
        return state
        
    print(f"SCRIBE [SCRIBE] Atualizando documentação viva para: {os.path.basename(module_path)}")
    
    final_report = state.get("final_report", "")
    task_input = state.get("task_input", "")
    
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0.3)
    
    system_prompt = """
    Você é o #Scribe-01, o bibliotecário autônomo do Ecossistema Genius.
    Sua missão é atualizar o 'Manual do Usuário' de um módulo baseado em uma execução real.
    
    Extraia:
    1. Propósito do módulo.
    2. Exemplo de Input que funcionou.
    3. Descrição do que o módulo produz.
    
    Formate em Markdown elegante para ser salvo na pasta 3-LIB.
    """
    
    human_prompt = f"RELATÓRIO DE EXECUÇÃO:\n{final_report}\n\nINPUT UTILIZADO:\n{task_input}"
    
    try:
        response = llm.invoke([
            SystemMessage(content=system_prompt),
            HumanMessage(content=human_prompt)
        ])
        
        manual_content = response.content.strip()
        manual_path = os.path.join(module_path, "3-LIB", "01_manual_do_usuario.md")
        
        with open(manual_path, "w", encoding="utf-8") as f:
            f.write(manual_content)
            
        print("   -> Manual atualizado com sucesso.")
        
    except Exception as e:
        print(f"   -> Erro no Scribe: {e}")

    return state
