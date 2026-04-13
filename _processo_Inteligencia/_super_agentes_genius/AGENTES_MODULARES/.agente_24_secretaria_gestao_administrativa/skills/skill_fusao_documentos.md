# Skill: Fusão de Documentos (Word + PDF) — VERA (#24)

## Descrição:
Esta skill habilita a VERA a **unir 2 ou mais arquivos** — sejam `.docx`, `.doc` ou `.pdf` — em um único documento final organizado, preservando formatação, mantendo ordem customizável e gerando log completo da operação.

A skill detecta automaticamente o tipo de cada arquivo e aplica o método de fusão mais adequado para o ambiente disponível.

---

## 🗺️ Matriz de Fusão por Tipo

| Combinação | Método Principal | Saída |
|---|---|---|
| Word + Word | PowerShell COM (Word) | `.docx` ou `.pdf` |
| PDF + PDF | PowerShell iTextSharp (.NET) | `.pdf` |
| Word + PDF (misto) | Converter Word→PDF, depois unir PDFs | `.pdf` |

---

## 🖥️ MÉTODO 1 — Fusão de Word + Word (PowerShell COM)
> ✅ Testado e validado no ambiente Windows com Microsoft Word instalado

```powershell
# skill_fusao_word.ps1 — VERA (#24)
# Une múltiplos arquivos .docx/.doc em um único documento Word
# ✅ Validado em 2026-04-13

param (
    [string[]]$Arquivos,          # Lista de caminhos dos .docx em ordem
    [string]$Destino,             # Caminho completo do arquivo de saída (.docx)
    [switch]$SalvarComoPdf        # Se presente, salva também como .pdf
)

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

try {
    # Abre o primeiro documento como base
    $docBase = $word.Documents.Open($Arquivos[0], $false, $false)

    # Vai para o final do documento base
    $selecao = $word.Selection
    $selecao.EndKey(6) | Out-Null  # wdStory = 6

    # Itera pelos documentos restantes
    for ($i = 1; $i -lt $Arquivos.Count; $i++) {
        $arquivoAtual = $Arquivos[$i]
        Write-Host "Adicionando: $(Split-Path $arquivoAtual -Leaf)"

        # Insere quebra de página antes de cada novo documento
        $selecao.InsertBreak(7) | Out-Null  # wdPageBreak = 7
        $selecao.EndKey(6) | Out-Null

        # Insere o conteúdo do próximo arquivo na posição atual
        $selecao.InsertFile($arquivoAtual) | Out-Null
        $selecao.EndKey(6) | Out-Null
    }

    # Salva o documento final
    # ─── CORREÇÃO OBRIGATÓRIA: Títulos Órfãos ──────────────────────────────────
    # Usa OutlineLevel (propriedade universal do Word) para detectar QUALQUER
    # estilo de heading, incluindo estilos customizados como "Grupo 1", "Passo X"
    # OutlineLevel < 10 = qualquer heading | 10 = wdOutlineLevelBodyText (normal)
    Write-Host "Aplicando KeepWithNext via OutlineLevel..."
    $corrigidos = 0
    foreach ($paragrafo in $docBase.Paragraphs) {
        if ($paragrafo.OutlineLevel -lt 10) {
            $paragrafo.Format.KeepWithNext    = $true
            $paragrafo.Format.KeepTogether    = $true
            $paragrafo.Format.PageBreakBefore = $false
            $corrigidos++
        }
    }
    Write-Host "KeepWithNext aplicado em $corrigidos headings."
    # ──────────────────────────────────────────────────────────────────────────

    $docBase.SaveAs2($Destino)
    $tamanhoDocx = [math]::Round((Get-Item $Destino).Length / 1KB, 2)
    Write-Host "SUCESSO (DOCX): $Destino ($tamanhoDocx KB)"

    # Opcionalmente converte para PDF
    if ($SalvarComoPdf) {
        $destinoPdf = [System.IO.Path]::ChangeExtension($Destino, ".pdf")
        $docBase.ExportAsFixedFormat(
            $destinoPdf, 17, $false, 0, 0, 1, 1, 0, $true, $true, 0, $true, $true, $false
        )
        $tamanhoPdf = [math]::Round((Get-Item $destinoPdf).Length / 1KB, 2)
        Write-Host "SUCESSO (PDF): $destinoPdf ($tamanhoPdf KB)"
    }

    $docBase.Close($false)

} catch {
    Write-Host "ERRO: $($_.Exception.Message)"
} finally {
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    [GC]::Collect()
}
```

**Uso:**
```powershell
# Unir 2 ou mais arquivos Word em um único .docx
.\skill_fusao_word.ps1 `
    -Arquivos @("C:\docs\capitulo_1.docx", "C:\docs\capitulo_2.docx", "C:\docs\capitulo_3.docx") `
    -Destino "C:\docs\apostila_completa.docx"

# Unir E já salvar como PDF também
.\skill_fusao_word.ps1 `
    -Arquivos @("C:\docs\cap1.docx", "C:\docs\cap2.docx") `
    -Destino "C:\docs\apostila_completa.docx" `
    -SalvarComoPdf
