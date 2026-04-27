# Eventos do Fractal - 02_fractal_benfeitorias_instalacoes_fixas

## Publica
- unidade_agricola.02_fractal_benfeitorias_instalacoes_fixas.criado
- unidade_agricola.02_fractal_benfeitorias_instalacoes_fixas.atualizado
- unidade_agricola.02_fractal_benfeitorias_instalacoes_fixas.validado
- unidade_agricola.02_fractal_benfeitorias_instalacoes_fixas.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.02_fractal_benfeitorias_instalacoes_fixas.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
