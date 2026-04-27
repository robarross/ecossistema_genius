import os
from typing import Dict, Any
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
import json

def researcher_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó do Agente #Researcher-01 (Inteligência de Mercado).
    Busca tendências externas e propõe evoluções para o ecossistema.
    """
    print("RESEARCHER [RESEARCHER] Escaneando tendências de mercado...")
    
    # Simulação de busca web (Em uma implementação real, usaríamos a tool search_web)
    # Aqui, o LLM atuará com sua base de conhecimento atualizada para propor tendências 2024/2025
    
    if not os.environ.get("OPENAI_API_KEY"):
        print("   -> Aviso: OPENAI_API_KEY ausente. Simulando pesquisa.")
        state["final_report"] = "RESEARCHER: Pesquisa simulada. Tendência detectada: IA Multimodal no Agro."
        return state

    llm = ChatOpenAI(model="gpt-4o", temperature=0.7)
    
    system_prompt = """
    Você é o #Researcher-01 do Ecossistema Genius. 
    Sua missão é atuar como um Radar de Inovação.
    
    Analise o contexto do ecossistema (Foco em Agro, Sistemas e IA) e identifique 3 tendências tecnológicas disruptivas que deveriam ser incorporadas como novos módulos ou upgrades de DNA.
    
    Responda em JSON:
    {
      "tendencias": [
        {
          "tema": "Nome da tecnologia/tendência",
          "impacto": "Como isso melhora o ecossistema",
          "proposta_dna": "Novas Skills a serem adicionadas aos agentes"
        }
      ]
    }
    """
    
    human_prompt = "Quais são as fronteiras tecnológicas atuais para Agentes de IA aplicados ao Agronegócio e Engenharia de Software Modular?"
    
    try:
        response = llm.invoke([
            SystemMessage(content=system_prompt),
            HumanMessage(content=human_prompt)
        ])
        
        content = response.content.strip()
        if content.startswith("```json"):
            content = content[7:-3].strip()
        elif content.startswith("```"):
            content = content[3:-3].strip()
            
        result = json.loads(content)
        tendencias = result.get("tendencias", [])
        
        report = "### 🔭 Relatório de Inteligência de Mercado (#Researcher-01)\n"
        for t in tendencias:
            report += f"\n#### 🚀 {t['tema']}\n- **Impacto:** {t['impacto']}\n- **Upgrade de DNA:** {t['proposta_dna']}\n"
            
        state["final_report"] = report
        print(f"   -> Pesquisa finalizada. {len(tendencias)} tendências identificadas.")
        
    except Exception as e:
        print(f"   -> Erro no Researcher: {e}")
        state["final_report"] = f"Falha na pesquisa de mercado: {e}"

    return state
