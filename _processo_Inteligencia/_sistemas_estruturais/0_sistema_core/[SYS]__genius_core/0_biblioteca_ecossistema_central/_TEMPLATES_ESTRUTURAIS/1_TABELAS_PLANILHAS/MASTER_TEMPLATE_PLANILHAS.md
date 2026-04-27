# 📊 Master Template: Planilhas e Bancos de Dados
# ID: T-PLAN-MASTER-01
# Versão: 1.0.0

## 🏷️ Propriedades do Template
*   **Sistema**: [A|B|C|D|E|F]
*   **Módulo**: [Nome do Módulo]
*   **Submódulo**: [Nome do Submódulo]
*   **Fractal**: Planilha de Banco de Dados / Dashboard

---

## 🏗️ Estrutura de Colunas Recomenda (SSOT)
| Campo | Tipo | Descrição | Exemplo |
| :--- | :--- | :--- | :--- |
| `ID_GENIUS` | UID | Identificador único universal do registro | `GNS-E-001` |
| `TIMESTAMP` | ISO8601 | Data e hora exata da inserção | `2026-04-17T20:00:00Z` |
| `SISTEMA_REF` | Char(1) | Letra do sistema (A a F) | `E` |
| `MODULO_REF` | String | Nome do módulo de origem | `Produção Vegetal` |
| `RESPONSAVEL_ID` | AgentID | ID do agente que gerou o dado | `#D-E` |
| `DADO_BRUTO` | JSON/Text | O conteúdo principal do registro | `{ "solo": "pH 6.5" }` |
| `STATUS_LEGO` | Enum | Estado do dado (PENDENTE, VALIDADO, ERRO) | `VALIDADO` |

---

## 🛠️ Regras de Preenchimento
1.  **Não-Redundância**: Nunca duplique um ID que já existe no Supabase.
2.  **Integridade**: Campos de data devem sempre usar o padrão internacional.
3.  **Conectividade**: Sempre referenciar o `Módulo_Pai` para rastreabilidade.
