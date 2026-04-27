# Eventos do Fractal - 01_fractal_documentos_fundiarios

## Publica
- unidade_agricola.01_fractal_documentos_fundiarios.criado
- unidade_agricola.01_fractal_documentos_fundiarios.atualizado
- unidade_agricola.01_fractal_documentos_fundiarios.validado
- unidade_agricola.01_fractal_documentos_fundiarios.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.01_fractal_documentos_fundiarios.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
