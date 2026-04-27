# Guia de Auditoria e Qualidade - Mod_Gestao_Unidade_Agricola

## Objetivo

Criar uma camada de auditoria para encontrar pendências, erros e inconsistências no módulo Gestão da Unidade Agrícola.

## Migration

```text
supabase/migrations/202604260009_views_auditoria_qualidade_unidade_agricola.sql
```

## Views criadas

- `vw_auditoria_unidades_incompletas`
- `vw_auditoria_unidades_sem_vinculos`
- `vw_auditoria_eventos_erros`
- `vw_auditoria_unidades_sem_identidade`
- `vw_auditoria_areas_inconsistentes`
- `vw_auditoria_importacoes_pendentes`
- `vw_auditoria_qualidade_resumo`

## Como testar

Executar:

```text
supabase/tests/TESTES_AUDITORIA_QUALIDADE_Mod_Gestao_Unidade_Agricola.sql
```

## Resultado esperado no estado atual

Como as unidades seed e `PA-IMP-0001` não receberam todos os submódulos complementares, pode haver unidades em `vw_auditoria_unidades_sem_vinculos`.

Para as unidades `PA-IMP-0002` e `PA-IMP-0003`, o esperado é:

- com proprietário;
- com responsável;
- com área produtiva;
- com eventos validados;
- sem erro de evento.

## Uso operacional

Essa camada deve ser consultada antes de:

- liberar unidade para produção;
- liberar unidade para marketplace;
- alimentar dashboards executivos;
- disparar automações;
- publicar dados no DataLake.
