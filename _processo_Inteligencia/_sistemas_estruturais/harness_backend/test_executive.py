import requests
import json
import uuid

# Configurações
URL = "http://localhost:8000/webhook/orchestrate"
EXECUTION_ID = str(uuid.uuid4())

payload = {
    "execution_id": EXECUTION_ID,
    "pipeline_id": "pl-executive-governance",
    "task_title": "Revisão Estratégica Semanal - CEO/CFO"
}

print(f"🚀 Enviando trigger para {URL}...")
try:
    response = requests.post(URL, json=payload)
    print(f"✅ Resposta: {response.status_code}")
    print(json.dumps(response.json(), indent=2))
except Exception as e:
    print(f"❌ Erro: {e}")
