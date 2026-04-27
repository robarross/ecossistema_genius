# Eventos do Fractal - 04_fractal_documental_juridico

## Publica
- unidade_agricola.04_fractal_documental_juridico.criado
- unidade_agricola.04_fractal_documental_juridico.atualizado
- unidade_agricola.04_fractal_documental_juridico.validado
- unidade_agricola.04_fractal_documental_juridico.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.04_fractal_documental_juridico.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
