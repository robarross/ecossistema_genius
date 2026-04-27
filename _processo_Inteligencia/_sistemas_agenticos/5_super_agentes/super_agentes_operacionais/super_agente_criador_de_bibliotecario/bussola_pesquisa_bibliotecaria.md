# Bússola de Pesquisa: Localização de Ativos Genius (Agente #35)

## 🎯 1. Objetivo
Permitir a localização rápida de qualquer arquivo (Template, Modelo ou Acervo) através do cruzamento de metadados `.json` espalhados pelo ecossistema.

## ⚙️ 2. Protocolo de Varredura (Algoritmo de Busca)
Sempre que solicitado a "Pesquisar Ativos", o Agente #35 deve seguir este rito:
1.  **Parâmetro**: Identificar as `tags` ou `palavras-chave` do usuário.
2.  **Escopo**: Varrer as subpastas `0_biblioteca_setorial` em todos os módulos.
3.  **Análise de Metadados**: Abrir cada arquivo `.json` e verificar se a tag solicitada existe no campo `"tags"` ou se o termo está no `"resumo"`.
4.  **Consolidação**: Ignorar os arquivos operacionais e focar apenas no setor de Referência.

## 📊 3. Modelo de Entrega (Relatório de Busca)
O resultado deve ser entregue em uma tabela formatada:

| Nome do Arquivo | Localização (Path) | Resumo Cognitivo | Tags Identificadas |
| :--- | :--- | :--- | :--- |
| [Nome] | [Caminho Linkado] | [O que é o arquivo] | [Tags encontradas] |

---
**Versão**: 1.0.0
**Responsável**: #35 Super Agente Bibliotecário
