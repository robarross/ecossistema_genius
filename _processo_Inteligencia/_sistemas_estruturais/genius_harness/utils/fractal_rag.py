import os
from typing import List, Dict, Any

class FractalRAG:
    """
    Motor de Busca Semântica Local para Fractais Genius.
    Foca na pasta 3-LIB do módulo para injetar especialização.
    """
    
    @staticmethod
    def get_local_context(module_path: str) -> str:
        """
        Lê todos os arquivos em 3-LIB e retorna um bloco de contexto.
        """
        lib_path = os.path.join(module_path, "3-LIB")
        if not os.path.exists(lib_path):
            return "Nenhum conhecimento especializado local encontrado."
            
        context_blocks = []
        for root, dirs, files in os.walk(lib_path):
            for file in files:
                if file.endswith(".md") or file.endswith(".txt"):
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                            content = f.read()
                            context_blocks.append(f"--- DOCUMENTO: {file} ---\n{content}")
                    except Exception as e:
                        print(f"   [FRACTAL-RAG] Erro ao ler {file}: {e}")
                        
        if not context_blocks:
            return "Biblioteca local vazia."
            
        return "\n\n".join(context_blocks)

def inject_fractal_knowledge(prompt: str, module_path: str) -> str:
    """
    Injeta o conhecimento da 3-LIB no prompt do sistema.
    """
    knowledge = FractalRAG.get_local_context(module_path)
    augmented_prompt = f"### 🧠 CONHECIMENTO ESPECIALIZADO LOCAL (FRACTAL RAG)\n{knowledge}\n\n### 📝 INSTRUÇÃO\n{prompt}"
    return augmented_prompt
