$url = "https://eajbrkypndqlumrmuoag.supabase.co/rest/v1/genius_system_events"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjA5NDU5NywiZXhwIjoyMDkxNjcwNTk3fQ.2H0_i_4Zn4uufw2Fib4yo7Y1AvI5fyhFriDk0sereUQ"

$body = '{"event_type": "TEST_AGENT", "agent_id": "ea092228-1ed0-430c-8689-ba199566d220"}'
$headers = @{ "apikey" = $key; "Authorization" = "Bearer $key" }

try {
    Invoke-RestMethod -Uri $url -Method Post -Body $body -Headers $headers -ContentType "application/json"
    Write-Host "Sucesso com Agent ID!"
} catch {
    $_.Exception.Message | Write-Host
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.ReadToEnd() | Write-Host
    }
}
