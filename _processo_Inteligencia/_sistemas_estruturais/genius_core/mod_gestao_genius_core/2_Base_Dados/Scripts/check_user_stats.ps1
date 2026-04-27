# Check User Stats
$url = "https://eajbrkypndqlumrmuoag.supabase.co/rest/v1/genius_user_stats?select=xp_total,level&limit=5"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjA5NDU5NywiZXhwIjoyMDkxNjcwNTk3fQ.2H0_i_4Zn4uufw2Fib4yo7Y1AvI5fyhFriDk0sereUQ"

$headers = @{ "apikey" = $key; "Authorization" = "Bearer $key" }

try {
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
    Write-Host "`n--- ESTATÍSTICAS DE USUÁRIOS (XP) ---`n"
    $response | Format-Table -AutoSize
} catch {
    Write-Host "Tabela não encontrada ou erro: $($_.Exception.Message)"
}
