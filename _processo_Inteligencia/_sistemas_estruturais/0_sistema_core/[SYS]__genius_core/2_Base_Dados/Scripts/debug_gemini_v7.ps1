# Debug Gemini v7
$key = "AIzaSyCYqId9KgFZIWa9Qhe2ps6jZW6AWFLyTpM"
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$key"

$body = '{"content":{"parts":[{"text":"hello"}]}}'
$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)

Write-Host "Testing with Invoke-WebRequest and byte encoding..."
try {
    $res = Invoke-WebRequest -Uri $url -Method Post -Body $bodyBytes -ContentType "application/json"
    Write-Host "SUCCESS!"
    $res.Content | Write-Host
} catch {
    Write-Host "FAIL: $($_.Exception.Message)"
    $_.Exception.Response | Out-String | Write-Host
}
