$ErrorActionPreference = "Stop"

if (-not $env:SUPABASE_DB_URL) {
  throw "Defina a variavel SUPABASE_DB_URL antes de executar este script."
}

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
  throw "psql nao encontrado. Use o SQL Editor do Supabase para executar o arquivo de testes."
}

Write-Host "Executando testes SQL de implantacao..."
psql $env:SUPABASE_DB_URL -f ".\supabase\tests\TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql"
Write-Host "Testes SQL executados."
