# Eventos do Fractal - 03_fractal_estradas_ramais_porteiras

## Publica
- unidade_agricola.03_fractal_estradas_ramais_porteiras.criado
- unidade_agricola.03_fractal_estradas_ramais_porteiras.atualizado
- unidade_agricola.03_fractal_estradas_ramais_porteiras.validado
- unidade_agricola.03_fractal_estradas_ramais_porteiras.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.03_fractal_estradas_ramais_porteiras.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
