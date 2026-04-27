# Eventos do Fractal - 04_fractal_validades_vencimentos

## Publica
- unidade_agricola.04_fractal_validades_vencimentos.criado
- unidade_agricola.04_fractal_validades_vencimentos.atualizado
- unidade_agricola.04_fractal_validades_vencimentos.validado
- unidade_agricola.04_fractal_validades_vencimentos.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.04_fractal_validades_vencimentos.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
