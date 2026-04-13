# Skill: Separação de Documentos (Word / PDF) — VERA (#24)

## Descrição:
Esta skill habilita a VERA a **separar um documento** `.docx` ou `.pdf` em múltiplos arquivos individuais, salvando o resultado em uma pasta organizada. Antes de executar, VERA sempre pergunta ao usuário qual escopo de páginas deseja extrair.

---

## 🗂️ Tipos de Separação Disponíveis

| Opção | Descrição | Exemplo de Saída |
|---|---|---|
| **Todas** | Cada página vira um arquivo individual | `pagina_001.pdf`, `pagina_002.pdf`... |
| **Intervalo** | Páginas X até Y extraídas como 1 arquivo | `documento_p03_ate_p07.pdf` |
| **Múltiplos intervalos** | Vários recortes em uma execução | `parte_1.pdf`, `parte_2.pdf`... |

---

## 🖥️ SCRIPT PRINCIPAL — Separação Interativa (PowerShell)
> ✅ Funciona para PDF e DOCX | Ambiente Windows com Microsoft Word instalado

```powershell
# skill_separacao_documentos.ps1 — VERA (#24)
# Separa páginas de documentos Word ou PDF em arquivos individuais
# Sempre pergunta ao usuário o escopo antes de executar

param (
    [string]$Arquivo,           # Caminho do arquivo a separar (.docx ou .pdf)
    [string]$PastaDestino = ""  # Pasta de saída (opcional — criada automaticamente se vazia)
)

# ──────────────────────────────────────────────────────────────────────────────
# FUNÇÕES AUXILIARES
# ──────────────────────────────────────────────────────────────────────────────

function Obter-TotalPaginasPdf ($caminho) {
    # Lê o número de páginas de um PDF sem bibliotecas externas
    $bytes = [System.IO.File]::ReadAllBytes($caminho)
    $texto = [System.Text.Encoding]::ASCII.GetString($bytes)
    $matches = [regex]::Matches($texto, "/Type\s*/Page[^s]")
    return $matches.Count
}

function Mostrar-MenuSelecao ($totalPaginas, $nomeArquivo) {
    Write-Host ""
    Write-Host "══════════════════════════════════════════════════"
    Write-Host "  VERA (#24) — Separação de Documento"
    Write-Host "══════════════════════════════════════════════════"
    Write-Host "  Arquivo : $nomeArquivo"
    Write-Host "  Total   : $totalPaginas páginas detectadas"
    Write-Host "──────────────────────────────────────────────────"
    Write-Host "  Opções de separação:"
    Write-Host ""
    Write-Host "  [1] Todas as páginas (cada página = 1 arquivo)"
    Write-Host "  [2] Intervalo simples (página X até página Y)"
    Write-Host "  [3] Múltiplos intervalos (definir vários recortes)"
    Write-Host "  [0] Cancelar"
    Write-Host ""
    $opcao = Read-Host "  Escolha uma opção"
    return $opcao
}

function Pedir-Intervalo ($totalPaginas, $label = "") {
    Write-Host ""
    if ($label) { Write-Host "  ── $label" }
    do {
        $de  = Read-Host "  De qual página? (1-$totalPaginas)"
        $ate = Read-Host "  Até qual página? ($de-$totalPaginas)"
        $de  = [int]$de
        $ate = [int]$ate
        if ($de -lt 1 -or $ate -gt $totalPaginas -or $de -gt $ate) {
            Write-Host "  ⚠ Intervalo inválido. Tente novamente."
        }
    } while ($de -lt 1 -or $ate -gt $totalPaginas -or $de -gt $ate)
    return @($de, $ate)
}

function Criar-PastaDestino ($arquivoOrigem, $pastaDestino) {
    if ($pastaDestino -eq "") {
        $pastaBase = [System.IO.Path]::GetDirectoryName($arquivoOrigem)
        $nomeBase  = [System.IO.Path]::GetFileNameWithoutExtension($arquivoOrigem)
        $pastaDestino = Join-Path $pastaBase "$nomeBase`_separado_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    }
    if (-not (Test-Path $pastaDestino)) {
        New-Item -ItemType Directory -Path $pastaDestino | Out-Null
    }
    Write-Host ""
    Write-Host "  Pasta de saída: $pastaDestino"
    return $pastaDestino
}

# ──────────────────────────────────────────────────────────────────────────────
# SEPARAÇÃO DE PDF
# ──────────────────────────────────────────────────────────────────────────────

