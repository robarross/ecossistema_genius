# Eventos do Fractal - 04_fractal_responsabilidade_administrativa

## Publica
- unidade_agricola.04_fractal_responsabilidade_administrativa.criado
- unidade_agricola.04_fractal_responsabilidade_administrativa.atualizado
- unidade_agricola.04_fractal_responsabilidade_administrativa.validado
- unidade_agricola.04_fractal_responsabilidade_administrativa.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.04_fractal_responsabilidade_administrativa.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
