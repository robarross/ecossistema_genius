# Contrato de Integracao - 04_fractal_documental_juridico

## Objetivo
Organiza documentos, certidoes, registros, contratos e evidencias juridicas da unidade.

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
- unidade_agricola.04_fractal_documental_juridico.criado
- unidade_agricola.04_fractal_documental_juridico.atualizado
- unidade_agricola.04_fractal_documental_juridico.validado

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
