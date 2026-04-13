# IDEIA: Genius Bus (Barramento Universal de Dados)

## 1. Visão Central
Transformar o Ecossistema Genius de um conjunto de módulos isolados em um organismo digital unificado, utilizando um "Sistema Nervoso Central" para persistência de dados e comunicação entre agentes.

## 2. O Problema
Atualmente, os dados (XP, Medalhas, Logs) residem no `localStorage` do navegador. Isso causa:
- **Perda de Dados:** Se o cache é limpo, o progresso desaparece.
- **Isolamento:** Agentes não conseguem ler as ações uns dos outros em tempo real.
- **Inconsistência:** Dificuldade em manter um Dashboard Único entre diferentes dispositivos.

## 3. A Solução
Implementar uma camada de persistência externa via **Supabase (PostgreSQL)** e interface operacional via **Coda**, centralizada no **Agente #18 (Criador de Dados)**.

## 4. Diferenciais Operacionais
- **Memória Infinita:** O progresso do Roberto é inabalável.
- **Proatividade:** Gatilhos (Triggers) automáticos. Se o ERP registra uma venda, o Guardian audita o estoque instantaneamente.
- **Sincronia Global:** O cockpit no PC mostra os mesmos dados do tablet ou celular.

## 5. Stakeholders
- **Arquiteto (User):** Recebe o Dashboard Único e relatórios consolidados.
- **Genius Systems (#04):** Orquestra a implantação.
- **Criador de Dados (#18):** Mantém o motor (Bus).
- **Guardian (#100):** Realiza auditoria em tempo real via telemetria.
