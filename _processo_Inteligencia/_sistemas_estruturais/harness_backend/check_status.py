import os
from supabase import create_client
from dotenv import load_dotenv
import json

load_dotenv()
supabase = create_client(os.environ['SUPABASE_URL'], os.environ['SUPABASE_SERVICE_KEY'])

res = supabase.table('harness_chat_executions').select('id, status, metadata, logs').order('created_at', desc=True).limit(5).execute()

for r in res.data:
    print(f"ID: {r['id']}")
    print(f"Status: {r['status']}")
    print(f"Metadata: {json.dumps(r['metadata'], indent=2)}")
    print("-" * 20)
