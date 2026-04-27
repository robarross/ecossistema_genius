# Arquitetura Harness — Ecossistema Genius

Este documento descreve o fluxo de orquestração e a estrutura lógica do sistema Harness, conforme definido no diagrama de design do sistema.

## Visão Geral do Fluxo

```mermaid
graph TD
    Input[Entrada da Tarefa] --> Harness

    subgraph Harness [Harness — Camada de Orquestração]
        Parse[Parse e Classificação<br/>Identifica intent e habilidades] --> Router[Roteador de Agentes<br/>Seleciona por skill e contexto]
        
        Router --> Atlas[Atlas<br/>Pesquisa]
        Router --> Echo[Echo<br/>Comunicação]
        Router --> Sage[Sage<br/>Análise]
        Router --> Flow[Flow<br/>Automação]
        Router --> Agente30[Agente #30<br/>Telegram]

        Atlas & Echo & Sage & Flow & Agente30 --> Context[Gerenciador de Estado e Contexto<br/>Memória compartilhada]
        
        Context --> Errors[Controle de Erros<br/>Fallback e retry]
        Context --> Monit[Monitoramento<br/>Logging e métricas]
    end

    Harness --> Guardrails[Guardrails e Contratos<br/>Permissões e limites por agente]
    Guardrails --> Supabase[(Supabase — Backbone de Dados<br/>agents, skills, pipelines, chat_executions, connectors)]
    Supabase --> Output[Resultado Consolidado]

    style Harness fill:#1a1a2e,stroke:#7070db,color:#fff
    style Supabase fill:#004d40,stroke:#00bfa5,color:#fff
    style Input fill:#333,stroke:#666,color:#fff
    style Output fill:#333,stroke:#666,color:#fff
```

## Componentes Críticos

### 1. Harness (Orquestração)
É o ambiente de execução onde a inteligência é processada. 
- **Roteamento Dinâmico:** A capacidade de escolher agentes específicos baseados na necessidade da tarefa.
- **Memória Compartilhada:** Fundamental para que o Agente #30 (Telegram) saiba o que o Sage (Análise) concluiu, por exemplo.

### 2. Guardrails e Contratos
Esta camada atua como o sistema de segurança, garantindo que nenhum agente exceda seus limites de API ou permissões de dados antes de gravar no Supabase.

### 3. Supabase Backbone
A estrutura de dados centralizada que sustenta o ecossistema:
- `agents`: Definições e identidades.
- `skills`: Capacidades técnicas.
- `pipelines`: Fluxos de trabalho pré-definidos.
- `chat_executions`: Histórico de interações.
- `connectors`: Integrações externas.

---
*Documento gerado para preservação da arquitetura sistêmica do Genius.*