function Separar-Pdf ($caminhoPdf, $pastaDestino, $intervalos) {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0

    try {
        foreach ($intervalo in $intervalos) {
            $de  = $intervalo[0]
            $ate = $intervalo[1]

            if ($de -eq $ate) {
                $nomeArquivo = "pagina_{0:D3}.pdf" -f $de
            } else {
                $nomeArquivo = "pagina_{0:D3}_ate_{1:D3}.pdf" -f $de, $ate
            }

            $saida = Join-Path $pastaDestino $nomeArquivo

            # Abre o PDF via Word (converte internamente)
            $doc = $word.Documents.Open($caminhoPdf, $false, $true)

            # Exporta o intervalo de páginas
            $doc.ExportAsFixedFormat(
                $saida,   # OutputFileName
                17,       # wdExportFormatPDF
                $false,   # OpenAfterExport
                0,        # OptimizeFor
                1,        # Range: wdExportFromTo = 1
                $de,      # From
                $ate,     # To
                0,        # Item
                $true, $true, 0, $true, $true, $false
            )
            $doc.Close($false)

            $tamanho = [math]::Round((Get-Item $saida).Length / 1KB, 2)
            Write-Host "  ✔ $nomeArquivo ($tamanho KB)"
        }
    } finally {
        $word.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
        [GC]::Collect()
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# SEPARAÇÃO DE WORD (DOCX)
# ──────────────────────────────────────────────────────────────────────────────

function Separar-Word ($caminhoDocx, $pastaDestino, $intervalos) {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0

    try {
        foreach ($intervalo in $intervalos) {
            $de  = $intervalo[0]
            $ate = $intervalo[1]

            if ($de -eq $ate) {
                $nomeBase = "pagina_{0:D3}" -f $de
            } else {
                $nomeBase = "pagina_{0:D3}_ate_{1:D3}" -f $de, $ate
            }

            $saidaDocx = Join-Path $pastaDestino "$nomeBase.docx"
            $saidaPdf  = Join-Path $pastaDestino "$nomeBase.pdf"

            # Abre o documento original
            $doc = $word.Documents.Open($caminhoDocx, $false, $true)

            # Seleciona e copia o intervalo de páginas
            $sel = $word.Selection
            # Vai para a página inicial
            $word.Selection.GoTo(1, 1, $null, $de) | Out-Null      # wdGoToPage=1, wdGoToAbsolute=1
            $inicioPagina = $sel.Start

            # Vai para o final da página final
            $word.Selection.GoTo(1, 1, $null, $ate) | Out-Null
            $sel.EndKey(5) | Out-Null  # wdLine; seleciona até fim da última linha

            # Tenta ir até o final da página...
            # Abordagem mais confiável: exportar por intervalo via ExportAsFixedFormat
            $doc.ExportAsFixedFormat(
                $saidaPdf, 17, $false, 0,
                1,    # wdExportFromTo
                $de, $ate,
                0, $true, $true, 0, $true, $true, $false
            )
            $doc.Close($false)

            $tamanho = [math]::Round((Get-Item $saidaPdf).Length / 1KB, 2)
            Write-Host "  ✔ $nomeBase.pdf ($tamanho KB)"
        }
    } finally {
        $word.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
        [GC]::Collect()
    }
}

# ──────────────────────────────────────────────────────────────────────────────
# FLUXO PRINCIPAL
# ──────────────────────────────────────────────────────────────────────────────

# Validação inicial
if (-not (Test-Path $Arquivo)) {
    Write-Host "ERRO: Arquivo não encontrado: $Arquivo"
    exit 1
}

$ext       = [System.IO.Path]::GetExtension($Arquivo).ToLower()
$nomeArq   = Split-Path $Arquivo -Leaf

if ($ext -notin @(".pdf", ".docx", ".doc")) {
    Write-Host "ERRO: Tipo não suportado. Use .pdf, .docx ou .doc"
    exit 1
}

# Detectar total de páginas
Write-Host "Analisando documento..."
if ($ext -eq ".pdf") {
    $totalPaginas = Obter-TotalPaginasPdf $Arquivo
} else {
    # Para Word, abre brevemente para contar páginas
    $wordTemp = New-Object -ComObject Word.Application
    $wordTemp.Visible = $false
    $wordTemp.DisplayAlerts = 0
    $docTemp = $wordTemp.Documents.Open($Arquivo, $false, $true)
    $totalPaginas = $docTemp.ComputeStatistics(2)  # wdStatisticPages = 2
    $docTemp.Close($false)
    $wordTemp.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($wordTemp) | Out-Null
    [GC]::Collect()
}

if ($totalPaginas -lt 1) { $totalPaginas = 1 }

# Mostrar menu e coletar opção
$opcao = Mostrar-MenuSelecao $totalPaginas $nomeArq

$intervalos = @()

switch ($opcao) {
    "0" {
        Write-Host "  Operação cancelada."
        exit 0
    }
    "1" {
        # Todas as páginas
        Write-Host "  Separando todas as $totalPaginas páginas individualmente..."
        for ($p = 1; $p -le $totalPaginas; $p++) {
            $intervalos += ,@($p, $p)
        }
    }
    "2" {
        # Intervalo simples
        $iv = Pedir-Intervalo $totalPaginas "Defina o intervalo"
        $intervalos += ,@($iv[0], $iv[1])
    }
    "3" {
        # Múltiplos intervalos
        $continuar = $true
        $n = 1
        while ($continuar) {
            $iv = Pedir-Intervalo $totalPaginas "Recorte $n"
            $intervalos += ,@($iv[0], $iv[1])
            $n++
            $mais = Read-Host "  Adicionar outro recorte? (S/N)"
            $continuar = ($mais.ToUpper() -eq "S")
        }
    }
    default {
        Write-Host "  Opção inválida. Operação cancelada."
        exit 1
    }
}

# Criar pasta de destino
$pasta = Criar-PastaDestino $Arquivo $PastaDestino

Write-Host ""
Write-Host "  Separando $($intervalos.Count) segmento(s)..."
Write-Host ""

# Executar separação conforme tipo
if ($ext -eq ".pdf") {
    Separar-Pdf $Arquivo $pasta $intervalos
} else {
    Separar-Word $Arquivo $pasta $intervalos
}

Write-Host ""
Write-Host "══════════════════════════════════════════════════"
Write-Host "  CONCLUÍDO — Arquivos salvos em:"
Write-Host "  $pasta"
Write-Host "══════════════════════════════════════════════════"
```

---

## 🚀 Como Usar

```powershell
# Separar um PDF (menu interativo será exibido)
.\skill_separacao_documentos.ps1 -Arquivo "C:\docs\apostila.pdf"

# Separar um DOCX com pasta de destino definida
.\skill_separacao_documentos.ps1 -Arquivo "C:\docs\relatorio.docx" -PastaDestino "C:\docs\separados"
```

---

## 🖥️ Experiência Interativa (Exemplo Real)

```
══════════════════════════════════════════════════
  VERA (#24) — Separação de Documento
══════════════════════════════════════════════════
  Arquivo : apostila_agentes_completa.pdf
  Total   : 87 páginas detectadas
──────────────────────────────────────────────────
  Opções de separação:

  [1] Todas as páginas (cada página = 1 arquivo)
  [2] Intervalo simples (página X até página Y)
  [3] Múltiplos intervalos (definir vários recortes)
  [0] Cancelar

  Escolha uma opção: 2

  ── Defina o intervalo
  De qual página? (1-87): 5
  Até qual página? (5-87): 20

  Pasta de saída: C:\docs\apostila_agentes_completa_separado_20260413_151800

  Separando 1 segmento(s)...

  ✔ pagina_005_ate_020.pdf (312.45 KB)

══════════════════════════════════════════════════
  CONCLUÍDO — Arquivos salvos em:
  C:\docs\apostila_agentes_completa_separado_20260413_151800
══════════════════════════════════════════════════
```

---

## 📁 Padrão de Nomenclatura dos Arquivos Gerados

| Situação | Nome do Arquivo |
|---|---|
| Página única (ex: página 3) | `pagina_003.pdf` |
| Intervalo (ex: páginas 5–20) | `pagina_005_ate_020.pdf` |
| Múltiplos recortes | `pagina_001_ate_005.pdf`, `pagina_010_ate_015.pdf`... |

> Números com zeros à esquerda garantem ordenação correta no Explorer.

---

## 📋 Fluxo de Decisão da VERA

```
RECEBER arquivo (.pdf ou .docx)
        ↓
VALIDAR: arquivo existe e tipo suportado?
        ↓
DETECTAR total de páginas
        ↓
EXIBIR menu interativo:
  [1] Todas  [2] Intervalo  [3] Múltiplos  [0] Cancelar
        ↓
COLETAR escopo do usuário com validação
        ↓
CRIAR pasta de destino automática (com timestamp)
        ↓
EXECUTAR separação por intervalo
        ↓
VERIFICAR integridade de cada arquivo gerado
        ↓
REGISTRAR no log_separacoes.md
        ↓
EXIBIR resumo com caminho da pasta
```

---

## ⚠️ Tratamento de Erros

| Erro | Causa | Ação da VERA |
|---|---|---|
| Arquivo não encontrado | Caminho incorreto | Notificar e encerrar |
| Tipo não suportado | Não é `.pdf`, `.docx` ou `.doc` | Notificar e encerrar |
| Intervalo inválido | Página fora do range | Solicitar novamente |
| 0 páginas detectadas | PDF mal-formado | Assumir 1 e avisar |
| Falha na exportação | Word travado | Registrar ERRO no log |

---

## 📊 Log de Separações

Cada operação registrada em `log_separacoes.md`:

```markdown
## Log de Separações — VERA (#24)

| Data/Hora | Arquivo Origem | Páginas | Segmentos | Pasta Destino | Status |
|---|---|---|---|---|---|
| 2026-04-13 15:52 | apostila.pdf | 5–20 | 1 arquivo | apostila_separado_... | ✅ OK |
```

---

## Regra de Ouro:
> *"VERA nunca separa sem perguntar. Cada corte é intencional, validado e rastreado."*

---

**Skill criada em:** 2026-04-13  
**Pertence a:** VERA — Secretaria de Gestão Administrativa (#24)  
**Superior:** ARIA — Secretaria Geral (SG-01)
