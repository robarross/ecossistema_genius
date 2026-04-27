# 🔧 Genius LEGO Folder Fixer v1.0.9
$scanPath = "E:\Diretorios\Diretorio_Agentes\_processo_Inteligencia"
$items = Get-ChildItem -Path $scanPath -Recurse | Where-Object { $_.PSIsContainer -and ($_.Name -like "Mod_*" -or $_.Name -like "sub_*") }

$items | ForEach-Object {
    $p = $_.FullName
    Write-Host "📁 Fixing folders for: $($_.Name)"
    $null = New-Item -Path "$p\0_IN_Entrada" -ItemType Directory -Force
    $null = New-Item -Path "$p\1_DNA_Processo\equipe_modular" -ItemType Directory -Force
    $null = New-Item -Path "$p\1_DNA_Processo\submodulos" -ItemType Directory -Force
    $null = New-Item -Path "$p\2_OUT_Saida" -ItemType Directory -Force
    $null = New-Item -Path "$p\3_LIB_Biblioteca" -ItemType Directory -Force
}
Write-Host "✅ Folders fixed."
