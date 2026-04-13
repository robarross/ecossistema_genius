# ðŸŒ¾ Blueprint de DomÃ­nio: ProduÃ§Ã£o Vegetal

## Escopo:
Este template configura a estrutura de dados inicial para fractais focados em agricultura de grÃ£os e fibras.

---

### ðŸ“‚ Subfractal: Cadastros
**Arquivo: `campos_obrigatorios.md`**

| Campo | Tipo | DescriÃ§Ã£o |
| :--- | :--- | :--- |
| **Safra** | Texto | IdentificaÃ§Ã£o do ciclo (ex: 2024/25). |
| **TalhÃ£o** | ID | Identificador Ãºnico da Ã¡rea fÃ­sica. |
| **Cultura** | Lista | Soja, Milho, AlgodÃ£o, etc. |
| **Variedade** | Texto | Nome tÃ©cnico da semente/cultivar. |
| **Data Plantio** | Data | InÃ­cio do ciclo no campo. |
| **Densidade** | NumÃ©rico | Sementes por metro ou hectare. |

---

### ðŸ“‚ Subfractal: GestÃ£o de Dados
**Arquivo: `esquema_dados.md`**

- **Solo:** ConexÃ£o com Agente #23 (FÃ³sforo, PotÃ¡ssio, pH, V%).
- **Clima:** HistÃ³rico de chuva e temperatura por talhÃ£o.
- **Fenologia:** Escala (ex: VE, V1... R1, R8).
- **Pragas/DoenÃ§as:** NÃ­vel de infestaÃ§Ã£o e limiar de dano.

---
*Template gerido pelo Agente #07.*

