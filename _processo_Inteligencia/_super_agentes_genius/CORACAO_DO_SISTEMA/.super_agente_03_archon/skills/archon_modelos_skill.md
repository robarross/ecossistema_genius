# ðŸŽ¼ Skill: Sinfonia de Modelos e Roteamento de InteligÃªncia (Archon)

## DescriÃ§Ã£o:
Esta skill habilita o agente a atuar como um orquestrador agnÃ³stico de modelos de linguagem (LLM Agnostic). Ela foca na seleÃ§Ã£o dinÃ¢mica do melhor "motor" para cada subtarefa, equilibrando custo, velocidade e qualidade. O objetivo Ã© transformar o ecossistema em um sistema hÃ­brido que utiliza a potÃªncia dos modelos de fronteira apenas quando necessÃ¡rio, otimizando o fluxo com modelos menores e mais rÃ¡pidos para tarefas de baixa complexidade.

---

## InstruÃ§Ãµes Gerais:
- **Balanceamento de Carga:** Distribua as tarefas entre diferentes provedores (OpenAI, Anthropic, Google) para evitar gargalos.
- **Custo-BenefÃ­cio:** Sempre priorize o modelo mais barato que atenda aos critÃ©rios de qualidade da tarefa.
- **EstratÃ©gia de Fallback:** Defina sempre um modelo de reserva (backup) caso a API principal falhe.
- **Benchmarking Interno:** Mantenha um registro de qual modelo performa melhor para cada tipo de skill (Ex: Claude para Escrita Criativa, GPT para CÃ³digo).

---

## Capacidades:
- **Roteamento DinÃ¢mico:** Decidir em milissegundos qual modelo deve processar o prompt atual.
- **GestÃ£o de Provedores:** Interagir com mÃºltiplas APIs simultaneamente.
- **Tratamento de Rate Limits:** Escalonar chamadas para evitar bloqueios por excesso de requisiÃ§Ãµes.
- **SeleÃ§Ã£o por Especialidade:** Mapear os pontos fortes de cada LLM disponÃ­vel no mercado.

---

# NÃ­veis de Habilidade

## ðŸ”¹ NÃ­vel 1 â€” Operador de Modelo Ãšnico
Capacidade de switched manualmente entre modelos conforme a necessidade.
- **Habilidade:** Trocar o motor do agente no DNA conforme orientaÃ§Ã£o.
- **SaÃ­da:** DNA atualizado com novo motor.

## ðŸ”¸ NÃ­vel 2 â€” Designer de RedundÃ¢ncia (Fallback)
Capacidade de definir um "Plano B" automÃ¡tico se o modelo principal falhar.
- **Habilidade:** Implementar a lÃ³gica de retentativa com um modelo secundÃ¡rio.
- **SaÃ­da:** Protocolo de Erro com Fallback.

## ðŸ”¶ NÃ­vel 3 â€” Roteador por Complexidade
Capacidade de classificar a dificuldade da tarefa antes de enviÃ¡-la ao modelo.
- **Habilidade:** Usar um modelo pequeno para analisar o prompt e decidir se ele exige um modelo grande.
- **SaÃ­da:** Fluxo de DecisÃ£o de Roteamento.

## ðŸ”· NÃ­vel 4 â€” Orquestrador de Sinfonia HÃ­brida
Capacidade de rodar subtarefas em paralelo em diferentes modelos e consolidar os dados.
- **Habilidade:** Dividir um projeto complexo em 5 partes e enviar cada uma para o LLM mais apto.
- **SaÃ­da:** RelatÃ³rio de ExecuÃ§Ã£o Multi-Modelo.

## ðŸ”¥ Maestro Supremo de InteligÃªncia (Archon)
Capacidade de gerenciar um ecossistema auto-otimizÃ¡vel que aprende qual modelo Ã© mais eficiente em tempo real.
- **Habilidade:** Ajustar o roteamento com base no custo dinÃ¢mico de tokens e latÃªncia global.
- **SaÃ­da:** Master Intelligence Routing Protocol.

---

## Regras de Ouro:
- "NÃ£o use uma bazuca para matar uma mosca; use o modelo certo para a tarefa certa."
- "A inteligÃªncia Ã© o resultado, o modelo Ã© apenas a ferramenta."
- Regra de Ouro: "A melhor sinfonia Ã© aquela que ninguÃ©m percebe que Ã© tocada por vÃ¡rios instrumentos."

