# Eventos do Fractal - 05_fractal_operacional_status

## Publica
- unidade_agricola.05_fractal_operacional_status.criado
- unidade_agricola.05_fractal_operacional_status.atualizado
- unidade_agricola.05_fractal_operacional_status.validado
- unidade_agricola.05_fractal_operacional_status.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.05_fractal_operacional_status.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
