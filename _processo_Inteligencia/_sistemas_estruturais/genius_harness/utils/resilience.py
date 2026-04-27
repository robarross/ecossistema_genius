import os
import time
from typing import List, Any, Dict
from langchain_openai import ChatOpenAI
from langchain_core.messages import BaseMessage

class GeniusResilience:
    """
    Motor de Resiliência do Ecossistema Genius.
    Gerencia Failover automático entre modelos de IA.
    """
    
    @staticmethod
    def invoke_with_failover(messages: List[BaseMessage], primary_model: str = "gpt-4o", secondary_model: str = "gpt-4o-mini", module_path: str = None) -> Any:
        # 1. Verificar Budget se module_path for fornecido
        if module_path:
            from utils.budget_guard import MicroCFO
            recommended_model = MicroCFO.check_budget(module_path)
            
            if recommended_model == "STOP":
                raise Exception(f"BLOCK: Teto de gastos atingido para o módulo {os.path.basename(module_path)}")
            
            # Se o Micro-CFO recomendar o modo econômico, ele substitui o primário
            if recommended_model == "gpt-4o-mini":
                primary_model = "gpt-4o-mini"
                print(f"   [RESILIENCE] -> Forçando MODO ECONÔMICO devido ao budget.")

        # 2. Tentar Chamada
        try:
            print(f"   [RESILIENCE] Tentando Modelo: {primary_model}")
            llm = ChatOpenAI(model=primary_model, temperature=0.3)
            response = llm.invoke(messages)
            
            # 3. Atualizar Gasto (Simplificado: assumindo tokens médios se não disponíveis)
            if module_path:
                # Na vida real, pegaríamos o uso real da response.usage_metadata
                MicroCFO.update_spend(module_path, primary_model, 1000, 500) 
            
            return response
        except Exception as e:
            # ... resto da lógica de failover (já existente ou a ser adaptada)
            print(f"   [RESILIENCE] ⚠️ Falha: {e}")
            # Se falhou o primário, tenta o secundário (failover tradicional)
            llm_backup = ChatOpenAI(model=secondary_model, temperature=0.3)
            return llm_backup.invoke(messages)

def get_resilient_llm_response(messages: List[BaseMessage], state: Dict[str, Any], primary: str = "gpt-4o"):
    """
    Helper para ser usado dentro dos nós do LangGraph.
    """
    response = GeniusResilience.invoke_with_failover(messages, primary_model=primary)
    
    # Se detectou failover, registra no estado para o CFO
    if "[FAILOVER_ACTIVE]" in response.content:
        if "failover_events" not in state:
            state["failover_events"] = []
        state["failover_events"].append({
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
            "from": primary,
            "to": "gpt-4o-mini"
        })
    
    return response
