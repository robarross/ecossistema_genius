# PRD: Genius Bus (Barramento Universal de Dados)

## 1. Objetivos do Produto (KPIs)
- **Integridade:** 100% dos ganhos de XP devem ser persistidos externamente.
- **Latência:** Tempo de resposta de leitura/escrita < 500ms.
- **Conectividade:** Sincronização automática entre as páginas `academia_*.html` e o `portal_visual_unidade_agricola.html`.

## 2. Requisitos Funcionais (O QUÊ)
### RF01: Persistência de Gamificação
- O sistema deve salvar XP total, Nível Atual e Medalhas Conquistadas em tabelas do Supabase.
### RF02: Barramento de Eventos (Telemetry)
- Toda ação crítica (ex: "Curso concluído", "Alteração de Tema", "Intervenção do Guardian") deve gerar um log na tabela de eventos.
### RF03: Identidade Única
- O sistema deve reconhecer o usuário (Roberto) via ID único para filtrar os dados corretos.
### RF04: Gatilho de Autocura
- O barramento deve permitir que o **Agente #100** leia a tabela de eventos e dispare notificações proativas caso detecte erros recorrentes de outros agentes.

## 3. Requisitos Não-Funcionais (COMO DEVE SER)
### RNF01: Segurança (Guardrails)
- Credenciais de API não devem estar expostas em texto puro no código (usar variáveis de ambiente ou placeholders).
### RNF02: Disponibilidade
- O sistema deve possuir um *fallback* para `localStorage` caso a conexão com o Supabase falhe (Modo Offline).

## 4. Estrutura de Tabelas Sugerida
- `genius_user_stats`: xp, level, current_theme, medals (jsonb).
- `genius_system_events`: timestamp, agent_id, event_type, payload (jsonb), criticality.

## 5. Critérios de Aceite
- Finalizar a aula na Academia e ver o XP ser atualizado no Portal Mestre sem atualizar a página (via polling ou monitoramento).
