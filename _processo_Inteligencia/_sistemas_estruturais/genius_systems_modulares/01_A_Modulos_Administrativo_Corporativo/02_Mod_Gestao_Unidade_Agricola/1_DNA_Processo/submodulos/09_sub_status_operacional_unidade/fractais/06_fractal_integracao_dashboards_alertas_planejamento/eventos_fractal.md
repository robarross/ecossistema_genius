# Eventos do Fractal - 06_fractal_integracao_dashboards_alertas_planejamento

## Publica
- unidade_agricola.06_fractal_integracao_dashboards_alertas_planejamento.criado
- unidade_agricola.06_fractal_integracao_dashboards_alertas_planejamento.atualizado
- unidade_agricola.06_fractal_integracao_dashboards_alertas_planejamento.validado
- unidade_agricola.06_fractal_integracao_dashboards_alertas_planejamento.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.06_fractal_integracao_dashboards_alertas_planejamento.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
