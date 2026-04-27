# Workflow: Criação de Sistemas (A Estratégia)

Este documento define o "Checklist de Procedimentos" (a receita) para a criação de novos módulos e sistemas dentro do Ecossistema Genius, conforme os princípios de **Context Engineering**.

## 1. Discovery (Descoberta)
- **Objetivo:** Validar a necessidade e evitar redundância.
- **Ação:** Consultar o Agente #Atlas para verificar se já existe infraestrutura similar no Segundo Cérebro.
- **Lei Fundamental:** Lei da Não-Redundância.

## 2. PRD (Product Requirements Document)
- **Objetivo:** Criar a planta técnica da casa.
- **Checklist:**
    - Definição de Objetivos.
    - Modelagem de Dados (Tabelas e Relacionamentos).
    - Definição de Fluxos de Entrada (IN) e Saída (OUT).
    - Mapeamento de Agentes Necessários.

## 3. Context Engineering (Regras e Workflows)
- **Rules:** Instruções permanentes (ex: ".agent/rules/").
- **Workflows:** Checklists específicos para este novo sistema.

## 4. Security Foundation (Base de Segurança)
- **Ação:** Implementar RLS (Row Level Security) em todas as novas tabelas do Supabase.
- **Validação:** Testar isolamento (User A != User B).

## 5. Modular Assembly (Padrão LEGO)
- **Estrutura:** Garantir que o sistema possua as 4 camadas:
    - **0-IN:** Portas de entrada de dados.
    - **1-DNA:** Lógica e inteligência (Agentes).
    - **2-OUT:** Formatos de saída e notificações.
    - **3-LIB:** Biblioteca de conhecimento e documentação.

---
*Manual de Governança Genius - Soberania Digital e Industrialização.*
