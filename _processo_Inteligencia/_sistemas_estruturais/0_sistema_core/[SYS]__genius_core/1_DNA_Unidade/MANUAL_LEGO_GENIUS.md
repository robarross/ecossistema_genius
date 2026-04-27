# 🧱 Manual LEGO Genius: Arquitetura Plug & Play Fractal

## 1. O Princípio da Matrioshka
O Ecossistema Genius é construído em camadas concêntricas. Cada nível superior contém e orquestra o nível inferior, mas todos compartilham a mesma anatomia de conexão.

| Nível | Escopo | Peça LEGO |
| :--- | :--- | :--- |
| **Lvl 5 (Macro)** | Ecossistema | A Caixa de LEGO completa |
| **Lvl 4 (Sistema)** | Domínio (ex: Produtivo) | Uma Placa de base temática |
| **Lvl 3 (Módulo)** | Negócio (ex: Unidade Agrícola) | Um Bloco de construção funcional |
| **Lvl 2 (Submódulo)**| Técnica (ex: Manejo de Solo) | Um Componente especializado |
| **Lvl 1 (Agente)** | Inteligência (DNA/Skill) | O Pino de conexão inteligente |
| **Lvl 0 (Ferramenta)**| Ação (Script/Tool) | O Detalhe técnico (Micro-LEGO) |

## 2. O Encaixe Universal (Os 5 Sockets)
Para que qualquer peça seja "Plug & Play", ela deve obrigatoriamente possuir os seguintes conectores físicos e lógicos:

### 🔌 Socket 0: IN (Entrada)
- **Função**: Recepção de estímulos e dados brutos.
- **Formato**: Pasta `0_IN_Entrada` e APIs de recepção.

### 🧠 Socket 1: DNA (Processo)
- **Função**: Onde reside a inteligência e a regra de negócio.
- **Formato**: Pasta `1_DNA_Processo` contendo o DNA do agente e suas Skills.

### 📦 Socket 2: OUT (Saída)
- **Função**: Entrega de valor, arquivos processados e interfaces.
- **Formato**: Pasta `2_OUT_Saida` e dashboards HTML.

### 📚 Socket 3: LIB (Biblioteca)
- **Função**: Memória fractal (Referências vs Dia a Dia).
- **Formato**: Pasta `3_LIB_Biblioteca`.

### ⚡ Socket 4: BUS (Telemetria)
- **Função**: Conexão com o Genius Bus para reporte de eventos.
- **Formato**: Log em tempo real via Supabase.

## 3. Regras de Montagem
1.  **Independência**: Uma peça deve funcionar sozinha se os Sockets forem alimentados corretamente.
2.  **Transparência**: O estado de cada Socket deve ser visível via Genius Bus.
3.  **Recursividade**: Um `Socket 2 (OUT)` de um submódulo pluga-se no `Socket 0 (IN)` do próximo submódulo ou do módulo pai.

---
**Autor**: Genius Systems #04
**Versão**: 2.0.0 (Industrial)
