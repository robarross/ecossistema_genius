import os
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()
supabase = create_client(os.environ['SUPABASE_URL'], os.environ['SUPABASE_SERVICE_KEY'])

# 1. Pegar um ID da tabela de agentes (usando a tabela legada 'agents' que a FK exige)
res_agent = supabase.table('agents').select('id, display_id').limit(1).execute()
if not res_agent.data:
    print("Erro: Nenhum agente encontrado na tabela 'agents'.")
    exit()
atlas_id = res_agent.data[0]['id']
atlas_display = res_agent.data[0]['display_id']

# 2. Pegar uma lista qualquer para anexar as tarefas
res_list = supabase.table('clickup_lists').select('id').limit(1).execute()
if not res_list.data:
    print("Erro: Nenhuma lista encontrada no ClickUp.")
    exit()
list_id = res_list.data[0]['id']

# 3. Criar 5 tarefas para sobrecarregar o Atlas
print(f"Criando 5 tarefas de teste para o Agente #Atlas ({atlas_id})...")
for i in range(1, 6):
    supabase.table('clickup_tasks').insert({
        'title': f'Tarefa de Estresse {i}',
        'description': 'Tarefa gerada para testar o balanceamento de carga do COO.',
        'status': 'Em Execução',
        'agent_id': atlas_id,
        'list_id': list_id
    }).execute()

print(f"Sucesso! O Agente {atlas_display} agora possui 5 tarefas 'Em Execução'.")
