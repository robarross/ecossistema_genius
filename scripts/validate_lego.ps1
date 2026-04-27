# Genius LEGO Validator v1.1.0
$ErrorActionPreference = "Continue"
$modulesFound = 0
$modulesValid = 0
$totalErrors = 0

Write-Host "=== GENIUS LEGO VALIDATOR v1.1.0 (Industrial) ==="

$scanPaths = @(
    "E:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos",
    "E:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_super_agentes_genius"
)

$mandatorySockets = @(
    "0_IN_Entrada",
    "1_DNA_Processo",
    "2_OUT_Saida",
    "3_LIB_Biblioteca"
)

foreach ($scanPath in $scanPaths) {
    if (-not (Test-Path $scanPath)) { continue }

    $items = Get-ChildItem -Path $scanPath -Recurse | Where-Object { $_.PSIsContainer -and ($_.Name -like "Mod_*" -or $_.Name -like "sub_*") }

    foreach ($item in $items) {
        $modulesFound++
        $modulePath = $item.FullName
        $moduleErrors = @()

        foreach ($socket in $mandatorySockets) {
            $socketPath = Join-Path $modulePath $socket
            if (-not (Test-Path $socketPath)) {
                $moduleErrors += "Missing socket: $socket"
            }
        }

        $dnaDir = Join-Path $modulePath "1_DNA_Processo\equipe_modular"
        if (Test-Path $dnaDir) {
            $dnaFiles = Get-ChildItem -Path $dnaDir -File
            if (-not $dnaFiles) {
                $moduleErrors += "Socket 1 (DNA) is empty."
            }
        } else {
             $moduleErrors += "Socket 1 DNA directory missing."
        }

        $relName = $item.FullName.Replace("E:\Diretorios\Diretorio_Agentes\", "")
        if ($moduleErrors.Count -eq 0) {
            $modulesValid++
            Write-Host "[SUCCESS] Compliance: $relName"
        } else {
            $totalErrors += $moduleErrors.Count
            Write-Host "[FAIL] Irregularity: $relName"
            foreach ($err in $moduleErrors) {
                Write-Host "   - $err"
            }
        }
    }
}

Write-Host "--- Summary ---"
Write-Host "Modules Analyzed: $modulesFound"
Write-Host "In Compliance: $modulesValid"
Write-Host "Errors Found: $totalErrors"

if ($totalErrors -gt 0) {
    Write-Host "STATUS: INDUSTRIAL FAIL."
    exit 1
} else {
    Write-Host "STATUS: LEGO COMPLIANCE APPROVED."
    exit 0
}