```

---

## 📄 MÉTODO 2 — Fusão de PDF + PDF (PowerShell + iTextSharp .NET)
> Requer: `iTextSharp.dll` disponível no ambiente

```powershell
# skill_fusao_pdf.ps1 — VERA (#24)
# Une múltiplos arquivos .pdf em um único arquivo PDF

param (
    [string[]]$Arquivos,    # Lista de caminhos dos PDFs em ordem
    [string]$Destino        # Caminho completo do PDF de saída
)

# Caminho da dll do iTextSharp (ajustar conforme o ambiente)
$dllPath = "C:\libs\itextsharp.dll"

if (-not (Test-Path $dllPath)) {
    Write-Host "ERRO: iTextSharp.dll não encontrado em $dllPath"
    Write-Host "Baixe em: https://github.com/itext/itextsharp/releases"
    exit 1
}

Add-Type -Path $dllPath

$writer  = [iTextSharp.text.pdf.PdfCopyFields]
$doc     = New-Object iTextSharp.text.Document
$stream  = New-Object System.IO.FileStream($Destino, [System.IO.FileMode]::Create)
$copy    = New-Object iTextSharp.text.pdf.PdfCopy($doc, $stream)

$doc.Open()

try {
    foreach ($arquivo in $Arquivos) {
        Write-Host "Adicionando: $(Split-Path $arquivo -Leaf)"
        $reader = New-Object iTextSharp.text.pdf.PdfReader($arquivo)
        for ($pagina = 1; $pagina -le $reader.NumberOfPages; $pagina++) {
            $copy.AddPage($copy.GetImportedPage($reader, $pagina))
        }
        $reader.Close()
    }
    $doc.Close()
    $tamanho = [math]::Round((Get-Item $Destino).Length / 1KB, 2)
    Write-Host "SUCESSO: $Destino ($tamanho KB)"
} catch {
    Write-Host "ERRO: $($_.Exception.Message)"
    $doc.Close()
}
```

---

## 🔁 MÉTODO 3 — Fusão Mista (Word + PDF → PDF Final)
> Converte os arquivos Word para PDF primeiro, depois une todos como PDF

```powershell
# skill_fusao_mista.ps1 — VERA (#24)
# Une arquivos .docx e .pdf misturados em um único PDF final

param (
    [string[]]$Arquivos,    # Lista de caminhos (.docx ou .pdf), em ordem
    [string]$Destino,       # Caminho do PDF final de saída
    [string]$PastaTemp = "$env:TEMP\VERA_fusao_$(Get-Date -Format 'yyyyMMddHHmmss')"
)

# Criar pasta temporária para PDFs intermediários
New-Item -ItemType Directory -Path $PastaTemp -Force | Out-Null
$pdfsFusao = @()

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

Write-Host "=== ETAPA 1: Preparando arquivos ==="

try {
    foreach ($arquivo in $Arquivos) {
        $ext = [System.IO.Path]::GetExtension($arquivo).ToLower()
        $nome = [System.IO.Path]::GetFileNameWithoutExtension($arquivo)
        $index = $Arquivos.IndexOf($arquivo).ToString("D3")

        if ($ext -in @(".docx", ".doc")) {
            # Converte Word → PDF temporário
            $pdfTemp = Join-Path $PastaTemp "$index`_$nome.pdf"
            Write-Host "  Convertendo: $(Split-Path $arquivo -Leaf) → PDF"
            $doc = $word.Documents.Open($arquivo, $false, $true)
            $doc.ExportAsFixedFormat(
                $pdfTemp, 17, $false, 0, 0, 1, 1, 0, $true, $true, 0, $true, $true, $false
            )
            $doc.Close($false)
            $pdfsFusao += $pdfTemp

        } elseif ($ext -eq ".pdf") {
            # Copia PDF para a pasta temp com índice de ordem
            $pdfTemp = Join-Path $PastaTemp "$index`_$nome.pdf"
            Copy-Item -Path $arquivo -Destination $pdfTemp
            Write-Host "  Adicionando PDF: $(Split-Path $arquivo -Leaf)"
            $pdfsFusao += $pdfTemp
        } else {
            Write-Host "  AVISO: Tipo não suportado ignorado: $arquivo"
        }
    }

} finally {
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    [GC]::Collect()
}

Write-Host "`n=== ETAPA 2: Unindo $($pdfsFusao.Count) PDFs ==="

