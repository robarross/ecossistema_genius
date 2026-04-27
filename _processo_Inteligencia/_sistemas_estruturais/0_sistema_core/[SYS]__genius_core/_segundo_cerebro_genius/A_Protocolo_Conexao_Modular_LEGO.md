# 🔌 Protocolo Genius Bus: Conexão Modular e Fractal

## 1. Objetivo
Garantir que todos os sistemas (Módulos, Submódulos e Fractais) sejam independentes, comercializáveis e plugáveis através de interfaces padronizadas.

## 2. A Lei do Encaixe (Input/Output)
O fluxo de inteligência deve ser linear e hierárquico, seguindo a regra:
> **O `2_OUT_Saida` de uma unidade é o `0_IN_Entrada` da unidade imediatamente superior.**

### 📐 Mapa de Fluxo:
1.  **Fractal (Unidade Atômica)**:
    - `0_IN`: Recebe dados brutos ou inputs manuais.
    - `2_OUT`: Entrega micro-resultados processados.
2.  **Submódulo (Unidade Técnica)**:
    - `0_IN`: Consome os micro-resultados de seus Fractais.
    - `2_OUT`: Entrega relatórios técnicos e dados consolidados.
3.  **Módulo (Unidade de Negócio)**:
    - `0_IN`: Consome as entregas de seus Submódulos.
    - `2_OUT`: Entrega valor estratégico para a Plataforma e para o Core.

## 3. Padrão de Entrega (Payload)
Para garantir que qualquer Agente (Guardião, Gerente ou Diretor) entenda a entrega, os arquivos em `2_OUT` devem seguir:
- **Relatórios**: Markdown (.md) com cabeçalhos claros.
- **Dados**: JSON (.json) para integrações automatizadas.
- **Assets**: Pastas específicas para imagens, vídeos ou planilhas.

## 4. Independência de Sistema
Cada pasta deve ser auto-contida. Se um Módulo for movido para outro ecossistema, ele deve levar consigo toda a sua lógica (`1_DNA`) e sua biblioteca (`3_LIB`), precisando apenas de um novo `0_IN` para voltar a operar.

## 5. Auditoria de Plugue
O **Agente #36 (Auditor Linker)** é o responsável por verificar se as conexões entre `OUT` e `IN` estão íntegras e sem perda de dados.

---
**Status**: PROTOCOLO ATIVO
**Versão**: 1.0 - Escala Industrial
