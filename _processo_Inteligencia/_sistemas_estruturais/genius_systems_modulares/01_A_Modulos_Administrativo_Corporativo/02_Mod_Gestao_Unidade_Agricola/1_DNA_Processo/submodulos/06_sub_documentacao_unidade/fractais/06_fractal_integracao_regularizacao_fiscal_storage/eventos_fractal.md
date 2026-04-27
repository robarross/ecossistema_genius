# Eventos do Fractal - 06_fractal_integracao_regularizacao_fiscal_storage

## Publica
- unidade_agricola.06_fractal_integracao_regularizacao_fiscal_storage.criado
- unidade_agricola.06_fractal_integracao_regularizacao_fiscal_storage.atualizado
- unidade_agricola.06_fractal_integracao_regularizacao_fiscal_storage.validado
- unidade_agricola.06_fractal_integracao_regularizacao_fiscal_storage.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.06_fractal_integracao_regularizacao_fiscal_storage.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
