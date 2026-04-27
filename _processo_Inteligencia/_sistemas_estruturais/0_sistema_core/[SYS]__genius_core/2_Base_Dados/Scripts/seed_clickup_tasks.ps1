# Seed ClickUp Tasks
$url = "https://eajbrkypndqlumrmuoag.supabase.co/rest/v1/clickup_tasks"
$key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjA5NDU5NywiZXhwIjoyMDkxNjcwNTk3fQ.2H0_i_4Zn4uufw2Fib4yo7Y1AvI5fyhFriDk0sereUQ"

$tasks = @(
    @{
        title = "Coleta de Amostras de Solo"
        description = "Realizar coleta em 10 pontos distintos do talhão 04."
        status = "Concluído"
        priority = "Urgente"
        start_date = "2026-04-01"
        due_date = "2026-04-05"
        assignee_id = "#P-PV"
    },
    @{
        title = "Análise de Pragas"
        description = "Inspeção visual em busca de percevejos."
        status = "Em Andamento"
        priority = "Alta"
        start_date = "2026-04-06"
        due_date = "2026-04-10"
        assignee_id = "VERA"
    },
    @{
        title = "Plantio Direto - Talhão 04"
        description = "Execução do plantio após validação."
        status = "A Fazer"
        priority = "Urgente"
        start_date = "2026-04-12"
        due_date = "2026-04-20"
        assignee_id = "Gestor Agronômico"
    }
)

$body = $tasks | ConvertTo-Json -Depth 10 -Compress
$bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
$headers = @{ "apikey" = $key; "Authorization" = "Bearer $key"; "Prefer" = "return=representation" }

try {
    Invoke-WebRequest -Uri $url -Method Post -Body $bytes -ContentType "application/json" -Headers $headers
    Write-Host "ClickUp Tasks SEED OK!"
} catch {
    Write-Host "ClickUp Tasks SEED FAIL: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.ReadToEnd() | Write-Host
    }
}
