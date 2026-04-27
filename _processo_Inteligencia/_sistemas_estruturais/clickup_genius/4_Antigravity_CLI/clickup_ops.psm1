# ClickUp Genius - Antigravity Operational CLI
# Este script permite que o Antigravity (IA) gerencie o ecossistema ClickUp via terminal.

$SUPABASE_URL = "https://eajbrkypndqlumrmuoag.supabase.co"
$SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjA5NDU5NywiZXhwIjoyMDkxNjcwNTk3fQ.2H0_i_4Zn4uufw2Fib4yo7Y1AvI5fyhFriDk0sereUQ"

function Get-Headers {
    return @{
        "apikey" = $SUPABASE_KEY
        "Authorization" = "Bearer $SUPABASE_KEY"
        "Content-Type" = "application/json"
        "Prefer" = "return=representation"
    }
}

function List-Workspaces {
    $url = "$SUPABASE_URL/rest/v1/clickup_workspaces?select=*"
    Invoke-RestMethod -Uri $url -Headers (Get-Headers) -Method Get
}

function Create-Task {
    param (
        [string]$Title,
        [string]$Description = "",
        [string]$Status = "A Fazer",
        [string]$Priority = "Normal",
        [string]$ListId = $null
    )
    $body = @{
        title = $Title
        description = $Description
        status = $Status
        priority = $Priority
        list_id = $ListId
    } | ConvertTo-Json
    
    $url = "$SUPABASE_URL/rest/v1/clickup_tasks"
    Invoke-RestMethod -Uri $url -Headers (Get-Headers) -Method Post -Body $body
}

function Delete-Entity {
    param (
        [string]$Table,
        [string]$Id
    )
    $url = "$SUPABASE_URL/rest/v1/$Table?id=eq.$Id"
    Invoke-RestMethod -Uri $url -Headers (Get-Headers) -Method Delete
}

# Export functions for easy use
Export-ModuleMember -Function *
