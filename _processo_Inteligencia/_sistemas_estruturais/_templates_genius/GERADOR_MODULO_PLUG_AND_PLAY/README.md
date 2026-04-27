# GERADOR_MODULO_PLUG_AND_PLAY

Este gerador cria módulos no padrão Genius plug and play.

## Entrada esperada

Arquivo JSON com:

```json
{
  "destino": "E:/caminho/do/grupo",
  "nome_modulo": "01_Mod_Exemplo",
  "descricao_modulo": "Descrição do módulo.",
  "schema_modulo": "mod_exemplo",
  "fractais_modulo": [
    { "nome": "01_fractal_identidade", "titulo": "Identidade", "descricao": "Define identidade do módulo." }
  ],
  "submodulos": [
    {
      "nome": "01_sub_cadastro",
      "fractais": [
        { "nome": "01_fractal_dados_basicos", "titulo": "Dados básicos", "descricao": "Registra dados básicos." }
      ]
    }
  ]
}
```

## Uso

```powershell
node gerar_modulo_plug_and_play.mjs config_modulo_exemplo.json
```
