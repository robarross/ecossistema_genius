# Contrato de Integracao - 06_fractal_integracao_datalake_mapas_modulos

## Objetivo
Conecta o cadastro da unidade ao DataLake, mapas, Hub, dashboards e modulos dependentes.

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
- unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.criado
- unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.atualizado
- unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.validado

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
