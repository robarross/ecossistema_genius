# Contrato Frontend - Plataforma Ecossistema Genius

## Modulo

`Mod_Gestao_Unidade_Agricola`

Este frontend representa a interface operacional do modulo Gestao da Unidade Agricola. Ele deve funcionar como aplicacao independente em homologacao e tambem como modulo plug and play carregavel pela futura Plataforma Ecossistema Genius.

## Modos de execucao

### Modo standalone

O frontend roda sozinho por meio do servidor local `server.mjs`.

Entrada:

```text
index.html
```

URL local padrao:

```text
http://localhost:4173
```

Uso principal:

```text
Teste local, homologacao, validacao de views, validacao de dashboards e operacao isolada do modulo.
```

### Modo plataforma

O frontend deve poder ser carregado pela Plataforma Ecossistema Genius como uma peca do catalogo central de modulos.

Caminho sugerido na plataforma:

```text
/modulos/unidade-agricola
```

Nesse modo, a plataforma deve fornecer:

```text
usuario autenticado
perfis e permissoes
tema visual global
menu principal
contexto da organizacao/unidade
canal de eventos do Genius Hub
cliente de API padronizado
```

## Rotas

| Rota | Tela | Objetivo |
| --- | --- | --- |
| `/modulos/unidade-agricola/dashboard` | Dashboard | Visao executiva, KPIs, saude e liberacao para ecossistema. |
| `/modulos/unidade-agricola/gerenciamento` | Gerenciamento do Modulo | Governanca, contratos, manifesto, status plug and play e encaixe na Plataforma Genius. |
| `/modulos/unidade-agricola/agentes` | Agentes de IA | Agentes de validacao, auditoria, importacao e integracao do modulo. |
| `/modulos/unidade-agricola/ferramentas` | Ferramentas | Ferramentas operacionais para execucao, validacao e monitoramento. |
| `/modulos/unidade-agricola/relatorios` | Relatorios | Relatorios executivos, relacionais, auditoria e integracao. |
| `/modulos/unidade-agricola/banco-de-dados` | Banco de Dados | Schema, views, eventos e status da integracao com Supabase. |
| `/modulos/unidade-agricola/unidades` | Unidades | Lista unidades agricolas prontas, bloqueadas e liberadas. |
| `/modulos/unidade-agricola/unidades/:codigo_unidade` | Detalhe | Mostra dados relacionais, vinculos, areas e eventos por unidade. |
| `/modulos/unidade-agricola/auditoria` | Auditoria | Mostra qualidade, pendencias, bloqueios e inconsistencias. |
| `/modulos/unidade-agricola/importacoes` | Importacoes | Acompanha lotes de importacao por planilha e submodulos. |

## Menus

Menu principal do modulo:

```text
Unidade Agricola
```

Itens:

```text
Dashboard
Cadastros
Gerenciamento do Modulo
Ferramentas
Relatorios
Banco de Dados
Configuracoes
```

Abas internas do Gerenciamento do Modulo:

```text
Visao Geral
Unidades
Detalhe
Auditoria
Importacoes
```

Abas internas de Configuracoes:

```text
Configuracoes Gerais
Banco de Dados
```

Na Plataforma Ecossistema Genius, este menu deve aparecer dentro da area:

```text
03_Plataforma_Genius_AgroGestao
```

## Filtro de submodulos

O menu lateral possui um filtro de contexto para os 10 submodulos do modulo.

Local:

```text
sidebar_after_brand
```

Opcoes:

```text
Todos os submodulos
01 - Cadastro de Unidades Agricolas
02 - Proprietarios e Possuidores
03 - Responsaveis e Gestores
04 - Territorios e Areas de Producao
05 - Limites e Acessos
06 - Documentacao da Unidade
07 - Base de Ativos Estruturais
08 - Chaves e Permissoes Operacionais
09 - Status Operacional da Unidade
10 - Prestacao de Contas da Unidade
```

Nesta fase, o filtro altera o contexto ativo do frontend. Nas proximas etapas, ele deve filtrar componentes, fractais, formularios, views e eventos especificos por submodulo.

## Filtro de fractais

O menu lateral tambem possui um filtro de fractais logo abaixo do filtro de submodulos.

Regra:

```text
Se Todos os submodulos estiver selecionado, o filtro mostra todos os fractais do modulo.
Se um submodulo especifico estiver selecionado, o filtro mostra apenas os fractais daquele submodulo.
```

Quantidade atual:

```text
6 fractais por submodulo
60 fractais no total
```

Esse filtro e o primeiro ponto visual para a futura navegacao Fractal plug and play dentro de cada submodulo.

## Sidebar direito - Chat com Agentes de IA

