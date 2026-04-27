# Guia de Execução Local/Dev - Mod_Gestao_Unidade_Agricola

Este guia prepara o primeiro teste do pacote executável em Supabase local ou projeto Supabase de desenvolvimento.

## Estado do ambiente atual

Neste computador, durante a preparação, não foram encontrados:

- Supabase CLI
- Docker
- psql

Por isso os scripts foram criados, mas ainda não executam a implantação real sem essas dependências.

## Ordem recomendada

1. Copiar `.env.example` para `.env` e preencher credenciais do projeto Supabase.
2. Instalar Supabase CLI, Docker e/ou psql conforme o modo escolhido.
3. Executar verificação:

```powershell
.\scripts\00_verificar_ambiente.ps1
```

4. Aplicar migration:

```powershell
.\scripts\01_aplicar_migration_supabase_cli.ps1
```

Alternativa: abrir o arquivo da migration no SQL Editor do Supabase.

5. Aplicar seed:

```powershell
$env:SUPABASE_DB_URL="postgresql://..."
.\scripts\02_aplicar_seed_psql.ps1
```

Alternativa: abrir o arquivo `supabase/seed/seed_unidade_agricola.sql` no SQL Editor.

6. Executar testes SQL:

```powershell
.\scripts\03_executar_testes_sql_psql.ps1
```

Alternativa: abrir o arquivo `supabase/tests/TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql` no SQL Editor.

7. Fazer deploy das Edge Functions:

```powershell
.\scripts\04_deploy_edge_functions.ps1
```

## Critérios de sucesso

- Schema `unidade_agricola` criado.
- 71 tabelas criadas.
- 272 eventos catalogados.
- Unidade seed `PA-SEED-0001` criada.
- Evento seed de identidade validada criado.
- Edge Functions publicadas sem erro.

## Próximo passo depois do teste dev

Conectar a planilha/formulário de cadastro ao endpoint ou diretamente ao Supabase para validar o fluxo:

cadastro -> Supabase -> evento -> dashboard -> agente/automações.
