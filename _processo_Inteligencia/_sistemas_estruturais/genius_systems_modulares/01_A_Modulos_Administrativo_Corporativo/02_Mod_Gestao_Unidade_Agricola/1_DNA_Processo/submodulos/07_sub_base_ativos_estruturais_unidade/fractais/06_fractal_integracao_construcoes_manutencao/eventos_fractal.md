# Eventos do Fractal - 06_fractal_integracao_construcoes_manutencao

## Publica
- unidade_agricola.06_fractal_integracao_construcoes_manutencao.criado
- unidade_agricola.06_fractal_integracao_construcoes_manutencao.atualizado
- unidade_agricola.06_fractal_integracao_construcoes_manutencao.validado
- unidade_agricola.06_fractal_integracao_construcoes_manutencao.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.06_fractal_integracao_construcoes_manutencao.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
