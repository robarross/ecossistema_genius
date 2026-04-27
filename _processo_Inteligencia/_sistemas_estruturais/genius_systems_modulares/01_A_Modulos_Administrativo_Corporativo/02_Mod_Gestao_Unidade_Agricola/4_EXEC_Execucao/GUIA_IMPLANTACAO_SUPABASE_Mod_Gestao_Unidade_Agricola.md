# GUIA_IMPLANTACAO_SUPABASE_Mod_Gestao_Unidade_Agricola

## Pré-requisitos

- Projeto Supabase criado.
- Supabase CLI instalada.
- Variáveis de ambiente configuradas para Edge Functions.
- Permissões revisadas antes de ativar RLS em produção.

## Passo 1 - Revisar a migration

Arquivo:

```text
supabase/migrations/202604260001_mod_gestao_unidade_agricola.sql
```

Essa migration cria:

- schema `unidade_agricola`;
- tabela raiz `unidades_agricolas`;
- catálogo de eventos;
- log de eventos;
- 68 tabelas sugeridas para fractais;
- índices básicos;
- função `set_updated_at`.

## Passo 2 - Executar em ambiente de desenvolvimento

Via Supabase SQL Editor ou Supabase CLI:

```powershell
supabase db push
```

## Passo 3 - Aplicar seed

```sql
-- executar o conteúdo de:
supabase/seed/seed_unidade_agricola.sql
```

## Passo 4 - Validar implantação

Executar:

```sql
-- executar o conteúdo de:
supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql
```

Resultados esperados:

- schema `unidade_agricola` existente;
- tabelas criadas;
- 272 eventos catalogados;
- unidade seed criada;
- evento seed criado.

## Passo 5 - Deploy das Edge Functions

```powershell
supabase functions deploy unidade-agricola-api
supabase functions deploy fractal-eventos
```

## Passo 6 - Próxima etapa

Depois de validar o banco e as funções, conectar:

- planilha/formulário de cadastro;
- dashboard;
- agentes/automações;
- Genius Hub;
- DataLake;
- módulos consumidores.
