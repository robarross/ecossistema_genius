# Debug RAG v2
param($EnvPath = "E:\Diretorios\Diretorio_Agentes\.env")
if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}

$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/embedding-001:embedContent?key=$GEMINI_API_KEY"
$payloadGemini = @{ content = @{ parts = @(@{ text = "Teste" }) } } | ConvertTo-Json

Write-Host "Testing Gemini (embedding-001)..."
try {
    $res = Invoke-RestMethod -Uri $geminiUrl -Method Post -Body $payloadGemini -ContentType "application/json"
    Write-Host "Gemini OK. Vector size: $($res.embedding.values.Count)"
} catch {
    Write-Host "Gemini FAIL: $($_.Exception.Message)"
}
