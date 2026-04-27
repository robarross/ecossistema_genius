# Get Top Agents by XP
$url = "https://eajbrkypndqlumrmuoag.supabase.co/rest/v1/agents?select=id,name,xp,level&order=xp.desc&limit=10"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjA5NDU5NywiZXhwIjoyMDkxNjcwNTk3fQ.2H0_i_4Zn4uufw2Fib4yo7Y1AvI5fyhFriDk0sereUQ"

$headers = @{ "apikey" = $key; "Authorization" = "Bearer $key" }

try {
    $response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
    Write-Host "`n--- 🏆 TOP 10 AGENTES POR XP ---`n"
    $response | Format-Table -AutoSize
    Write-Host "Conexão com Supabase: OK!"
} catch {
    Write-Host "Falha na conexão: $($_.Exception.Message)"
}
