# Eventos do Fractal - 06_fractal_integracao_ecossistema

## Publica
- unidade_agricola.06_fractal_integracao_ecossistema.criado
- unidade_agricola.06_fractal_integracao_ecossistema.atualizado
- unidade_agricola.06_fractal_integracao_ecossistema.validado
- unidade_agricola.06_fractal_integracao_ecossistema.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.06_fractal_integracao_ecossistema.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
