import langchain
try:
    langchain.debug = False
except AttributeError:
    class LangChainStub:
        debug = False
    import sys
    if 'langchain' not in sys.modules:
        sys.modules['langchain'] = LangChainStub()
    else:
        langchain.debug = False

from typing import Dict, TypedDict, Any
from langgraph.graph import StateGraph, END
from agents.atlas import atlas_node
from agents.sage import sage_node
from agents.echo import echo_node
from agents.ceo import ceo_node
from agents.cfo import cfo_node
from agents.coo import coo_node
from agents.archon import archon_node
from agents.consensus import consensus_node
from agents.factory import factory_node
from agents.atlas_linker import atlas_linker_node
from agents.deployer import deployer_node
from agents.health import health_node
from agents.scribe import scribe_node
from agents.darwin import darwin_node
from agents.ingestor import ingestor_node
from agents.matcher import matcher_node
from agents.entropy import entropy_node
from agents.researcher import researcher_node
import os
import datetime

# 1. Definir o Estado (Memória) que passará entre os agentes
class HarnessState(TypedDict):
    execution_id: str
    pipeline_id: str
    task_input: str
    context_data: Dict[str, Any]
    audit_results: Dict[str, Any]
    board_debate: Dict[str, str]
    failover_events: list
    last_produced_path: str
    final_report: str
    status: str

# 2. Inicializar os Grafos por Pipeline

# A. Pipeline Padrão (Atlas -> Sage -> Echo)
standard_workflow = StateGraph(HarnessState)
standard_workflow.add_node("atlas", atlas_node)
standard_workflow.add_node("sage", sage_node)
standard_workflow.add_node("echo", echo_node)
standard_workflow.set_entry_point("atlas")
standard_workflow.add_edge("atlas", "sage")
standard_workflow.add_edge("sage", "echo")
standard_workflow.add_edge("echo", END)
standard_app = standard_workflow.compile()

# B. Pipeline Executivo (CEO/CFO/COO/CONSENSUS/ARCHON)
executive_workflow = StateGraph(HarnessState)
executive_workflow.add_node("ceo", ceo_node)
executive_workflow.add_node("cfo", cfo_node)
executive_workflow.add_node("coo", coo_node)
executive_workflow.add_node("consensus", consensus_node)
executive_workflow.add_node("archon", archon_node)
executive_workflow.set_entry_point("ceo")
executive_workflow.add_edge("ceo", "cfo")
executive_workflow.add_edge("cfo", "coo")
executive_workflow.add_edge("coo", "consensus")
executive_workflow.add_edge("consensus", "archon")
executive_workflow.add_edge("archon", END)
executive_app = executive_workflow.compile()

# C. Pipeline de Fábrica (Produção de Módulos)
factory_workflow = StateGraph(HarnessState)
factory_workflow.add_node("factory", factory_node)
factory_workflow.add_node("sage", sage_node)
factory_workflow.add_node("darwin", darwin_node)
factory_workflow.add_node("atlas_linker", atlas_linker_node)
factory_workflow.add_node("deployer", deployer_node)
factory_workflow.add_node("health", health_node)
factory_workflow.add_node("scribe", scribe_node)
factory_workflow.add_node("echo", echo_node)
factory_workflow.set_entry_point("factory")
factory_workflow.add_edge("factory", "sage")
factory_workflow.add_edge("sage", "darwin")
factory_workflow.add_edge("darwin", "atlas_linker")
factory_workflow.add_edge("atlas_linker", "deployer")
factory_workflow.add_edge("deployer", "health")
factory_workflow.add_edge("health", "scribe")
factory_workflow.add_edge("scribe", "echo")
factory_workflow.add_edge("echo", END)
factory_app = factory_workflow.compile()

# D. Pipeline de Auditoria Anti-Entropia
entropy_workflow = StateGraph(HarnessState)
entropy_workflow.add_node("entropy", entropy_node)
entropy_workflow.add_node("echo", echo_node)
entropy_workflow.set_entry_point("entropy")
entropy_workflow.add_edge("entropy", "echo")
entropy_workflow.add_edge("echo", END)
entropy_app = entropy_workflow.compile()

# E. Pipeline de Inteligência de Mercado
researcher_workflow = StateGraph(HarnessState)
researcher_workflow.add_node("researcher", researcher_node)
researcher_workflow.add_node("echo", echo_node)
researcher_workflow.set_entry_point("researcher")
researcher_workflow.add_edge("researcher", "echo")
researcher_workflow.add_edge("echo", END)
researcher_app = researcher_workflow.compile()

# F. Pipeline de Produção em Massa (Planilha -> Fábrica Multi-Fractal)
mass_production_workflow = StateGraph(HarnessState)
mass_production_workflow.add_node("ingestor", ingestor_node)
mass_production_workflow.add_node("matcher", matcher_node)
mass_production_workflow.add_node("factory", factory_node)
mass_production_workflow.add_node("sage", sage_node)
mass_production_workflow.add_node("echo", echo_node)

mass_production_workflow.set_entry_point("ingestor")
mass_production_workflow.add_edge("ingestor", "matcher")
mass_production_workflow.add_edge("matcher", "factory")
mass_production_workflow.add_edge("factory", "sage")
mass_production_workflow.add_edge("sage", "echo")
mass_production_workflow.add_edge("echo", END)
mass_production_app = mass_production_workflow.compile()

# 3. Mapeamento de Pipelines
PIPELINES = {
    "pl-standard": standard_app,
    "pl-executive-governance": executive_app,
    "pl-module-factory": factory_app,
    "pl-entropy-audit": entropy_app,
    "pl-market-intel": researcher_app,
    "pl-mass-production": mass_production_app
}

def get_pipeline(pipeline_id: str):
    return PIPELINES.get(pipeline_id, standard_app)

def run_pipeline(execution_id: str, pipeline_id: str, task_input: str):
    """
    Executa um pipeline do LangGraph e salva o resultado no Supabase.
    """
    app = get_pipeline(pipeline_id)
    
    # Estado inicial
    initial_state = {
        "execution_id": execution_id,
        "pipeline_id": pipeline_id,
        "task_input": task_input,
        "context_data": {},
        "audit_results": {},
        "board_debate": {},
        "failover_events": [],
        "last_produced_path": "",
        "final_report": "",
        "status": "running"
    }
    
    print(f"   [GRAPH] 🚀 Executando Pipeline: {pipeline_id}")
    final_state = app.invoke(initial_state)
    
    # Salvar resultado no Supabase
    from supabase import create_client
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_SERVICE_KEY")
    if url and key:
        supabase = create_client(url, key)
        try:
            supabase.table("harness_chat_executions").update({
                "status": "completed",
                "final_report": final_state.get("final_report", "Sem relatório"),
                "metadata": {
                    "last_produced_path": final_state.get("last_produced_path", ""),
                    "failover_events": final_state.get("failover_events", [])
                }
            }).eq("id", execution_id).execute()
            print(f"   [GRAPH] ✅ Resultado salvo no Supabase: {execution_id}")
        except Exception as e:
            print(f"   [GRAPH] ❌ Erro ao salvar resultado: {e}")
            
    return final_state
