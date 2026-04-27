# Eventos do Fractal - 03_fractal_documentos_titulares

## Publica
- unidade_agricola.03_fractal_documentos_titulares.criado
- unidade_agricola.03_fractal_documentos_titulares.atualizado
- unidade_agricola.03_fractal_documentos_titulares.validado
- unidade_agricola.03_fractal_documentos_titulares.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.03_fractal_documentos_titulares.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
