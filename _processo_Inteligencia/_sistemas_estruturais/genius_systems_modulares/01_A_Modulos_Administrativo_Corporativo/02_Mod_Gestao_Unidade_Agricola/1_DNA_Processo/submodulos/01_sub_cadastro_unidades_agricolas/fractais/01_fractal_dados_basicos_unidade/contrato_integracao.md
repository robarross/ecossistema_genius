# Contrato de Integracao - 01_fractal_dados_basicos_unidade

## Objetivo
Registra identificadores, nome, codigo, tipo, categoria e dados essenciais da unidade agricola.

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
- unidade_agricola.01_fractal_dados_basicos_unidade.criado
- unidade_agricola.01_fractal_dados_basicos_unidade.atualizado
- unidade_agricola.01_fractal_dados_basicos_unidade.validado

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
