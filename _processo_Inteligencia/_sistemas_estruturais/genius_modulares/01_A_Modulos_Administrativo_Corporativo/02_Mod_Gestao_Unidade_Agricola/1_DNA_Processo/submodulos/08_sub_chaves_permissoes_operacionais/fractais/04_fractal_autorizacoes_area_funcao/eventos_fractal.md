# Eventos do Fractal - 04_fractal_autorizacoes_area_funcao

## Publica
- unidade_agricola.04_fractal_autorizacoes_area_funcao.criado
- unidade_agricola.04_fractal_autorizacoes_area_funcao.atualizado
- unidade_agricola.04_fractal_autorizacoes_area_funcao.validado
- unidade_agricola.04_fractal_autorizacoes_area_funcao.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.04_fractal_autorizacoes_area_funcao.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
