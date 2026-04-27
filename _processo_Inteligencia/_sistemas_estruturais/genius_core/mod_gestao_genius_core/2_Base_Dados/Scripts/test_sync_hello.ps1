# 🧠 Genius Brain Sync DEBUG
param ([string]$EnvPath = "E:\Diretorios\Diretorio_Agentes\.env")
if (Test-Path $EnvPath) {
    Get-Content $EnvPath | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}
$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$GEMINI_API_KEY"
Write-Host "Testing sync with 'hello' only..."
$payload = @{ content = @{ parts = @(@{ text = "hello" }) } } | ConvertTo-Json -Compress
$bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)
try {
    $res = Invoke-WebRequest -Uri $geminiUrl -Method Post -Body $bytes -ContentType "application/json"
    Write-Host "Gemini OK!"
} catch {
    Write-Host "Gemini FAIL: $($_.Exception.Message)"
}
