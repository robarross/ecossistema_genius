# Dicionario de Dados do Ecossistema Genius

Este dicionario define entidades compartilhadas entre modulos e plataformas. Ele deve orientar APIs, DataLake, dashboards e integracoes.

## Entidades Core

### Usuario
Representa pessoa com acesso ao ecossistema.
Campos sugeridos: `id_usuario`, `nome`, `email`, `perfil`, `permissoes`, `status`, `modulos_autorizados`.

### Organizacao
Representa empresa, fazenda, cooperativa, instituicao, cliente ou parceiro.
Campos sugeridos: `id_organizacao`, `nome`, `tipo`, `documento`, `contatos`, `status`.

### Unidade Agricola
Base territorial e operacional da producao rural.
Campos sugeridos: `id_unidade`, `nome`, `localizacao`, `responsavel`, `status`, `areas_vinculadas`.

### Area Talhao Gleba
Representa subdivisao produtiva, ambiental ou territorial.
Campos sugeridos: `id_area`, `id_unidade`, `tipo_area`, `geometria`, `hectares`, `status`.

### Documento
Arquivo ou registro documental usado pelos modulos.
Campos sugeridos: `id_documento`, `tipo`, `origem`, `modulo_origem`, `data`, `versao`, `status`, `url_arquivo`.

### Evento
Registro de comunicacao entre modulos.
Campos sugeridos: `id_evento`, `nome_evento`, `origem`, `destino`, `payload`, `data_hora`, `status`.

## Entidades Produtivas

### Cultura
Representa cultura agricola vinculada a uma safra ou ciclo.
Campos sugeridos: `id_cultura`, `nome`, `variedade`, `ciclo`, `id_area`, `safra`.

### Rebanho Lote Animal
Representa grupo de animais ou animal individual rastreavel.
Campos sugeridos: `id_lote_animal`, `especie`, `categoria`, `quantidade`, `identificacao`, `status`.

### Lote Produto
Representa lote colhido, processado ou pronto para venda.
Campos sugeridos: `id_lote`, `origem`, `produto`, `quantidade`, `qualidade`, `validade`, `status_liberacao`.

### Produto
Produto agropecuario, agroindustrial ou alimentar.
Campos sugeridos: `id_produto`, `nome`, `categoria`, `descricao`, `unidade_medida`, `ficha_tecnica`, `status_comercial`.

## Entidades Comerciais

### Cliente Prospect
Pessoa ou organizacao com relacao comercial.
Campos sugeridos: `id_cliente`, `nome`, `tipo`, `contato`, `origem`, `status_relacionamento`.

### Oferta Marketplace
Produto ou servico publicado para venda.
Campos sugeridos: `id_oferta`, `id_produto`, `preco`, `estoque`, `status`, `vendedor`, `condicoes`.

### Pedido
Pedido comercial gerado no marketplace ou comercial.
Campos sugeridos: `id_pedido`, `cliente`, `itens`, `valor`, `status_pagamento`, `status_entrega`.

### Pagamento
Registro financeiro associado a pedido, contrato ou obrigacao.
Campos sugeridos: `id_pagamento`, `origem`, `valor`, `data`, `status`, `metodo`, `comprovante`.

## Entidades Operacionais

### Projeto
Iniciativa formal gerenciada por escopo, prazo, recursos e entregas.
Campos sugeridos: `id_projeto`, `nome`, `objetivo`, `status`, `responsavel`, `inicio`, `fim`, `orcamento`.

### Tarefa
Atividade operacional vinculada a workspace, projeto ou modulo.
Campos sugeridos: `id_tarefa`, `titulo`, `responsavel`, `status`, `prioridade`, `prazo`, `id_projeto`.

### Ativo Patrimonial
Bem, equipamento, ferramenta, maquina ou estrutura controlada.
Campos sugeridos: `id_ativo`, `tipo`, `descricao`, `localizacao`, `responsavel`, `status`, `valor`.

### Ordem Servico
Solicitacao operacional para manutencao, transporte, consultoria ou execucao.
Campos sugeridos: `id_ordem`, `tipo`, `origem`, `responsavel`, `status`, `prazo`, `evidencias`.

## Entidades Geoambientais

### Camada Geografica
Camada espacial usada por SIG, georreferenciamento e analises.
Campos sugeridos: `id_camada`, `nome`, `tipo`, `fonte`, `data_referencia`, `precisao`, `geometria`.

### Licenca Autorizacao
Registro legal, ambiental, fiscal, fundiario ou operacional.
Campos sugeridos: `id_licenca`, `tipo`, `orgao`, `validade`, `condicionantes`, `status`.

### Indicador
Medida usada em dashboards e acompanhamento.
Campos sugeridos: `id_indicador`, `nome`, `formula`, `fonte`, `periodicidade`, `responsavel`, `valor`.

## Padroes Gerais

Todos os registros devem conter, quando aplicavel:

- `id`
- `data_criacao`
- `data_atualizacao`
- `modulo_origem`
- `usuario_responsavel`
- `status`
- `versao`
- `rastreabilidade`