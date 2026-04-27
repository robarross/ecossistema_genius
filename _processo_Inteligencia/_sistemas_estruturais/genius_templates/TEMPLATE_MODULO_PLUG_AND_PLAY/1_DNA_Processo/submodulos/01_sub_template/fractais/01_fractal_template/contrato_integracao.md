# Contrato de Integração - {{NOME_FRACTAL}}

## Objetivo
{{DESCRICAO_FRACTAL}}

## Entradas
- id_entidade_base
- id_registro_origem
- dados_origem
- usuario_responsavel
- data_evento

## Saídas
- registro_validado
- status_processamento
- evento_publicado
- payload_integracao

## Eventos publicados
- {{EVENTO_BASE}}.criado
- {{EVENTO_BASE}}.atualizado
- {{EVENTO_BASE}}.validado
- {{EVENTO_BASE}}.sincronizado

## Eventos consumidos
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- usuario.permissao_atualizada
