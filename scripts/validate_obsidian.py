import os
import sys

# Cofres que serão analisados
VAULT_DIRS = ['_segundo_cerebro_genius', '_processo_Inteligencia']

# Palavras-chave obrigatórias no conteúdo dos arquivos
REQUIRED_KEYWORDS = ['# ', 'ID:', 'Descrição:']

def validate_markdown_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        missing_keywords = [kw for kw in REQUIRED_KEYWORDS if kw not in content]
        
        if missing_keywords:
            return False, f"Faltam os identificadores: {', '.join(missing_keywords)}"
        return True, "OK"
    except Exception as e:
        return False, str(e)

def main():
    print("Iniciando Validação de Integridade do Obsidian (Genius Linter)...")
    errors_found = 0
    files_checked = 0

    base_path = os.getcwd()

    for vault in VAULT_DIRS:
        vault_path = os.path.join(base_path, vault)
        if not os.path.exists(vault_path):
            continue

        for root, dirs, files in os.walk(vault_path):
            for file in files:
                if file.endswith('.md'):
                    files_checked += 1
                    filepath = os.path.join(root, file)
                    is_valid, msg = validate_markdown_file(filepath)
                    
                    if not is_valid:
                        errors_found += 1
                        print(f"[ERRO] {os.path.relpath(filepath, base_path)}: {msg}")

    print(f"\nResumo: {files_checked} arquivos .md verificados.")
    if errors_found > 0:
        print(f"❌ Falha no Linter: Encontrados {errors_found} arquivos com metadados/formatação irregulares.")
        sys.exit(1)
    else:
        print("✅ Qualidade Aprovada: Todo o DNA dos agentes está conforme o padrão estrutural.")
        sys.exit(0)

if __name__ == "__main__":
    main()
