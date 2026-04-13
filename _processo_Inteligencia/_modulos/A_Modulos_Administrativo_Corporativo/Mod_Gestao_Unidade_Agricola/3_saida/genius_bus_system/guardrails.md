# GUARDRAILS 🚧: Genius Bus

Este documento define as barreiras de segurança e limites operativos do Barramento Universal para evitar loops infinitos, saturação de dados ou falhas de governança.

## 1. Limites de Escrita (Throttling)
- **Frequência Máxima:** Cada agente ou página pode realizar no máximo 1 escrita a cada 5 segundos para telemetria não-crítica.
- **Prevenção de Flood:** Se um loop de erro ocorrer, o barramento deve silenciar o agente emissor após 10 tentativas falhas consecutivas, notificando o **Guardian (#100)**.

## 2. Validação de Mensagem (Schema Enforcement)
- Todo log enviado via `dispatchLog` DEVE conter os campos `agent_id` e `event_type`.
- Mensagens sem payload estruturado (JSON) serão rejeitadas pelo barramento antes de atingirem o Supabase para economizar recursos.

## 3. Autoridade Financeira (Específico para #16)
- O **Agente #16 (ERP)** não pode registrar movimentações acima de **R$ 50.000,00** via barramento sem uma chave de autorização manual gerada pelo Roberto.
- Tentativas de burlar este limite bloqueiam a conta do agente para auditoria imediata.

## 4. Segurança de Nuvem
- **CORS Restricted:** Apenas origens autorizadas (Localhost e o Domínio Agrícola Final) podem enviar requisições.
- **Anonymization:** Dados sensíveis de funcionários (se existirem) devem ser anonimizados antes do envio para a telemetria externa.

## 5. Protocolo de Queda (Offline Mode)
- Caso o `ping` para o Supabase retorne > 2000ms ou erro 5xx, o sistema deve entrar em **Modo de Emergência Lokal**.
- Os dados são salvos no `localStorage` com a flag `sync_pending: true`.
- Uma notificação visual de "Nuvem Offline" deve ser exibida no cockpit.
