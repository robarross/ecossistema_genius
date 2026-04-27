# Debug RAG
param($EnvPath = "E:\Diretorios\Diretorio_Agentes\.env")
if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}

$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent?key=$GEMINI_API_KEY"
$payloadGemini = @{ model = "models/text-embedding-004"; content = @{ parts = @(@{ text = "Teste de embedding" }) } } | ConvertTo-Json

Write-Host "Testing Gemini..."
try {
    $res = Invoke-RestMethod -Uri $geminiUrl -Method Post -Body $payloadGemini -ContentType "application/json"
    Write-Host "Gemini OK. Vector size: $($res.embedding.values.Count)"
} catch {
    Write-Host "Gemini FAIL: $($_.Exception.Message)"
    $_.Exception.Response | Out-String | Write-Host
}

Write-Host "Testing Supabase Table..."
$supabaseUrl = "$VITE_SUPABASE_URL/rest/v1/knowledge_chunks?select=id&limit=1"
$headers = @{ "apikey" = $VITE_SUPABASE_ANON_KEY; "Authorization" = "Bearer $VITE_SUPABASE_ANON_KEY" }
try {
    $res = Invoke-RestMethod -Uri $supabaseUrl -Method Get -Headers $headers
    Write-Host "Supabase OK (Table Found)."
} catch {
    Write-Host "Supabase FAIL: $($_.Exception.Message)"
    $_.Exception.Response | Out-String | Write-Host
}