O frontend possui uma aba lateral direita recolhivel para conversa com os Agentes de IA.

Estado inicial:

```text
retraido
```

Comportamento:

```text
Expande para o lado esquerdo.
Contrai para o lado direito.
```

Finalidade:

```text
Conversar com agentes de IA usando o contexto ativo do modulo, submodulo, fractal e unidade selecionada.
```

Nesta fase, o chat registra mensagens localmente no frontend. Nas proximas etapas, ele devera ser conectado ao Genius Hub, aos agentes reais do modulo e aos eventos operacionais.

## Views consumidas

O frontend consome dados do schema:

```text
unidade_agricola
```

Views principais:

```text
vw_dashboard_executivo_unidade_agricola
vw_unidades_agricolas_prontas_ecossistema
vw_matriz_consumo_modulos_unidade_agricola
vw_unidade_relacional_resumo
vw_unidade_proprietarios
vw_unidade_responsaveis
vw_unidade_areas_produtivas
vw_unidade_eventos_timeline
vw_auditoria_qualidade_resumo
vw_unidades_bloqueadas_ecossistema
vw_importacao_planilha_unidades_status
vw_importacao_submodulos_base_status
vw_resumo_liberacao_ecossistema
```

## Eventos publicados

Eventos previstos para a evolucao do frontend:

```text
unidade_agricola.frontend.modulo.aberto
unidade_agricola.frontend.dashboard.visualizado
unidade_agricola.frontend.unidade.selecionada
unidade_agricola.frontend.dados.atualizados
unidade_agricola.frontend.erro_consulta
```

Esses eventos deverao ser enviados ao `Mod_Gestao_Genius_Hub` quando o canal de eventos da plataforma estiver disponivel.

## Eventos consumidos

Eventos que a Plataforma Genius ou outros modulos poderao emitir para este frontend:

```text
Plataforma_Ecossistema_Genius.usuario.autenticado
Plataforma_Ecossistema_Genius.permissoes.carregadas
Mod_Gestao_Genius_Hub.modulo.status_atualizado
Mod_Gestao_Dashboards_BI.dashboard.atualizado
Mod_Gestao_Integracoes_APIs.schema.disponibilizado
```

## Permissoes

Permissoes funcionais previstas:

```text
unidade_agricola.dashboard.visualizar
unidade_agricola.gerenciamento.visualizar
unidade_agricola.agentes.visualizar
unidade_agricola.ferramentas.visualizar
unidade_agricola.relatorios.visualizar
unidade_agricola.banco_dados.visualizar
unidade_agricola.unidades.visualizar
unidade_agricola.unidades.detalhar
unidade_agricola.auditoria.visualizar
unidade_agricola.importacoes.visualizar
```

Perfis iniciais:

```text
admin_ecossistema
gestor_modulo
operador_modulo
auditor_modulo
leitor_modulo
agente_ia_autorizado
```

## Dependencias

Dependencias tecnicas:

```text
HTML5
CSS3
JavaScript
Supabase REST API
schema unidade_agricola exposto na Data API
anon key apenas em homologacao/frontend publico
```

Dependencias do ecossistema:

```text
Mod_Gestao_Genius_Hub
Mod_Gestao_Dados_DataLake
Mod_Gestao_Dashboards_BI
Mod_Gestao_Integracoes_APIs
Mod_Gestao_Seguranca_Informacao
```

## Dashboards

Dashboards expostos pelo frontend:

```text
dashboard_executivo
dashboard_liberacao_ecossistema
dashboard_auditoria_qualidade
```

Cada dashboard deve continuar tendo sua propria view no Supabase e seu proprio contrato de dados.

## Pontos de encaixe na Plataforma Genius

Este frontend deve ser plugado nos seguintes pontos da futura plataforma:

```text
catalogo_modulos
menu_lateral_plataforma
hub_eventos
dashboard_bi_global
datalake_trusted
integracoes_apis
seguranca_perfis
tema_visual_global
roteador_plataforma
```

## Regra plug and play

O modulo deve continuar obedecendo a esta regra:

```text
Roda sozinho quando necessario.
Encaixa na Plataforma Genius quando chamado.
Publica eventos compreensiveis pelo ecossistema.
Consome permissoes, tema, usuario e contexto quando estiver plugado.
Mantem submodulos e fractais independentes, complementares e escalaveis.
```

## Proximos passos

1. Criar componentes frontend para cada submodulo.
2. Criar microcomponentes frontend para cada fractal.
3. Criar um registro central de modulos para a futura Plataforma Ecossistema Genius.
4. Criar camada de autenticacao/permissao real para substituir os grants de homologacao.
5. Criar canal de eventos frontend -> Genius Hub.
