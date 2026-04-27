# Skill: Vigilância e Auto-Cura da Malha Agêntica

## 1. Descrição
Capacidade do Agente Guardião (#G) de monitorar a "pulsação" de sua equipe modular e restaurar o estado operacional em caso de falhas ou ausência de agentes.

## 2. Capacidades Técnicas
*   **Monitoramento de Heartbeat**: Verificar se os arquivos de DNA e Skills de cada membro da equipe modular (#M, #P, #PR, #S, #B) estão presentes e íntegros.
*   **Detecção de Drifts**: Identificar alterações não autorizadas na configuração dos agentes.
*   **Protocolo de Respawn**: Disparar eventos no Genius Bus solicitando ao Criador de Agentes (#05) a re-instalação de um agente que parou de responder ou foi deletado.

## 3. Gatilhos de Ação
*   **Check Semanal**: Auditoria completa da estrutura de pastas do módulo.
*   **Evento Crítico**: Recebimento de erro de execução de um agente subordinado via Bus.

---
**Agente Responsável**: Guardião do Módulo (#G)
**Versão**: 1.0.0
