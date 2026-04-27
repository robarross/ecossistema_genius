# Eventos do Fractal - 06_fractal_integracao_producao_geo_precisao

## Publica
- unidade_agricola.06_fractal_integracao_producao_geo_precisao.criado
- unidade_agricola.06_fractal_integracao_producao_geo_precisao.atualizado
- unidade_agricola.06_fractal_integracao_producao_geo_precisao.validado
- unidade_agricola.06_fractal_integracao_producao_geo_precisao.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.06_fractal_integracao_producao_geo_precisao.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
