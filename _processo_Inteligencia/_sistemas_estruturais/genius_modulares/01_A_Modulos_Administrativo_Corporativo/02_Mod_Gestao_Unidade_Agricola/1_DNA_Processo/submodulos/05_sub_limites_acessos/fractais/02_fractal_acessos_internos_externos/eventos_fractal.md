# Eventos do Fractal - 02_fractal_acessos_internos_externos

## Publica
- unidade_agricola.02_fractal_acessos_internos_externos.criado
- unidade_agricola.02_fractal_acessos_internos_externos.atualizado
- unidade_agricola.02_fractal_acessos_internos_externos.validado
- unidade_agricola.02_fractal_acessos_internos_externos.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.02_fractal_acessos_internos_externos.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
