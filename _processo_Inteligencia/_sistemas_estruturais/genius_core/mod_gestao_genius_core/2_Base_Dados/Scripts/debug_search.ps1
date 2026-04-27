# Debug Search
param($Query = "Não-Redundância", $EnvPath = "E:\Diretorios\Diretorio_Agentes\.env")
if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}
$rpcUrl = "$VITE_SUPABASE_URL/rest/v1/rpc/match_knowledge"
$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$GEMINI_API_KEY"

$payloadGemini = @{ content = @{ parts = @(@{ text = $Query }) }; taskType = "RETRIEVAL_QUERY" } | ConvertTo-Json -Compress
$bytes = [System.Text.Encoding]::UTF8.GetBytes($payloadGemini)
$res = Invoke-WebRequest -Uri $geminiUrl -Method Post -Body $bytes -ContentType "application/json"
$queryEmbedding = ($res.Content | ConvertFrom-Json).embedding.values

$payloadSB = @{ query_embedding = $queryEmbedding; match_threshold = 0.1; match_count = 5 } | ConvertTo-Json -Compress
$bytesSB = [System.Text.Encoding]::UTF8.GetBytes($payloadSB)
$headers = @{ "apikey" = $VITE_SUPABASE_ANON_KEY; "Authorization" = "Bearer $VITE_SUPABASE_ANON_KEY" }
$resSB = Invoke-WebRequest -Uri $rpcUrl -Method Post -Body $bytesSB -ContentType "application/json" -Headers $headers
$results = $resSB.Content | ConvertFrom-Json

Write-Host "Raw Results Count: $($results.Count)"
foreach ($r in $results) {
    Write-Host "Similarity: $($r.similarity)"
    Write-Host "File: $($r.file_name)"
}
