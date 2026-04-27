# 🧠 Genius Brain Sync v1.0.8
param ([string]$EnvPath = "E:\Diretorios\Diretorio_Agentes\.env")
if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}
if (-not $VITE_SUPABASE_URL -or -not $GEMINI_API_KEY) { Write-Host "[ERROR] Missing credentials." -ForegroundColor Red; exit 1 }

$supabaseUrl = "$VITE_SUPABASE_URL/rest/v1/knowledge_chunks"
$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$GEMINI_API_KEY"
$scanPaths = @(
    "E:\Diretorios\Diretorio_Agentes\_segundo_cerebro_genius", 
    "E:\Diretorios\Diretorio_Agentes\0_biblioteca_ecossistema_central",
    "E:\Diretorios\Diretorio_Agentes\_processo_Inteligencia"
)

Write-Host "Starting Cognitive Sync (RAG) v1.0.8..." -ForegroundColor Cyan

foreach ($path in $scanPaths) {
    if (-not (Test-Path $path)) { continue }
    Get-ChildItem -Path $path -Filter "*.md" -Recurse | ForEach-Object {
        $file = $_
        Write-Host "Processing: $($file.Name)" -ForegroundColor Gray
        $content = Get-Content $file.FullName -Raw
        
        # Split into smaller chunks (max 2000 chars)
        for ($i = 0; $i -lt $content.Length; $i += 2000) {
            $len = [Math]::Min(2000, $content.Length - $i)
            $chunkText = $content.Substring($i, $len).Trim()
            if ([string]::IsNullOrWhitespace($chunkText)) { continue }

            # Gemini Payload
            $jsonText = $chunkText -replace '\\', '\\\\' -replace '"', '\"' -replace "\n", '\n' -replace "\r", '\r'
            $payloadGemini = '{"content":{"parts":[{"text":"' + $jsonText + '"}]},"taskType":"RETRIEVAL_DOCUMENT"}'
            $bodyBytesGemini = [System.Text.Encoding]::UTF8.GetBytes($payloadGemini)
            
            try {
                $response = Invoke-WebRequest -Uri $geminiUrl -Method Post -Body $bodyBytesGemini -ContentType "application/json"
                $data = $response.Content | ConvertFrom-Json
                $embedding = $data.embedding.values

                # Supabase Payload
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
            }
        }
    }
}
Write-Host "Cognitive Sync Completed!" -ForegroundColor Cyan
