# Eventos do Fractal - 02_fractal_documentos_ambientais

## Publica
- unidade_agricola.02_fractal_documentos_ambientais.criado
- unidade_agricola.02_fractal_documentos_ambientais.atualizado
- unidade_agricola.02_fractal_documentos_ambientais.validado
- unidade_agricola.02_fractal_documentos_ambientais.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.02_fractal_documentos_ambientais.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
