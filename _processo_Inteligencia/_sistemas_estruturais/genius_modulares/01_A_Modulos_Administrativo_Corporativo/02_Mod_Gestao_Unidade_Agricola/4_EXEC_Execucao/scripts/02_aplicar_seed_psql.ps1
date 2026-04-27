$ErrorActionPreference = "Stop"

if (-not $env:SUPABASE_DB_URL) {
  throw "Defina a variavel SUPABASE_DB_URL antes de executar este script."
}

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
  throw "psql nao encontrado. Instale PostgreSQL client ou aplique o seed pelo SQL Editor do Supabase."
}

Write-Host "Aplicando seed no Supabase..."
psql $env:SUPABASE_DB_URL -f ".\supabase\seed\seed_unidade_agricola.sql"
Write-Host "Seed aplicado."
