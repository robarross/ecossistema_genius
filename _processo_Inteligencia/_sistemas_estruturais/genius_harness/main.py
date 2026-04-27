import sys
from unittest.mock import MagicMock
# Patch universal para evitar erro de 'langchain.debug'
mock_lc = MagicMock()
mock_lc.debug = False
sys.modules['langchain'] = mock_lc

import os
from fastapi import FastAPI, Request, HTTPException, BackgroundTasks
from supabase import create_client, Client
from dotenv import load_dotenv

from fastapi.middleware.cors import CORSMiddleware

load_dotenv()

app = FastAPI(title="Genius Harness Backend", description="Motor de orquestração agentica")

# Configurar CORS para permitir chamadas da interface local
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Em produção, use ["http://localhost:8080"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inicializar cliente Supabase
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_KEY")

if SUPABASE_URL and SUPABASE_KEY:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
else:
    print("AVISO: Credenciais do Supabase não encontradas no ambiente.")
    supabase = None

@app.get("/")
def read_root():
    return {"status": "online", "service": "Genius Harness Backend"}

@app.post("/webhook/orchestrate")
async def handle_orchestration(request: Request, background_tasks: BackgroundTasks):
    try:
        payload = await request.json()
        print(f"INPUT Payload recebido: {payload}")
        
        # Tenta pegar do Supabase (formato 'record') ou direto (formato plano)
        record = payload.get("record") or payload
        
        execution_id = record.get("id") or record.get("execution_id")
        pipeline_id = record.get("pipeline_id", "pl-review-standard")
        metadata = record.get("metadata", {})
        task_title = metadata.get("task_title") or record.get("task_title") or "Sem título"
        
        if not execution_id:
            print("WARN Erro: execution_id não encontrado no payload")
            return {"status": "error", "message": "execution_id is required"}
            
        # Garantir que a execução existe no Supabase para que possa ser atualizada depois
        if supabase:
            check = supabase.table("harness_chat_executions").select("id").eq("id", execution_id).execute()
            if not check.data:
                print(f"DB Criando nova execução no Supabase: {execution_id}")
                supabase.table("harness_chat_executions").insert({
                    "id": execution_id,
                    "pipeline_id": pipeline_id,
                    "status": "running",
                    "metadata": metadata
                }).execute()
            
        print(f"RUN Iniciando orquestração: {execution_id} | Task: {task_title}")
        
        from engine.graph import run_pipeline
        background_tasks.add_task(run_pipeline, execution_id, pipeline_id, task_title)
        
        return {"status": "processing", "execution_id": execution_id}
        
    except Exception as e:
        print(f"ERROR Erro no webhook: {repr(e)}")
        return {"status": "error", "message": str(e)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
