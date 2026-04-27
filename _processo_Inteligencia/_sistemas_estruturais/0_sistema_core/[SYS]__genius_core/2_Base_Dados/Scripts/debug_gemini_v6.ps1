# Debug Gemini v6
$key = "AIzaSyCYqId9KgFZIWa9Qhe2ps6jZW6AWFLyTpM"
$url = "https://generativelanguage.googleapis.com/v1/models/text-embedding-004:embedContent"

$headers = @{
    "x-goog-api-key" = $key
}

$payload = @{
    content = @{ parts = @(@{ text = "hello" }) }
} | ConvertTo-Json -Depth 10

Write-Host "Testing v1/text-embedding-004 with header..."
try {
    $res = Invoke-RestMethod -Uri $url -Method Post -Body $payload -ContentType "application/json" -Headers $headers
    Write-Host "SUCCESS! Vector size: $($res.embedding.values.Count)"
} catch {
    Write-Host "FAIL: $($_.Exception.Message)"
}
