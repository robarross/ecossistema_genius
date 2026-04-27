# Contrato de Integracao - 01_fractal_areas_produtivas

## Objetivo
Registra areas produtivas vinculadas a unidade agricola e sua situacao de uso.

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
- unidade_agricola.01_fractal_areas_produtivas.criado
- unidade_agricola.01_fractal_areas_produtivas.atualizado
- unidade_agricola.01_fractal_areas_produtivas.validado

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
