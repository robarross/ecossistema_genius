# Eventos do Fractal - 04_fractal_situacao_cadastral

## Publica
- unidade_agricola.04_fractal_situacao_cadastral.criado
- unidade_agricola.04_fractal_situacao_cadastral.atualizado
- unidade_agricola.04_fractal_situacao_cadastral.validado
- unidade_agricola.04_fractal_situacao_cadastral.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.04_fractal_situacao_cadastral.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
