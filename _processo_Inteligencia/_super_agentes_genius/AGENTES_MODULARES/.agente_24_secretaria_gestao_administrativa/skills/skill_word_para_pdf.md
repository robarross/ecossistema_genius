# Skill: Conversão de Word para PDF — VERA (#24)

## Descrição:
Esta skill habilita a VERA a executar, orquestrar e registrar a conversão de documentos `.docx` / `.doc` do Microsoft Word para o formato `.pdf`, garantindo fidelidade de formatação, nomenclatura padronizada e rastreabilidade completa de cada conversão realizada.

---

## ⚙️ Método de Execução

VERA opera a conversão utilizando ferramentas disponíveis no ambiente do ecossistema, priorizadas na seguinte ordem:

| Prioridade | Método | Quando Usar |
|---|---|---|
| 1️⃣ | **Script Python** (`docx2pdf`) | Ambiente com Python disponível — método principal |
| 2️⃣ | **PowerShell + Word COM Object** | Ambiente Windows com Microsoft Word instalado |
| 3️⃣ | **LibreOffice CLI** | Ambiente sem Word (ex: Linux/servidor) |
| 4️⃣ | **API externa** (ex: CloudConvert) | Fallback quando nenhum método local está disponível |

---

## 🐍 Método 1 — Script Python (Principal)

### Pré-requisitos:
```bash
pip install docx2pdf
```

### Script Padrão:
```python
# skill_word_para_pdf.py — VERA (#24)
# Converte um único arquivo Word para PDF

from docx2pdf import convert
from pathlib import Path
from datetime import datetime
import os

def converter_word_para_pdf(caminho_word: str, pasta_destino: str = None) -> dict:
    """
    Converte um arquivo .docx/.doc para .pdf.
    
    Args:
        caminho_word: Caminho completo do arquivo Word.
        pasta_destino: Pasta onde o PDF será salvo.
                       Se None, salva na mesma pasta do Word.
    
    Returns:
        dict com status, caminho do PDF gerado e log de execução.
    """
    caminho_origem = Path(caminho_word)
    
    # Validações
    if not caminho_origem.exists():
        return {"status": "ERRO", "mensagem": f"Arquivo não encontrado: {caminho_word}"}
    
    if caminho_origem.suffix.lower() not in [".docx", ".doc"]:
        return {"status": "ERRO", "mensagem": "Arquivo não é .docx ou .doc"}
    
    # Definir destino
    if pasta_destino:
        Path(pasta_destino).mkdir(parents=True, exist_ok=True)
        caminho_pdf = Path(pasta_destino) / caminho_origem.with_suffix(".pdf").name
    else:
        caminho_pdf = caminho_origem.with_suffix(".pdf")
    
    # Executar conversão
    try:
        convert(str(caminho_origem), str(caminho_pdf))
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        return {
            "status": "SUCESSO",
            "arquivo_origem": str(caminho_origem),
            "arquivo_gerado": str(caminho_pdf),
            "timestamp": timestamp,
            "tamanho_pdf_kb": round(os.path.getsize(caminho_pdf) / 1024, 2)
        }
    except Exception as e:
        return {"status": "ERRO", "mensagem": str(e)}


def converter_pasta_word_para_pdf(pasta_origem: str, pasta_destino: str = None) -> list:
    """
    Converte TODOS os arquivos Word de uma pasta para PDF.
    
    Args:
        pasta_origem: Pasta contendo os arquivos .docx/.doc.
        pasta_destino: Pasta de destino dos PDFs.
                       Se None, salva na mesma pasta de origem.
    
    Returns:
        Lista de dicts com resultado de cada conversão.
    """
    pasta = Path(pasta_origem)
    arquivos_word = list(pasta.glob("*.docx")) + list(pasta.glob("*.doc"))
    
    if not arquivos_word:
        return [{"status": "AVISO", "mensagem": "Nenhum arquivo Word encontrado na pasta."}]
    
    resultados = []
    for arquivo in arquivos_word:
        resultado = converter_word_para_pdf(str(arquivo), pasta_destino)
        resultados.append(resultado)
        print(f"[{resultado['status']}] {arquivo.name}")
    
    return resultados


# --- Execução Direta ---
if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Uso: python skill_word_para_pdf.py <caminho_arquivo_ou_pasta> [pasta_destino]")
        sys.exit(1)
    
    caminho = sys.argv[1]
    destino = sys.argv[2] if len(sys.argv) > 2 else None
    
    if Path(caminho).is_dir():
        resultados = converter_pasta_word_para_pdf(caminho, destino)
        sucessos = sum(1 for r in resultados if r["status"] == "SUCESSO")
        erros = sum(1 for r in resultados if r["status"] == "ERRO")
        print(f"\n✅ Concluído: {sucessos} convertido(s) | ❌ {erros} erro(s)")
    else:
        resultado = converter_word_para_pdf(caminho, destino)
        print(resultado)
```

---

## 🖥️ Método 2 — PowerShell + Microsoft Word (Fallback Windows)

