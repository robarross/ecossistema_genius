# ðŸ‚ Blueprint de DomÃ­nio: PecuÃ¡ria de Corte

## Escopo:
Este template configura a estrutura de dados inicial para fractais focados em cria, recria e engorda.

---

### ðŸ“‚ Subfractal: Cadastros
**Arquivo: `campos_obrigatorios.md`**

| Campo | Tipo | DescriÃ§Ã£o |
| :--- | :--- | :--- |
| **Brinco/ID** | Texto | IdentificaÃ§Ã£o Ãºnica do animal ou lote. |
| **GMD** | NumÃ©rico | Ganho MÃ©dio DiÃ¡rio esperado/realizado. |
| **Peso Inicial** | NumÃ©rico | Peso na entrada do lote ou ciclo. |
| **RaÃ§a/Cruzamento** | Texto | Base genÃ©tica do animal. |
| **Pasto/Piquete** | ID | LocalizaÃ§Ã£o atual no sistema de pastejo. |
| **Protocolo SanitÃ¡rio** | Lista | Status de vacinaÃ§Ã£o e vermifugaÃ§Ã£o. |

---

### ðŸ“‚ Subfractal: GestÃ£o de Dados
**Arquivo: `esquema_dados.md`**

- **NutriÃ§Ã£o:** SuplementaÃ§Ã£o (Sal mineral, Proteico, RaÃ§Ã£o).
- **Manejo:** Troca de pasto e descanso de piquetes.
- **ReproduÃ§Ã£o:** IATF, Touro, Partos (se aplicÃ¡vel).
- **SaÃºde:** OcorrÃªncias clÃ­nicas e tratamentos.

---
*Template gerido pelo Agente #07.*

