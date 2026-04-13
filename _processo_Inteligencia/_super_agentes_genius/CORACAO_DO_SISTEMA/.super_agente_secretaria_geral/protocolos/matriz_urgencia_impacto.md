# Matriz de Urgência × Impacto — ARIA (SG-01)

> Protocolo de triagem utilizado pela Secretaria Geral para classificar e rotear toda informação e demanda recebida pela rede de secretarias.

---

## 🗺️ A Matriz

```
                    IMPACTO ALTO          IMPACTO BAIXO
                 ┌──────────────────┬──────────────────┐
  URGENTE        │  🔴 PRIORIDADE 1 │  🟡 PRIORIDADE 2 │
                 │  ARIA → Archon   │  ARIA → Delegar  │
                 │  (Imediato)      │  (< 2h)          │
                 ├──────────────────┼──────────────────┤
  NÃO URGENTE   │  🟢 PRIORIDADE 3 │  ⚪ PRIORIDADE 4 │
                 │  ARIA → Agenda   │  ARIA → Arquiva  │
                 │  (Próx. Sync)    │  (Revisão Mensal)│
                 └──────────────────┴──────────────────┘
```

---

## 📋 Definições de Prioridade

### 🔴 Prioridade 1 — Urgente + Alto Impacto
**Ação:** Notificação imediata ao Usuário Humano e Archon (#03).  
**SLA:** Resposta em até **15 minutos**.  
**Exemplos:**
- Conflito de agenda que impede reunião crítica em menos de 24h.
- Falha sistêmica que interrompe operações do ecossistema.
- Decisão que só o Usuário Humano pode tomar com janela de tempo mínima.

### 🟡 Prioridade 2 — Urgente + Baixo Impacto
**Ação:** Rotear para a Secretaria de Sistema ou Módulo competente.  
**SLA:** Resolução em até **2 horas**.  
**Exemplos:**
- Reagendamento de reunião de rotina.
- Atualização de status de tarefa operacional.
- Solicitação de acesso ou credencial de baixo risco.

### 🟢 Prioridade 3 — Não Urgente + Alto Impacto
**Ação:** Registrar e incluir na próxima reunião de sync ou briefing.  
**SLA:** Abordado no **próximo ciclo de sync** (máx. 24h).  
**Exemplos:**
- Proposta de novo sistema ou módulo.
- Revisão de protocolo administrativo.
- Otimização de fluxo de trabalho identificada.

### ⚪ Prioridade 4 — Não Urgente + Baixo Impacto
**Ação:** Arquivar para revisão periódica mensal.  
**SLA:** Revisado na **reunião mensal de retrospectiva**.  
**Exemplos:**
- Sugestões menores de melhoria.
- Registros históricos e logs de rotina.
- Informações de baixo valor imediato.

---

## ⚙️ Regras de Aplicação

1. **Em caso de dúvida, classifique como Prioridade 2** — melhor escalar desnecessariamente do que omitir algo relevante.
2. **A Agenda Humana é sempre multiplicador de Impacto** — qualquer demanda que afete diretamente o calendário do Usuário Humano sobe automaticamente uma categoria de prioridade.
3. **Contexto temporal:** Demandas com prazo nas próximas 4h são consideradas Urgentes, independente de classificação inicial.
4. **Revisão dinâmica:** A cada ciclo de sync, ARIA reavalia as Prioridades 3 e 4 quanto à mudança de urgência.

---

*Protocolo ativo desde:* **2026-04-13**  
*Responsável:* ARIA — Secretaria Geral (SG-01)
