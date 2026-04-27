# Eventos do Fractal - 03_fractal_indicadores_conformidade

## Publica
- unidade_agricola.03_fractal_indicadores_conformidade.criado
- unidade_agricola.03_fractal_indicadores_conformidade.atualizado
- unidade_agricola.03_fractal_indicadores_conformidade.validado
- unidade_agricola.03_fractal_indicadores_conformidade.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.03_fractal_indicadores_conformidade.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
