# Debug Gemini v5
$key = "AIzaSyCYqId9KgFZIWa9Qhe2ps6jZW6AWFLyTpM"
$url = "https://generativelanguage.googleapis.com/v1/models/embedding-001:embedContent?key=$key"

$payload = @{
    content = @{ parts = @(@{ text = "hello" }) }
} | ConvertTo-Json -Depth 10

Write-Host "Testing v1/embedding-001..."
try {
    $res = Invoke-RestMethod -Uri $url -Method Post -Body $payload -ContentType "application/json"
    Write-Host "SUCCESS! Vector size: $($res.embedding.values.Count)"
} catch {
    Write-Host "FAIL: $($_.Exception.Message)"
}
