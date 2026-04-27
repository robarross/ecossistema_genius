# 🔧 Ferramenta de Reparo LEGO: Script de Refatoração em Massa
# Versão: 1.0.2
# Autor: CEO #CEO-01

param (
    [Parameter(Mandatory=$true)]
    [string]$ModulePath
)

$ErrorActionPreference = 'Continue'

Write-Host ('🛠️ Refatorando para LEGO: ' + $ModulePath) -ForegroundColor 'Yellow'

# 1. Definir novos sockets
$sockets = @('0_IN_Entrada', '1_DNA_Processo', '2_OUT_Saida', '3_LIB_Biblioteca\0_referencias', '3_LIB_Biblioteca\1_dia_a_dia')

foreach ($s in $sockets) {
    $p = Join-Path $ModulePath $s
    if (-not (Test-Path $p)) {
        New-Item -ItemType Directory -Path $p -Force | Out-Null
    }
}

# 2. Migrar Equipe e Processo (DNAs)
$itemsToMove = Get-ChildItem -Path $ModulePath -Directory | Where-Object { $_.Name -like '.*' -or $_.Name -like '*processo*' -or $_.Name -like 'equipe*' }

foreach ($item in $itemsToMove) {
    if ($item.Name -ne '1_DNA_Processo' -and $item.Name -ne '0_IN_Entrada' -and $item.Name -ne '2_OUT_Saida' -and $item.Name -ne '3_LIB_Biblioteca') {
        $destName = $item.Name
        $dest = Join-Path $ModulePath ('1_DNA_Processo\' + $destName)
        if (-not (Test-Path $dest)) {
            Move-Item -Path $item.FullName -Destination $dest -Force
            Write-Host ('  📦 Mapeado DNA: ' + $destName + ' -> 1_DNA_Processo')
        }
    }
}

# 3. Migrar Entrada/Saída antigas
$oldIn = Join-Path $ModulePath '1_entrada'
if (Test-Path $oldIn) {
    Copy-Item -Path ($oldIn + '\*') -Destination (Join-Path $ModulePath '0_IN_Entrada') -Recurse -Force
    Remove-Item -Path $oldIn -Recurse -Force
}

$oldOut = Join-Path $ModulePath '3_saida'
if (Test-Path $oldOut) {
    Copy-Item -Path ($oldOut + '\*') -Destination (Join-Path $ModulePath '2_OUT_Saida') -Recurse -Force
    Remove-Item -Path $oldOut -Recurse -Force
}

Write-Host '✅ Módulo refatorado com sucesso!' -ForegroundColor 'Green'
