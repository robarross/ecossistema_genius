# Sync Test
param($file = "E:\Diretorios\Diretorio_Agentes\_segundo_cerebro_genius\A_Protocolo_Governanca_EPS.md")
. "E:\Diretorios\Diretorio_Agentes\.env"
if (Test-Path "E:\Diretorios\Diretorio_Agentes\.env") {
    Get-Content "E:\Diretorios\Diretorio_Agentes\.env" | ForEach-Object { if ($_ -match "(.+)=(.+)") { Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim() -Scope Global } }
}

$geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$GEMINI_API_KEY"
$content = Get-Content $file -Raw
$chunk = $content.Substring(0, [Math]::Min(1000, $content.Length))

$payload = @{ content = @{ parts = @(@{ text = $chunk }) } } | ConvertTo-Json -Depth 10
$bytes = [System.Text.Encoding]::UTF8.GetBytes($payload)

Write-Host "Testing Gemini with chunk..."
try {
    $res = Invoke-WebRequest -Uri $geminiUrl -Method Post -Body $bytes -ContentType "application/json"
    Write-Host "Gemini OK!"
} catch {
    Write-Host "Gemini FAIL: $($_.Exception.Message)"
    $_.Exception.Response | Out-String | Write-Host
}
