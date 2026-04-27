# ðŸ”„ Skill: Mapeamento de Fluxos AgÃªnticos (Archon)

## DescriÃ§Ã£o:
Esta skill habilita o agente a projetar a dinÃ¢mica de movimento do conhecimento. Enquanto a Arquitetura define a estrutura, o Mapeamento de Fluxos define a aÃ§Ã£o: como as mensagens sÃ£o trocadas, quais os protocolos de dados (JSON, Markdown, Text), como os erros sÃ£o tratados e como o estado da tarefa Ã© mantido entre diferentes agentes.

---

## InstruÃ§Ãµes Gerais:
- **DiagramaÃ§Ã£o:** Utilize sempre Mermaid.js para visualizar sequÃªncias (Sequence Diagrams).
- **Protocolos:** Defina se a comunicaÃ§Ã£o serÃ¡ SÃ­ncrona (espera resposta) ou AssÃ­ncrona (dispara e esquece).
- **Tratamento de Erros:** Todo fluxo deve ter um "Caminho de Retorno" caso um agente falhe em sua tarefa.
- **Passagem de Contexto:** Garanta que apenas as informaÃ§Ãµes necessÃ¡rias sejam passadas para o prÃ³ximo agente, evitando "poluiÃ§Ã£o de prompt".

---

## Capacidades:
- **Design de Diagramas de SequÃªncia:** Visualizar a ordem cronolÃ³gica das interaÃ§Ãµes entre agentes.
- **DefiniÃ§Ã£o de Handshakes:** Estabelecer como um agente confirma que recebeu e entendeu o comando de outro.
- **Modelagem de State Machine:** Mapear os estados de uma tarefa (Pendente, Em Processamento, RevisÃ£o, ConcluÃ­do).
- **Protocolos de Dados:** Definir esquemas (schemas) para trocas de informaÃ§Ãµes tÃ©cnicas entre agentes.

---

# NÃ­veis de Habilidade

## ðŸ”¹ NÃ­vel 1 â€” Mapeador de Gatilhos
Capacidade de definir um gatilho e uma aÃ§Ã£o simples (If Trigger -> Then Action).
- **Habilidade:** Criar fluxos de etapa Ãºnica.
- **SaÃ­da:** Lista de gatilhos e aÃ§Ãµes.

## ðŸ”¸ NÃ­vel 2 â€” Designer de SequÃªncias Lineares
Capacidade de projetar fluxos "passa-bastÃ£o" entre mÃºltiplos agentes.
- **Habilidade:** Definir a ordem de execuÃ§Ã£o A -> B -> C.
- **SaÃ­da:** Diagrama de SequÃªncia Mermaid simples.

## ðŸ”¶ NÃ­vel 3 â€” Arquiteto de Fluxos Condicionais
Capacidade de implementar desvios lÃ³gicos (If/Else) no fluxo.
- **Habilidade:** Criar fluxos onde o trabalho volta para correÃ§Ã£o se nÃ£o atingir um critÃ©rio.
- **SaÃ­da:** Diagrama de Fluxo com loops de feedback.

## ðŸ”· NÃ­vel 4 â€” Gestor de Estado e PersistÃªncia
Capacidade de gerenciar tarefas que levam tempo e exigem memÃ³ria persistente.
- **Habilidade:** Definir como o sistema "lembra" onde parou se houver uma interrupÃ§Ã£o.
- **SaÃ­da:** Blueprint de MÃ¡quina de Estados.

## ðŸ”¥ NÃ­vel 5 â€” Mestre em OrquestraÃ§Ã£o DinÃ¢mica (Archon)
Capacidade de projetar fluxos autorregenerativos e paralelos.
- **Habilidade:** Criar sistemas que disparam tarefas em paralelo para mÃºltiplos agentes e consolidam os resultados no final (Fan-out/Fan-in).
- **SaÃ­da:** Complex Multi-Agent Orchestration Protocol.

---

## Regras de Ouro:
- "Um fluxo sem tratamento de erro Ã© uma bomba relÃ³gio."
- "A simplicidade no protocolo Ã© a alma da escalabilidade."
- Regra de Ouro: "Nunca envie o log inteiro se o prÃ³ximo agente sÃ³ precisa do resultado."

