# Contrato de Integracao - 05_fractal_historico_ocupacao_uso

## Objetivo
Mantem historico de culturas, atividades, rotacoes, pausas e alteracoes de uso.

## Entradas
- id_unidade_agricola
- id_registro_origem
- dados_origem
- usuario_responsavel
- data_evento

## Saidas
- registro_validado
- status_processamento
- evento_publicado
- payload_integracao

## Eventos publicados
- unidade_agricola.05_fractal_historico_ocupacao_uso.criado
- unidade_agricola.05_fractal_historico_ocupacao_uso.atualizado
- unidade_agricola.05_fractal_historico_ocupacao_uso.validado

## Eventos consumidos
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- usuario.permissao_atualizada

## Integracoes obrigatorias
- Genius Hub
- DataLake
- Integracoes APIs
- Dashboards BI

## Regra plug and play
O fractal deve funcionar de forma independente dentro do seu submodulo, mas publicar eventos e dados padronizados para permitir integracao com outros fractais, submodulos e modulos.
