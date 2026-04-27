# Eventos do Fractal - 03_fractal_documentos_fiscais_cadastrais

## Publica
- unidade_agricola.03_fractal_documentos_fiscais_cadastrais.criado
- unidade_agricola.03_fractal_documentos_fiscais_cadastrais.atualizado
- unidade_agricola.03_fractal_documentos_fiscais_cadastrais.validado
- unidade_agricola.03_fractal_documentos_fiscais_cadastrais.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.03_fractal_documentos_fiscais_cadastrais.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
