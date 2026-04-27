# 🔍 Genius Brain Query v1.0.2
param ([Parameter(Mandatory=$true)][string]$Query, [string]$EnvPath = "E:\Diretorios\Diretorio_Agentes\.env")

if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}

if (-not $VITE_SUPABASE_URL -or -not $GEMINI_API_KEY) { Write-Host "[ERROR] Missing credentials." -ForegroundColor Red; exit 1 }

$rpcUrl = "$VITE_SUPABASE_URL/rest/v1/rpc/match_knowledge"
$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$GEMINI_API_KEY"

Write-Host "Searching semantic for: '$Query'..." -ForegroundColor Cyan

$payloadGemini = @{ 
    content = @{ parts = @(@{ text = $Query }) }
    taskType = "RETRIEVAL_QUERY"
} | ConvertTo-Json -Depth 10 -Compress
$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($payloadGemini)

try {
    $response = Invoke-WebRequest -Uri $geminiUrl -Method Post -Body $bodyBytes -ContentType "application/json"
    $data = $response.Content | ConvertFrom-Json
    $queryEmbedding = $data.embedding.values

    $payloadSupabase = @{ query_embedding = $queryEmbedding; match_threshold = 0.3; match_count = 3 } | ConvertTo-Json -Depth 10 -Compress
    $sbBytes = [System.Text.Encoding]::UTF8.GetBytes($payloadSupabase)

    $headers = @{ "apikey" = $VITE_SUPABASE_ANON_KEY; "Authorization" = "Bearer $VITE_SUPABASE_ANON_KEY" }
    $res = Invoke-WebRequest -Uri $rpcUrl -Method Post -Body $sbBytes -ContentType "application/json" -Headers $headers
    $results = $res.Content | ConvertFrom-Json

    if ($results.Count -eq 0) {
        Write-Host "No relevant information found." -ForegroundColor Yellow
    } else {
        foreach ($res in $results) {
            Write-Host "`n--- Result (Similarity: $($res.similarity.ToString("P2"))) ---" -ForegroundColor Green
            Write-Host "Source: $($res.file_name)" -ForegroundColor Gray
            Write-Host "Content: $($res.content)"
        }
    }
} catch {
    Write-Host "[ERROR] Search failed: $($_.Exception.Message)" -ForegroundColor Red
}
