# Eventos do Fractal - 06_fractal_integracao_datalake_mapas_modulos

## Publica
- unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.criado
- unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.atualizado
- unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.validado
- unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.06_fractal_integracao_datalake_mapas_modulos.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
