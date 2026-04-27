import os
from supabase import create_client
from dotenv import load_dotenv
import json

load_dotenv()
supabase = create_client(os.environ['SUPABASE_URL'], os.environ['SUPABASE_SERVICE_KEY'])

res = supabase.table('clickup_tasks').select('id, title, description, agent_id, status').order('created_at', desc=True).limit(5).execute()

print("ULTIMAS TAREFAS CRIADAS:")
for r in res.data:
    print(f"ID: {r['id']}")
    print(f"Titulo: {r['title']}")
    print(f"Desc: {r['description'][:50]}...")
    print(f"Status: {r['status']}")
    print("-" * 20)
