# Eventos do Fractal - 04_fractal_potencial_produtivo

## Publica
- unidade_agricola.04_fractal_potencial_produtivo.criado
- unidade_agricola.04_fractal_potencial_produtivo.atualizado
- unidade_agricola.04_fractal_potencial_produtivo.validado
- unidade_agricola.04_fractal_potencial_produtivo.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.04_fractal_potencial_produtivo.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
