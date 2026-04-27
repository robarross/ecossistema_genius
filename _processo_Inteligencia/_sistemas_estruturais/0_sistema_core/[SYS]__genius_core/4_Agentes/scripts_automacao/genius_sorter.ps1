# Script Blindado de Logística Genius
$configPath = "e:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_sistemas_estruturais\0_sistema_core\[SYS]__genius_core\4_Agentes\scripts_automacao\tags_logistica.json"

# Carregando configuração usando LiteralPath
$configRaw = Get-Content -LiteralPath $configPath -Raw
$config = $configRaw | ConvertFrom-Json

$landingZones = @("e:\Diretorios\Diretorio_Agentes\_ENTRADA_GERAL_GENIUS", "e:\Diretorios\Diretorio_Agentes\_DIFUSAO_CONHECIMENTO_DRAFT")

foreach ($zone in $landingZones) {
    if (-not (Test-Path -LiteralPath $zone)) { New-Item -ItemType Directory -Path $zone -Force }
    
    $files = Get-ChildItem -LiteralPath $zone -File
    foreach ($file in $files) {
        $found = $false
        foreach ($tag in $config.tags.PSObject.Properties) {
            # Verifica se o nome do arquivo começa com a Tag (ex: [SOLO])
            if ($file.Name.StartsWith($tag.Name)) {
                $destBase = Join-Path "e:\Diretorios\Diretorio_Agentes" $tag.Value
                $ext = $file.Extension.ToLower()
                
                # Roteamento por Tipo de Arquivo
                $destFolder = ""
                if ($config.regras_extensao.tabelas -contains $ext) { $destFolder = "0_IN_Entrada" }
                elseif ($config.regras_extensao.documentos -contains $ext) { $destFolder = "3_LIB_Biblioteca" }
                elseif ($config.regras_extensao.apresentacoes -contains $ext) { $destFolder = "2_OUT_Saida" }
                
                if ($destFolder -ne "") {
                    $finalPath = Join-Path $destBase $destFolder
                    if (-not (Test-Path -LiteralPath $finalPath)) { New-Item -ItemType Directory -Path $finalPath -Force }
                    
                    # Nome limpo sem a tag
                    $cleanName = $file.Name.Replace($tag.Name, "").TrimStart("_").TrimStart(" ")
                    
                    # Move usando LiteralPath para evitar erros de wildcard
                    Move-Item -LiteralPath $file.FullName -Destination (Join-Path $finalPath $cleanName) -Force
                    Write-Host "✅ [LOGISTICA] Entregue: $($file.Name) -> $($destFolder) de $($tag.Name)" -ForegroundColor Green
                    $found = $true
                    break
                }
            }
        }
        if (-not $found) {
            Write-Host "⚠️ [LOGISTICA] Pendente ou sem Rota: $($file.Name)" -ForegroundColor Yellow
        }
    }
}
