# Eventos do Fractal - 05_fractal_status_risco_pendencia

## Publica
- unidade_agricola.05_fractal_status_risco_pendencia.criado
- unidade_agricola.05_fractal_status_risco_pendencia.atualizado
- unidade_agricola.05_fractal_status_risco_pendencia.validado
- unidade_agricola.05_fractal_status_risco_pendencia.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.05_fractal_status_risco_pendencia.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
