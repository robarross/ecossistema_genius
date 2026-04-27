# Catalogo de Eventos do Ecossistema Genius

Este catalogo define eventos padronizados para comunicacao entre modulos, plataformas e core.

## Padrao De Nome

`dominio.recurso.acao`

Exemplos:

- `core.demanda.recebida`
- `producao.lote.liberado`
- `marketplace.pedido.criado`

## Eventos Core

| Evento | Publicador | Consumidores | Descricao |
|---|---|---|---|
| core.demanda.recebida | Mod_Gestao_Genius_In | Genius_Hub, modulos destino | Nova demanda recebida no ecossistema. |
| core.fluxo.encaminhado | Mod_Gestao_Genius_Hub | Modulos destino | Hub encaminhou fluxo para modulo responsavel. |
| core.status.modulo_atualizado | Todos os modulos | Genius_Hub | Modulo atualizou seu status operacional. |
| core.dados.ingestao_solicitada | Todos os modulos | Dados_DataLake | Modulo enviou dados para armazenamento. |
| core.indicador.atualizado | Dashboards_BI | Genius_Hub, plataformas | Indicador atualizado para visualizacao. |

## Eventos Produtivos

| Evento | Publicador | Consumidores | Descricao |
|---|---|---|---|
| producao.ciclo.criado | Producao_Vegetal/Animal | DataLake, BI | Novo ciclo produtivo registrado. |
| producao.colheita.registrada | Producao_Vegetal | PosColheita | Colheita pronta para recebimento pos-colheita. |
| poscolheita.lote.classificado | PosColheita | Agroindustria, Alimentos, Marketplace | Lote classificado e rastreavel. |
| agroindustria.produto.processado | Agroindustria_Rural | Alimentos | Produto processado aguardando validacao alimentar. |
| alimentos.produto.liberado | Alimentos | Marketplace, Logistica | Produto apto para venda, consumo ou distribuicao. |

## Eventos Comerciais E Mercado

| Evento | Publicador | Consumidores | Descricao |
|---|---|---|---|
| marketplace.oferta.publicada | Marketplace_Agricola | Comercial, BI, Hub | Oferta publicada na vitrine. |
| marketplace.pedido.criado | Marketplace_Agricola | Financeira, Logistica, Vendedor | Pedido criado. |
| financeiro.pagamento.confirmado | Financeira | Marketplace, Contratos, BI | Pagamento confirmado. |
| logistica.entrega.confirmada | Logistica | Marketplace, Cliente, BI | Entrega concluida. |

## Eventos Projetos E Colaboracao

| Evento | Publicador | Consumidores | Descricao |
|---|---|---|---|
| projetos.projeto.criado | Gestao_Projetos | Workspace, Hub | Projeto formal criado. |
| workspace.tarefa.atualizada | Genius_Workspace | Projetos, Hub | Tarefa atualizada no trabalho diario. |
| cowork.reserva.confirmada | Genius_Cowork | Workspace, Projetos | Reserva presencial confirmada. |

## Eventos Geoambientais

| Evento | Publicador | Consumidores | Descricao |
|---|---|---|---|
| geo.area.atualizada | Georreferenciamento | SIG, Unidade Agricola, DataLake | Area georreferenciada atualizada. |
| ambiental.ocorrencia.registrada | Meio_Ambiente | ESG, Governanca, Hub | Ocorrencia ambiental registrada. |
| carbono.credito.gerado | Carbono_Servicos_Ambientais | Marketplace, BI, Governanca | Credito ou ativo ambiental gerado. |

## Eventos Tecnologicos

| Evento | Publicador | Consumidores | Descricao |
|---|---|---|---|
| api.sincronizacao.recebida | Integracoes_APIs | Modulos destino | Dados recebidos por integracao. |
| automacao.rotina.executada | Automacoes | Hub, DataLake | Rotina automatizada executada. |
| iot.leitura.recebida | TI_IoT_Rural | DataLake, Dashboards, modulos tecnicos | Leitura de sensor recebida. |
| seguranca.incidente.detectado | Seguranca_Informacao | Hub, Governanca, TechOps | Incidente de seguranca detectado. |