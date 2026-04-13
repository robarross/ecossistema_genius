# ðŸ› ï¸ Skill: Roteamento de Mensagens (Traffic Broker)

## DescriÃ§Ã£o:
Esta skill permite ao **Genius HUB** atuar como um roteador inteligente. Ela garante que as intenÃ§Ãµes geradas pelo **Genius IN** sejam encaminhadas aos agentes de execuÃ§Ã£o corretos.

## FunÃ§Ãµes Centrais:
1.  **Despacho de IntenÃ§Ã£o:** Traduz a diretriz estratÃ©gica em comandos tÃ©cnicos para as skills dos agentes.
2.  **GestÃ£o de Filas:** Organiza as solicitaÃ§Ãµes para evitar sobrecarga de processamento nos agentes perifÃ©ricos.
3.  **Audit Trail:** Registra o caminho de cada mensagem (Remetente -> HUB -> DestinatÃ¡rio).

## Workflow:
1.  **InterceptaÃ§Ã£o:** Recebe a mensagem no barramento central.
2.  **AnÃ¡lise de Destino:** Consulta o Registro Central para encontrar o melhor agente para a tarefa.
3.  **Entrega:** Encaminha a mensagem e o contexto necessÃ¡rio.
4.  **Recibo:** Aguarda o ACK (confirmaÃ§Ã£o) do agente receptor.

## Regras de Ouro:
- "Zero perda de pacotes estratÃ©gicos."
- "LatÃªncia mÃ­nima, precisÃ£o mÃ¡xima."

