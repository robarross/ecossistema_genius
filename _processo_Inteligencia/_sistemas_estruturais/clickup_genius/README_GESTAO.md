# Guia de Gerenciamento Híbrido (IA + Humano)

O Ecossistema ClickUp Genius foi projetado para ser gerenciado de duas formas sincronizadas:

## 1. Interface Web (Humano)
Acesse o arquivo `3_Interface/index.html` no seu navegador.
- Gerenciamento visual da hierarquia.
- Kanban, Gantt e Dashboards em tempo real.
- Ideal para monitoramento e ações rápidas do usuário.

## 2. Antigravity CLI (IA)
O Antigravity pode gerenciar o sistema diretamente através do módulo PowerShell localizado em `4_Antigravity_CLI/clickup_ops.psm1`.

### Como a IA (Antigravity) gerencia o sistema:
Sempre que o usuário pedir algo como "Crie uma tarefa para monitorar o solo", o Antigravity executará comandos internos como:
```powershell
Import-Module ./clickup_ops.psm1
Create-Task -Title "Monitorar Solo" -Description "Ação via Antigravity" -Status "A Fazer"
```

### Comandos Disponíveis para a IA:
- `List-Workspaces`: Visualiza a estrutura global.
- `Create-Task`: Adiciona novas atividades.
- `Delete-Entity`: Remove itens (Workspaces, Spaces, etc).

---
**Sincronização:** Como ambos utilizam o Supabase como Single Source of Truth (SSoT), qualquer alteração feita por mim (IA) aparecerá instantaneamente para você (Humano) na página `index.html` e vice-versa.
