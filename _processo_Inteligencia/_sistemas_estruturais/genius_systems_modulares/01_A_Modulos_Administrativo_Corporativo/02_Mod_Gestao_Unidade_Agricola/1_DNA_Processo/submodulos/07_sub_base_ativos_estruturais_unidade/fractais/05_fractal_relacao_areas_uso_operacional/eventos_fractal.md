# Eventos do Fractal - 05_fractal_relacao_areas_uso_operacional

## Publica
- unidade_agricola.05_fractal_relacao_areas_uso_operacional.criado
- unidade_agricola.05_fractal_relacao_areas_uso_operacional.atualizado
- unidade_agricola.05_fractal_relacao_areas_uso_operacional.validado
- unidade_agricola.05_fractal_relacao_areas_uso_operacional.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.05_fractal_relacao_areas_uso_operacional.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
