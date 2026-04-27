$ErrorActionPreference = "Stop"

Write-Host "Verificando ambiente para Mod_Gestao_Unidade_Agricola..."

$supabase = Get-Command supabase -ErrorAction SilentlyContinue
$docker = Get-Command docker -ErrorAction SilentlyContinue
$psql = Get-Command psql -ErrorAction SilentlyContinue

if ($supabase) {
  Write-Host "OK: Supabase CLI encontrada em $($supabase.Source)"
} else {
  Write-Host "AVISO: Supabase CLI nao encontrada."
}

if ($docker) {
  Write-Host "OK: Docker encontrado em $($docker.Source)"
} else {
  Write-Host "AVISO: Docker nao encontrado."
}

if ($psql) {
  Write-Host "OK: psql encontrado em $($psql.Source)"
} else {
  Write-Host "AVISO: psql nao encontrado."
}

Write-Host ""
Write-Host "Arquivos esperados:"
Test-Path ".\supabase\migrations\202604260001_mod_gestao_unidade_agricola.sql"
Test-Path ".\supabase\seed\seed_unidade_agricola.sql"
Test-Path ".\supabase\tests\TESTES_IMPLANTACAO_Mod_Gestao_Unidade_Agricola.sql"
Test-Path ".\supabase\functions\unidade-agricola-api\index.ts"
Test-Path ".\supabase\functions\fractal-eventos\index.ts"
