# Protocolo: Genius Bus (Mensageria em Tempo Real)

Este documento define as regras de tráfego de dados para o barramento de eventos do ecossistema. Todo agente de nível Super ou Core deve obrigatoriamente reportar atividades críticas neste canal.

## 📡 1. O Barramento (The Bus)
O **Genius Bus** é uma camada de transmissão via Websockets (Supabase Realtime) que permite a telemetria instantânea das ações agênticas.

## 📩 2. Estrutura da Mensagem (Payload)
Cada "Pulso" no barramento deve conter:
*   **Sender**: ID do Agente que disparou o evento.
*   **Action**: Verbo de ação (ex: `SPAWN`, `EXTRACT`, `ALERT`).
*   **Target**: ID do destinatário ou `BROADCAST` (Público).
*   **Data**: JSON com os detalhes da operação.
*   **Priority**: `INFO` (Verde), `WARN` (Amarelo), `CRITICAL` (Vermelho).

## 🖥️ 3. Exibição Visual
As mensagens são exibidas no **Console Flutuante** do Dashboard.
*   **Estética**: Fonte monoespadejada, brilho neon e timestamp preciso.
*   **Regra**: Apenas as últimas 50 mensagens são mantidas na memória do DOM para performance.

## ⚙️ 4. Fluxo de Publicação
1. O Agente executa sua tarefa.
2. O Agente dispara uma chamada SQL/API para a tabela `genius_system_events`.
3. O trigger do banco envia o sinal para o Dashboard via Realtime.

---
**Status do Barramento**: [Ativando...]
**Data de Implementação**: 2026-04-15