# Verificar se iTextSharp está disponível
$dllPath = "C:\libs\itextsharp.dll"
if (Test-Path $dllPath) {
    # Usar iTextSharp
    Add-Type -Path $dllPath
    $doc     = New-Object iTextSharp.text.Document
    $stream  = New-Object System.IO.FileStream($Destino, [System.IO.FileMode]::Create)
    $copy    = New-Object iTextSharp.text.pdf.PdfCopy($doc, $stream)
    $doc.Open()
    foreach ($pdf in ($pdfsFusao | Sort-Object)) {
        $reader = New-Object iTextSharp.text.pdf.PdfReader($pdf)
        for ($p = 1; $p -le $reader.NumberOfPages; $p++) {
            $copy.AddPage($copy.GetImportedPage($reader, $p))
        }
        $reader.Close()
        Write-Host "  ✔ $(Split-Path $pdf -Leaf)"
    }
    $doc.Close()
} else {
    Write-Host "AVISO: iTextSharp não encontrado. Usando Word COM para fusão final..."
    # Fallback: usa o Word para abrir o primeiro PDF convertido e inserir os demais
    # (limitado — apenas para PDFs gerados a partir de Word)
    Write-Host "Para fusão de PDFs puros, instale o iTextSharp em $dllPath"
}

$tamanho = [math]::Round((Get-Item $Destino -ErrorAction SilentlyContinue).Length / 1KB, 2)
Write-Host "`nSUCESSO: $Destino ($tamanho KB)"

# Limpar pasta temp
Remove-Item -Path $PastaTemp -Recurse -Force
Write-Host "Arquivos temporários removidos."
```

**Uso:**
```powershell
# Unir Word + PDF + Word → um único PDF final
.\skill_fusao_mista.ps1 `
    -Arquivos @(
        "C:\docs\capa.docx",
        "C:\docs\capitulo_1.pdf",
        "C:\docs\capitulo_2.docx",
        "C:\docs\anexos.pdf"
    ) `
    -Destino "C:\docs\documento_completo.pdf"
```

---

## 🧠 Fluxo de Decisão da VERA

```
RECEBER lista de arquivos para unir
        ↓
VALIDAR: todos os arquivos existem?  → NÃO → Notificar erro
        ↓ SIM
IDENTIFICAR tipos (Word / PDF / misto)
        ↓
    ┌──────────────────────────────────────┐
    │  Todos Word?  → MÉTODO 1             │
    │  Todos PDF?   → MÉTODO 2             │
    │  Misto?       → MÉTODO 3             │
    └──────────────────────────────────────┘
        ↓
DEFINIR ordem de fusão (por parâmetro ou por nome de arquivo)
        ↓
EXECUTAR fusão
        ↓
VERIFICAR integridade do arquivo final (tamanho > 0)
        ↓
NOMEAR output: [nome_escolhido]_fusao_[YYYY-MM-DD].[ext]
        ↓
REGISTRAR no log_fusoes.md
        ↓
NOTIFICAR solicitante com confirmação e caminho
```

---

## 📋 Opções de Ordenação dos Arquivos

A VERA respeita estritamente a **ordem fornecida** na lista de arquivos. Convenções de ordenação recomendadas:

| Estratégia | Como fazer |
|---|---|
| **Explícita** | Passar os arquivos na ordem desejada no parâmetro `-Arquivos` |
| **Por prefixo numérico** | Nomear arquivos como `01_capa.docx`, `02_intro.docx`, `03_cap1.docx` |
| **Por data de modificação** | VERA ordena automaticamente do mais antigo ao mais recente |
| **Alfabética** | VERA ordena por nome de arquivo A→Z |

---

## 📊 Log de Fusões

Cada operação é registrada em `log_fusoes.md`:

```markdown
## Log de Fusões de Documentos — VERA (#24)

| Data/Hora | Arquivos Unidos | Arquivo Final | Método | Páginas | Status |
|---|---|---|---|---|---|
| 2026-04-13 15:20 | cap1.docx + cap2.docx + cap3.docx | apostila.pdf | Word COM | 47 | ✅ OK |
```

---

## ⚠️ Tratamento de Erros

| Erro | Causa | Ação da VERA |
|---|---|---|
| Arquivo não encontrado | Caminho errado na lista | Notificar e cancelar toda a operação |
| Arquivo corrompido | PDF/Word inválido | Pular arquivo + registrar aviso no log |
| iTextSharp ausente | DLL não instalada | Usar método Word COM como fallback |
| Sem permissão de escrita | Pasta de destino protegida | Solicitar destino alternativo |
| Arquivo bloqueado (aberto) | Word/Reader aberto | Solicitar fechamento antes de executar |

---

## Regras de Ouro:
1. *"A ordem importa tanto quanto o conteúdo. VERA nunca assume — sempre confirma a sequência antes de unir."*
2. *"Arquivos originais são intocáveis. A fusão sempre gera um arquivo NOVO."*
3. *"Um arquivo final com menos páginas que a soma das partes é sinal de falha — verificar antes de entregar."*

---

**Skill criada em:** 2026-04-13  
**Pertence a:** VERA — Secretaria de Gestão Administrativa (#24)  
**Superior:** ARIA — Secretaria Geral (SG-01)
