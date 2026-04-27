# Guia de Dashboards e KPIs - Mod_Gestao_Unidade_Agricola

## Objetivo

Criar views especializadas para dashboards, KPIs, agentes e auditoria do módulo Gestão da Unidade Agrícola.

## Arquivo da migration

```text
supabase/migrations/202604260003_views_dashboards_kpis_unidade_agricola.sql
```

## Views criadas

- `unidade_agricola.vw_kpis_unidade_agricola`
- `unidade_agricola.vw_dashboard_executivo_unidade_agricola`
- `unidade_agricola.vw_pendencias_unidade_agricola`
- `unidade_agricola.vw_sync_unidade_agricola`
- `unidade_agricola.vw_fractais_status_unidade_agricola`

## Como aplicar pelo Supabase Web

1. Abrir o projeto Supabase do Ecossistema Genius.
2. Ir em `SQL Editor`.
3. Criar uma nova query.
4. Colar todo o conteúdo de:

```text
202604260003_views_dashboards_kpis_unidade_agricola.sql
```

5. Clicar em `Run`.

## Como testar

Depois de aplicar a migration, executar:

```text
supabase/tests/TESTES_DASHBOARDS_KPIS_Mod_Gestao_Unidade_Agricola.sql
```

## Resultados esperados com o seed atual

- `vw_kpis_unidade_agricola`: `total_unidades = 1`, `unidades_ativas = 1`, `area_total_ha = 1250.50`
- `vw_dashboard_executivo_unidade_agricola`: `eventos_catalogados = 272`, `eventos_publicados = 1`, `status_executivo = saudavel`
- `vw_pendencias_unidade_agricola`: `0`
- `vw_fractais_status_unidade_agricola`: `68` linhas para a unidade seed
- Fractal `01_fractal_identidade_unidade`: status `validado`
