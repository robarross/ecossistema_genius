# Eventos do Fractal - {{NOME_FRACTAL}}

## Publica
- {{EVENTO_BASE}}.criado
- {{EVENTO_BASE}}.atualizado
- {{EVENTO_BASE}}.validado
- {{EVENTO_BASE}}.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload mínimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "{{EVENTO_BASE}}.criado",
  "id_entidade_base": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "{{NOME_MODULO}}",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
