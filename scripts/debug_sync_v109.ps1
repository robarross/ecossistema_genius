# 🧠 Genius Brain Sync v1.0.9
param ([string]$EnvPath = "E:\Diretorios\Diretorio_Agentes\.env")
if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}
$supabaseUrl = "$VITE_SUPABASE_URL/rest/v1/knowledge_chunks"
$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$GEMINI_API_KEY"

Write-Host "Starting Cognitive Sync (RAG) v1.0.9..." -ForegroundColor Cyan

$file = Get-Item "E:\Diretorios\Diretorio_Agentes\_segundo_cerebro_genius\A_Protocolo_Governanca_EPS.md"
$chunkText = "Test content for industrial sync"

# Gemini
$jsonText = $chunkText -replace '\\', '\\\\' -replace '"', '\"' -replace "\n", '\n' -replace "\r", '\r'
$payloadGemini = '{"content":{"parts":[{"text":"' + $jsonText + '"}]},"taskType":"RETRIEVAL_DOCUMENT"}'
$bodyBytesGemini = [System.Text.Encoding]::UTF8.GetBytes($payloadGemini)

try {
    $response = Invoke-WebRequest -Uri $geminiUrl -Method Post -Body $bodyBytesGemini -ContentType "application/json"
    $data = $response.Content | ConvertFrom-Json
    $embedding = $data.embedding.values
    Write-Host "   [DEBUG] Gemini OK. Vector size: $($embedding.Count)" -ForegroundColor Gray

    # Supabase
    $payloadSupabase = @{
        file_name = $file.Name; file_path = $file.FullName; content = $chunkText; embedding = $embedding;
        metadata = @{ size = $chunkText.Length; last_sync = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }
    } | ConvertTo-Json -Depth 10 -Compress
    $bodyBytesSupabase = [System.Text.Encoding]::UTF8.GetBytes($payloadSupabase)

    $headers = @{ "apikey" = $VITE_SUPABASE_ANON_KEY; "Authorization" = "Bearer $VITE_SUPABASE_ANON_KEY" }
    Invoke-WebRequest -Uri $supabaseUrl -Method Post -Body $bodyBytesSupabase -ContentType "application/json" -Headers $headers | Out-Null
    Write-Host "   [OK] Chunk synced." -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host "   [DETAIL] $($reader.ReadToEnd())" -ForegroundColor Gray
    }
}
