# ðŸ› ï¸ Skill: Registro Central (Global Registry)

## DescriÃ§Ã£o:
Esta skill Ã© a base de dados operacional do **Genius HUB**. Ela gerencia o "Livro de Registro" de todos os agentes ativos no ecossistema, atribuindo identidades Ãºnicas e rastreando metadados de funÃ§Ã£o.

## FunÃ§Ãµes Centrais:
1.  **Registro de Nascimento:** Recebe requisiÃ§Ãµes do Criador de Agentes (#1) e valida o DNA para entrada no sistema.
2.  **Mapeador de Especialidades:** Indexa "o que cada agente faz" para facilitar a descoberta estratÃ©gica pelo Genius IN.
3.  **GestÃ£o de Status:** Monitora se o agente estÃ¡ `Online`, `Offline`, `Busy` ou `Deprecated`.

## Workflow:
1.  **RecepÃ§Ã£o:** Ouve o canal de ativaÃ§Ã£o.
2.  **ValidaÃ§Ã£o:** Checa se o DNA possui as 14 camadas obrigatÃ³rias.
3.  **IndexaÃ§Ã£o:** Adiciona o agente Ã  tabela `global_registry.json` (virtual).
4.  **PublicaÃ§Ã£o:** Notifica o ecossistema sobre a presenÃ§a do novo especialista.

## Regras de Ouro:
- "Um agente nÃ£o registrado Ã© um invasor."
- "A integridade do registro Ã© a integridade do sistema."

