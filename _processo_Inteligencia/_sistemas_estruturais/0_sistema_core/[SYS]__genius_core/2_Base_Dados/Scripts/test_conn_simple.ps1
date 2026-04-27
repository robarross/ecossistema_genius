# Simple Supabase Test
$url = "https://eajbrkypndqlumrmuoag.supabase.co/rest/v1/agents?select=*&limit=1"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjA5NDU5NywiZXhwIjoyMDkxNjcwNTk3fQ.2H0_i_4Zn4uufw2Fib4yo7Y1AvI5fyhFriDk0sereUQ"

$headers = @{ "apikey" = $key; "Authorization" = "Bearer $key" }

try {
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
    $response | ConvertTo-Json
    Write-Host "`nConexão Simples: OK!"
} catch {
    Write-Host "Falha: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.ReadToEnd() | Write-Host
    }
}
