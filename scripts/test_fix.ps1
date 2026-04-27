# 🧪 Test Script
$scanPaths = @("E:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos")
foreach ($scan in $scanPaths) {
    if (Test-Path $scan) {
        Write-Host "Scanning $scan"
        $items = Get-ChildItem -Path $scan -Recurse | Where-Object { $_.PSIsContainer -and ($_.Name -like "Mod_*") }
        if ($items) {
            $items | ForEach-Object {
                Write-Host "Found $($_.Name)"
            }
        }
    }
}
