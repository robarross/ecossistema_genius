# Eventos do Fractal - 02_fractal_funcoes_papeis_operacionais

## Publica
- unidade_agricola.02_fractal_funcoes_papeis_operacionais.criado
- unidade_agricola.02_fractal_funcoes_papeis_operacionais.atualizado
- unidade_agricola.02_fractal_funcoes_papeis_operacionais.validado
- unidade_agricola.02_fractal_funcoes_papeis_operacionais.sincronizado

## Consome
- genius_hub.registro_sincronizado
- datalake.registro_indexado
- permissoes.usuario_atualizado

## Payload minimo
```json
{
  "id_evento": "uuid",
  "nome_evento": "unidade_agricola.02_fractal_funcoes_papeis_operacionais.criado",
  "id_unidade_agricola": "text/uuid",
  "id_fractal_registro": "uuid",
  "origem": "Mod_Gestao_Unidade_Agricola",
  "status": "pendente|validado|sincronizado|erro",
  "created_at": "timestamp"
}
```
