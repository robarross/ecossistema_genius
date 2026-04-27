Este documento formaliza a estrutura administrativa obrigatória para cada componente do ecossistema. Todo novo módulo deve nascer com sua equipe completa para garantir a integridade da Metodologia Genius.

## 🚫 Lei da Não-Redundância e Modularidade Atômica
É terminantemente proibida a criação de componentes redundantes em qualquer camada do ecossistema. A regra de **Unicidade** aplica-se obrigatoriamente a:
1.  **Agentes e Submódulos**: Papéis funcionais e técnicos.
2.  **Arquitetura Técnica**: Skills, Ferramentas (Tools), Fractals, Plugins, Conectores e Pipelines.
3.  **Conhecimento e Dados**: Prompts Mestres, Bases de RAG, Dashboards e Widgets.
    *   **O que NÃO fazer**: Criar uma nova Skill ou Conector para algo que já existe em outro módulo. Deve-se **importar ou referenciar** o componente original.
    *   **Políticas de Unicidade**: Antes de qualquer desenvolvimento, o agente deve auditar os catálogos existentes (`mapa_de_modulos.md`, `skills`, `functions`). A soberania do sistema depende da sua simplicidade e ausência de ruído.

## 🏢 1. Estrutura do Módulo (Autoridade do Guardião)
Cada módulo principal é regido pela autoridade raiz do **Agente Guardião (#G)**. Ele coordena a Pentatrilogía e as equipes técnicas (#T).

| Sigla | Agente (Papel) | Autoridade | Linhagem |
| :--- | :--- | :--- | :--- |
| **#G-** | **Guardião** | **Comando Raiz** | Arquiteto (#06) |
| **#P-** | Pesquisador | Inteligência | Guardião (#G) |
| **#PR-** | Professor | Educação | Guardião (#G) |
| **#M-** | Gerente | Tática | Guardião (#G) |
| **#S-** | Secretária | Suporte | Guardião (#G) |
| **#T-** | Técnico | Especialista | Guardião (#G) |

## 🛠️ 2. Estrutura do Submódulo (Especialização)
Nomenclatura padrão: `agente_tecnico_modular_[nome_do_submodulo]`.

| Sigla | Agente | Exemplo de Nome do Agente |
| :--- | :--- | :--- |
| **#T-** | **Técnico** | `agente_tecnico_modular_solo` |

## 📁 3. Organização de Arquivos e Locação
Para manter a Fonte Única da Verdade (SSOT) e a integridade industrial:
*   **Módulos**: Toda a Pentatrilogia de agentes modulares (#G, #P, #PR, #M, #S) deve ter seus arquivos de DNA e Skills armazenados na pasta oculta `.equipe_modular_[NOME]` dentro da pasta `2_processo` do seu módulo de origem.
*   **Submódulos**: O Agente Técnico (#T) deve residir na pasta `equipe_submodular` dentro de `2_processo` do seu submódulo específico.
*   **Fábricas (Super)**: Permanecem na pasta centralizada de Super Agentes.

## ⚙️ 4. Automação de Nascimento
1. O **#06** instancia o **Guardião (#G)**.
2. O **Guardião** (via #06 e #27) comanda o nascimento dos agentes paralelos (#P, #PR, #M, #S e #T).
3. Todo nascimento modular ou técnico deve ter o `creator_id` apontando para o **Guardião** do módulo pai.
4. O DNA de cada agente é injetado com suas skills base conforme o papel.

---
**Data de Aprovação**: 2026-04-15
**Supervisor Supremo**: #100 Genius Ecossistema
