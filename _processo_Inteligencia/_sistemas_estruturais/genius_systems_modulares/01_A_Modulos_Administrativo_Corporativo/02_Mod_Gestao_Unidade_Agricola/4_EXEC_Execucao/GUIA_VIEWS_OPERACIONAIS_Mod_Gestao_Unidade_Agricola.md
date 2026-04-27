# Guia de Views Operacionais - Mod_Gestao_Unidade_Agricola

## Objetivo

Criar views para facilitar dashboards, agentes, consultas e validações do módulo Gestão da Unidade Agrícola.

## Arquivo da migration

```text
supabase/migrations/202604260002_views_operacionais_unidade_agricola.sql
```

## Views criadas

- `unidade_agricola.vw_unidades_agricolas_resumo`
- `unidade_agricola.vw_eventos_fractais_resumo`
- `unidade_agricola.vw_status_modulo_unidade_agricola`
- `unidade_agricola.vw_fractais_catalogo_operacional`

## Como aplicar pelo Supabase Web

1. Abrir o projeto Supabase do Ecossistema Genius.
2. Ir em `SQL Editor`.
3. Criar uma nova query.
4. Colar todo o conteúdo de:

```text
202604260002_views_operacionais_unidade_agricola.sql
```

5. Clicar em `Run`.

## Como testar

Depois de aplicar a migration das views, executar:

```text
supabase/tests/TESTES_VIEWS_OPERACIONAIS_Mod_Gestao_Unidade_Agricola.sql
```

## Resultados esperados com o seed atual

- `vw_unidades_agricolas_resumo`: pelo menos `1`
- `vw_eventos_fractais_resumo`: `272`
- `vw_status_modulo_unidade_agricola`: `total_unidades = 1`, `eventos_catalogados = 272`, `eventos_publicados = 1`
- `vw_fractais_catalogo_operacional`: `68`
- Unidade `PA-SEED-0001` aparecendo com `total_eventos = 1`
