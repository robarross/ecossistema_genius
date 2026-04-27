$ErrorActionPreference = "Stop"

if (-not (Get-Command supabase -ErrorAction SilentlyContinue)) {
  throw "Supabase CLI nao encontrada. Instale a Supabase CLI para fazer deploy das Edge Functions."
}

Write-Host "Fazendo deploy das Edge Functions..."
supabase functions deploy unidade-agricola-api
supabase functions deploy fractal-eventos
Write-Host "Deploy concluido."