```powershell
# Converte um único arquivo Word para PDF via COM Object do Word
# VERA (#24) — Skill Word para PDF
# ✅ Testado e validado em 2026-04-13

param (
    [string]$CaminhoWord,
    [string]$PastaDestino = ""
)

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

try {
    $arquivo = Get-Item -Path $CaminhoWord

    if ($PastaDestino -eq "") {
        $caminhoPdf = [System.IO.Path]::ChangeExtension($arquivo.FullName, ".pdf")
    } else {
        if (-not (Test-Path $PastaDestino)) { New-Item -ItemType Directory -Path $PastaDestino | Out-Null }
        $caminhoPdf = Join-Path $PastaDestino ($arquivo.BaseName + ".pdf")
    }

    # Abre em modo somente leitura para evitar diálogos de edição
    $doc = $word.Documents.Open($arquivo.FullName, $false, $true)

    # ExportAsFixedFormat: mais confiável que SaveAs com [ref] no PowerShell
    $doc.ExportAsFixedFormat(
        $caminhoPdf,  # OutputFileName
        17,           # ExportFormat: wdExportFormatPDF
        $false,       # OpenAfterExport
        0,            # OptimizeFor: wdExportOptimizeForPrint
        0,            # Range: wdExportAllDocument
        1, 1,         # From, To (ignorados quando Range=0)
        0,            # Item: wdExportDocumentContent
        $true,        # IncludeDocProps
        $true,        # KeepIRM
        0,            # CreateBookmarks: wdExportBookmarksNoBookmarks
        $true,        # DocStructureTags
        $true,        # BitmapMissingFonts
        $false        # UseISO19005_1
    )
    $doc.Close($false)
    $tamanho = [math]::Round((Get-Item $caminhoPdf).Length / 1KB, 2)
    Write-Host "SUCESSO: $caminhoPdf ($tamanho KB)"

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
.\skill_word_para_pdf.ps1 -CaminhoWord "C:\docs\relatorio.docx" -PastaDestino "C:\pdfs"
```

---

## 🐧 Método 3 — LibreOffice CLI (Fallback Multiplataforma)

```bash
# Conversão via LibreOffice (sem interface gráfica)
libreoffice --headless --convert-to pdf --outdir "/pasta/destino/" "/pasta/origem/arquivo.docx"

# Converter todos os .docx de uma pasta:
libreoffice --headless --convert-to pdf --outdir "/pdfs/" /documentos/*.docx
```

---

## 📋 Fluxo de Execução da VERA

```
1. RECEBER solicitação (arquivo único ou pasta)
       ↓
2. VALIDAR arquivo(s): existência, extensão (.docx/.doc), permissões
       ↓
3. SELECIONAR método disponível (Python → PowerShell → LibreOffice → API)
       ↓
4. EXECUTAR conversão
       ↓
5. VERIFICAR integridade do PDF gerado (tamanho > 0, arquivo existe)
       ↓
6. NOMEAR com padrão: [nome_original]_v[data].pdf
       ↓
7. ARQUIVAR na pasta correta (/administrativa/relatorios/ ou destino solicitado)
       ↓
8. REGISTRAR no log de conversões
       ↓
9. NOTIFICAR o solicitante com confirmação e caminho do PDF
```

---

## 📁 Padrão de Nomenclatura dos PDFs

```
[nome_original]_[YYYY-MM-DD].pdf
```

**Exemplos:**
- `relatorio_mensal_2026-04-13.pdf`
- `contrato_fornecedor_v2_2026-04-13.pdf`

> **Regra:** O arquivo Word original **nunca é excluído** após a conversão. O PDF é sempre uma *cópia adicional*.

---

## 📊 Registro de Conversões (Log)

Cada conversão é registrada em `log_conversoes_pdf.md`:

```markdown
## Log de Conversões — Word → PDF

| Data/Hora | Arquivo Origem | PDF Gerado | Método | Status | Solicitante |
|---|---|---|---|---|---|
| 2026-04-13 15:00 | relatorio.docx | relatorio_2026-04-13.pdf | Python | ✅ OK | Usuário Humano |
```

---

## ⚠️ Tratamento de Erros

| Erro | Causa Provável | Ação da VERA |
|---|---|---|
| Arquivo não encontrado | Caminho errado | Notificar solicitante com caminho correto |
| Extensão inválida | Arquivo não é Word | Rejeitar e informar extensões aceitas |
| Word/LibreOffice não instalado | Ambiente sem software | Tentar próximo método disponível |
| Permissão negada | Arquivo bloqueado/aberto | Solicitar que o arquivo seja fechado antes |
| PDF gerado com 0 bytes | Falha na renderização | Registrar como ERRO e escalar para ARIA |

---

## Regra de Ouro:
> *"Um documento convertido errado é pior do que um não convertido. VERA sempre verifica antes de entregar."*

---

**Skill criada em:** 2026-04-13  
**Pertence a:** VERA — Secretaria de Gestão Administrativa (#24)  
**Superior:** ARIA — Secretaria Geral (SG-01)
