param (
    [Parameter(Mandatory=$true)]
    [string]$Nome,

    [Parameter(Mandatory=$true)]
    [ValidateSet('A', 'B', 'C', 'D', 'E', 'F')]
    [string]$Categoria,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Modulo', 'Submodulo')]
    [string]$Tipo = 'Modulo'
)

# 1. Configurações de Caminhos
$root = "e:\Diretorios\Diretorio_Agentes"
$intelPath = Join-Path $root "_processo_Inteligencia"
$structPath = Join-Path $intelPath "_sistemas_estruturais"
$agenticPath = Join-Path $intelPath "_sistemas_agenticos"
$blueprintPath = "$structPath\0_sistema_core\[SYS]__genius_core\1_DNA_Unidade\Blueprints"
$modRoot = "$structPath\genius_systems_modulares"

# Mapeamento de Pastas de Categoria
$catFolders = @{
    'A' = "A_Modulos_Administrativo_Corporativo"
    'B' = "B_Modulos_Territorial_Ambiental"
    'C' = "C_Modulos_Infraestrutura_Operacao"
    'D' = "D_Modulos_Tecnologico_Inteligente"
    'E' = "E_Modulos_Produtivo"
    'F' = "F_Modulos_Negocio_Expansao"
}

$destCategory = $catFolders[$Categoria]
$cleanName = $Nome -replace ' ', '_'
$targetFolderName = "Mod_$($cleanName)"
$destPath = Join-Path $modRoot "$destCategory\$targetFolderName"

Write-Host "🚀 Iniciando Fábrica Genius para: $targetFolderName em Categoria $Categoria" -ForegroundColor Cyan

# 2. Clonagem do Blueprint
$sourceBlueprint = if ($Tipo -eq 'Modulo') { Join-Path $blueprintPath "modelo_modulo" } else { Join-Path $blueprintPath "modelo_submodulo" }

if (-not (Test-Path $destPath)) {
    Copy-Item -Path $sourceBlueprint -Destination $destPath -Recurse -Force
    Write-Host "✅ Matriz Ultra-LEGO clonada com sucesso." -ForegroundColor Green
} else {
    Write-Host "⚠️ O módulo $targetFolderName já existe!" -ForegroundColor Yellow
    return
}

# 3. Batismo Industrial (Renomear DNAs)
Write-Host "🏷️ Batizando Agentes da Equipe Modular..." -ForegroundColor Cyan
$equipePath = Join-Path $destPath "1_DNA_Processo\equipe_modular"
if (-not (Test-Path $equipePath)) { $equipePath = Join-Path $destPath "1_DNA_Processo\equipe_submodular" }

Get-ChildItem -LiteralPath $equipePath -Filter "*.md" | ForEach-Object {
    $newName = "$($_.BaseName)_$($cleanName.ToLower()).md"
    Rename-Item -LiteralPath $_.FullName -NewName $newName -Force
}

# 4. Atualização do Mapa de Módulos
$mapPath = "$modRoot\mapa_de_modulos.md"
$newLine = "- [ ] [$Nome](file:///$($destPath -replace '\\', '/'))"
$mapContent = Get-Content $mapPath
# Tenta inserir na seção correta
$sectionHeader = "## " + ($Categoria) + "."
$newMapContent = @()
$inserted = $false

foreach ($line in $mapContent) {
    $newMapContent += $line
    if ($line -match $sectionHeader -and -not $inserted) {
        $newMapContent += $newLine
        $inserted = $true
    }
}
$newMapContent | Set-Content $mapPath -Force
Write-Host "🗺️ Registrado no Mapa de Módulos." -ForegroundColor Green

# 5. Atualização da Central de Guardiões
$centralPath = "$agenticPath\6_AGENTES_MODULARES\CENTRAL_DE_GUARDIOES.md"
$guardiaoFile = Get-ChildItem -LiteralPath $equipePath -Filter "dna_guardiao_*.md" | Select-Object -First 1
if ($guardiaoFile) {
    $guardiaoLine = "| **$destCategory** | $cleanName | [Abrir DNA Batizado](file:///$($guardiaoFile.FullName -replace '\\', '/')) |"
    $guardiaoLine | Add-Content $centralPath
    Write-Host "🛡️ Guardião registrado na Central." -ForegroundColor Green
}

Write-Host "🏁 Sistema '$Nome' criado e integrado com sucesso!" -ForegroundColor Cyan
