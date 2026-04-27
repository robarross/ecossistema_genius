# 🧩 Skill: Orquestração Modular (Demurgos Link)

## Descrição:
Esta skill habilita o agente a conectar diferentes módulos e garantir que eles operem como uma unidade coesa. Ela define as "Vias de Comunicação" e os protocolos de troca de dados entre submódulos.

---

## Capacidades:
- **Definição de Fronteiras:** Mapear onde termina um módulo e começa outro (ex: Limite entre Gestão Vegetal e Gestão Animal).
- **Protocolos de Dados (Links E/P/S):** Estabelecer conexões onde a **Saída** do Módulo A alimenta automaticamente a **Entrada** do Módulo B.
- **Hierarquia Funcional:** Configurar o isolamento das camadas, permitindo que o Agente só escreva na sua pasta de **Processo** e na sua pasta de **Saída**.
- **Protocolos de Supervisão e Guarda:**
    - **Check-in Gerencial:** Procedimento automático de envio de KPIs para a pasta `_integração_gerencial`.
    - **Alerta de Crise:** Protocolo de emergência que ativa o **Agente Guardião #100** em caso de entropia alta detectada nos logs do módulo.
    - **Expansão sob Demanda:** Capacidade de "acoplar" novos agentes (ex: **Professor**) via o slot de extensão, fornecendo a eles o contexto imediato do módulo.

---

## Regras de Ouro:
- "A modularidade é o segredo da escalabilidade."
- "A saída de um é o alimento do outro."
- "Interfaces claras evitam bugs de comunicação."
