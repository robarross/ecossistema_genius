# Eventos do Fractal - 08_fractal_inteligencia_automacoes

## Publica
- unidade_agricola.08_fractal_inteligencia_automacoes.criado
- unidade_agricola.08_fractal_inteligencia_automacoes.atualizado
- unidade_agricola.08_fractal_inteligencia_automacoes.validado
- unidade_agricola.08_fractal_inteligencia_automacoes.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.08_fractal_inteligencia_automacoes.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
