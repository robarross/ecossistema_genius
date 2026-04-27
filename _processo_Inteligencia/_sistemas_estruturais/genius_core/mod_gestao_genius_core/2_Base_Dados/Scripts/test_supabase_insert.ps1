# Test Supabase
$url = "https://eajbrkypndqlumrmuoag.supabase.co/rest/v1/knowledge_chunks"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjA5NDU5NywiZXhwIjoyMDkxNjcwNTk3fQ.2H0_i_4Zn4uufw2Fib4yo7Y1AvI5fyhFriDk0sereUQ"

$embedding = @(0) * 768 # Create vector of 768 zeros
$body = @{
    file_name = "test.md"
    file_path = "test"
    content = "test content"
    embedding = $embedding
} | ConvertTo-Json -Depth 10 -Compress

$bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{ "apikey" = $key; "Authorization" = "Bearer $key" }

try {
    Invoke-WebRequest -Uri $url -Method Post -Body $bytes -ContentType "application/json" -Headers $headers
    Write-Host "Supabase INSERT OK!"
} catch {
    Write-Host "Supabase INSERT FAIL: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.ReadToEnd() | Write-Host
    }
}
