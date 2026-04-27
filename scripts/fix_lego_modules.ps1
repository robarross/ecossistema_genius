# Genius LEGO Fixer v1.1.0
$blueprintPath = "E:\Diretorios\Diretorio_Agentes\_blueprints\modelo_modulo"
$scanPaths = @(
    "E:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos",
    "E:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_super_agentes_genius"
)

Write-Host "Starting Industrial Regularization..."

foreach ($scan in $scanPaths) {
    if (Test-Path $scan) {
        $items = Get-ChildItem -Path $scan -Recurse | Where-Object { $_.PSIsContainer -and ($_.Name -like "Mod_*" -or $_.Name -like "sub_*") }
        if ($items) {
            foreach ($item in $items) {
                $modulePath = $item.FullName
                $moduleName = $item.Name -replace "Mod_Gestao_", "" -replace "Mod_", "" -replace "sub_", ""
                Write-Host "Analyzing: $($item.Name)"

                # 1. Sockets
                $null = New-Item -Path (Join-Path $modulePath "0_IN_Entrada") -ItemType Directory -Force
                $null = New-Item -Path (Join-Path $modulePath "1_DNA_Processo") -ItemType Directory -Force
                $null = New-Item -Path (Join-Path $modulePath "2_OUT_Saida") -ItemType Directory -Force
                $null = New-Item -Path (Join-Path $modulePath "3_LIB_Biblioteca") -ItemType Directory -Force

                # 2. DNA
                $dnaEquipePath = Join-Path $modulePath "1_DNA_Processo\equipe_modular"
                $null = New-Item -Path $dnaEquipePath -ItemType Directory -Force
                
                $dnaFiles = Get-ChildItem -Path $dnaEquipePath -File
                if (-not $dnaFiles) {
                    Write-Host "   Seeding DNA templates..."
                    $blueprintDnaPath = Join-Path $blueprintPath "1_DNA_Processo\equipe_modular"
                    if (Test-Path $blueprintDnaPath) {
                        Copy-Item -Path "$blueprintDnaPath\*" -Destination $dnaEquipePath -Force
                        $newDnas = Get-ChildItem -Path $dnaEquipePath -Filter "*.md"
                        if ($newDnas) {
                            foreach ($dna in $newDnas) {
                                $content = Get-Content $dna.FullName
                                $newContent = $content -replace "\[ID\]", "M-AUTO" -replace "\[NOME_MOD\]", $moduleName
                                Set-Content -Path $dna.FullName -Value $newContent
                            }
                        }
                    }
                }
                
                # 3. Submodulos
                $null = New-Item -Path (Join-Path $modulePath "1_DNA_Processo\submodulos") -ItemType Directory -Force
            }
        }
    }
}

Write-Host "Operation Completed."
