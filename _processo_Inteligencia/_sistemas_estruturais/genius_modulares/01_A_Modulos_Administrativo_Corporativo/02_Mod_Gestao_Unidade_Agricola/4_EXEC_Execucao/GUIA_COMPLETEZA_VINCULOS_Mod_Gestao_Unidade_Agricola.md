# Guia de Completeza de Vínculos - Mod_Gestao_Unidade_Agricola

## Objetivo

Completar vínculos mínimos das unidades que ainda não possuem:

- proprietário/possuidor;
- responsável/gestor;
- área produtiva.

## Migration

```text
supabase/migrations/202604260010_rotina_completeza_vinculos_unidade_agricola.sql
```

## Como completar todas as unidades pendentes

```sql
select *
from unidade_agricola.completar_vinculos_basicos_unidades_pendentes();
```

## Como completar uma unidade específica

```sql
select *
from unidade_agricola.completar_vinculos_basicos_unidade(
  'PA-SEED-0001',
  'Titular Fazenda Piloto Genius',
  'Responsável Fazenda Piloto Genius',
  'PA-SEED-0001-AREA-01',
  'Área principal Fazenda Piloto Genius',
  100.00
);
```

## Validação

Depois de executar a completeza, rode:

```text
supabase/tests/TESTES_COMPLETEZA_VINCULOS_Mod_Gestao_Unidade_Agricola.sql
```

## Resultado esperado

- `vw_auditoria_unidades_sem_vinculos` deve ficar vazia.
- `vw_auditoria_qualidade_resumo.status_qualidade` deve ficar `saudavel`, desde que não existam outras pendências.
- Eventos com origem `completeza_vinculos` devem aparecer no log.
