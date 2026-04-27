$ErrorActionPreference = "Stop"

Write-Host "Aplicando migration via Supabase CLI..."

if (-not (Get-Command supabase -ErrorAction SilentlyContinue)) {
  throw "Supabase CLI nao encontrada. Instale a Supabase CLI ou use o SQL Editor do Supabase."
}

Push-Location "."
try {
  supabase db push
  Write-Host "Migration aplicada com sucesso."
}
finally {
  Pop-Location
}
