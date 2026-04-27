# 🏗️ Prensa Industrial Genius: Script de Instalação LEGO
# Versão: 2.0.0 (Matrioshka Standard)

param (
    [Parameter(Mandatory=$true)]
    [string]$NomeModulo,
    
    [Parameter(Mandatory=$true)]
    [string]$DiretorioPai,
    
    [Parameter(Mandatory=$false)]
    [string]$IDModulo = "M-NEW"
)

$ErrorActionPreference = "Stop"

Write-Host "🧱 Iniciando montagem LEGO do módulo: $NomeModulo..." -ForegroundColor Cyan

# 1. Caminhos
$blueprintPath = "e:\Diretorios\Diretorio_Agentes\_blueprints\modelo_modulo"
$targetPath = Join-Path $DiretorioPai "Mod_Gestao_$NomeModulo"

# 2. Validar Destino
if (Test-Path $targetPath) {
    Write-Error "❌ Erro: Bloco LEGO 'Mod_Gestao_$NomeModulo' já está ocupado."
}

# 3. Clonar Matrioshka
Write-Host "📦 Encaixando peças do Blueprint..."
Copy-Item -Path "$blueprintPath" -Destination $targetPath -Recurse -Force

# 4. Ajustar Conectores DNA
Write-Host "🧬 Sincronizando Sockets de DNA..."
$equipePath = Join-Path $targetPath "1_DNA_Processo\equipe_modular"
$dnas = Get-ChildItem -Path $equipePath -Filter "*.md"
foreach ($dna in $dnas) {
    $content = Get-Content $dna.FullName
    $newContent = $content -replace "\[ID\]", "$IDModulo" -replace "\[NOME_MOD\]", $NomeModulo
    Set-Content -Path $dna.FullName -Value $newContent
}

# 5. Registrar no Mapa
$mapaPath = "e:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos\mapa_de_modulos.md"
$link = "file:///" + $targetPath.Replace("\", "/")
Add-Content -Path $mapaPath -Value "- [ ] [$NomeModulo]($link) [PLUGGED]"

Write-Host "✅ Peça '$NomeModulo' plugada com sucesso no sistema!" -ForegroundColor Green
