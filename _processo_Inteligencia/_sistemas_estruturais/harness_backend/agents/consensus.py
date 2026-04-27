import os
from typing import Dict, Any
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage
from utils.resilience import GeniusResilience
import json

def consensus_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó de Consenso (Board Deliberation).
    Sintetiza o debate entre CEO, CFO e COO em um decreto final.
    """
    print("CONSENSUS [BOARD] Iniciando deliberação do Conselho Executivo...")
    
    debate = state.get("board_debate", {})
    ceo_proposal = debate.get("ceo_proposal", "Sem proposta.")
    cfo_feedback = debate.get("cfo_feedback", "Sem feedback financeiro.")
    coo_feedback = debate.get("coo_feedback", "Sem feedback operacional.")
    
    if not os.environ.get("OPENAI_API_KEY"):
        print("   -> Aviso: OPENAI_API_KEY ausente. Simulando consenso.")
        state["final_report"] += "\n\n⚠️ CONSELHO: Deliberação simulada por falta de IA. Proposta CEO mantida."
        return state

    llm = ChatOpenAI(model="gpt-4o", temperature=0.2)
    
    system_prompt = """
    Você é o Presidente do Conselho (Chairman) do Genius Ecosystem.
    Sua função é mediar o debate entre o CEO (Estratégia), CFO (Financeiro) e COO (Operacional).
    
    Você deve analisar a proposta do CEO e considerar as críticas/alertas do CFO e COO.
    Seu objetivo é gerar um 'Decreto Consolidado' que equilibre ambição estratégica com responsabilidade financeira e viabilidade operacional.
    
    Formato de Saída (Markdown):
    ### ⚖️ Ata de Deliberação do Conselho
    **Decisão Final:** [Sua síntese aqui]
    **Ajustes Realizados:** [Como você adaptou a ideia do CEO com base no CFO/COO]
    """
    
    human_prompt = f"""
    PROPOSTA CEO: {ceo_proposal}
    
    FEEDBACK CFO (Finanças/ROI): {cfo_feedback}
    
    FEEDBACK COO (Operações/Carga): {coo_feedback}
    """
    
    try:
        # Usar motor de resiliência com auto-cura
        response = GeniusResilience.invoke_with_failover([
            SystemMessage(content=system_prompt),
            HumanMessage(content=human_prompt)
        ])
        
        # Registrar evento de failover se ocorrer
        if "[FAILOVER_ACTIVE]" in response.content:
            if "failover_events" not in state: state["failover_events"] = []
            state["failover_events"].append({"agent": "Consensus", "time": "now"})

        final_decree = response.content.strip().replace("[FAILOVER_ACTIVE] ", "")
        print("   -> Deliberação finalizada com sucesso.")
        
        # Substituir o relatório final ou anexar
        state["final_report"] += "\n\n" + final_decree
        
    except Exception as e:
        print(f"   -> Erro no Consenso: {e}")
        state["final_report"] += f"\n\n❌ Erro na deliberação do conselho: {e}"

    return state
