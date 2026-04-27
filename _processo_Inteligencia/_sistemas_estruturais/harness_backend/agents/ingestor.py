import os
import csv
from typing import Dict, Any, List

class BatchIngestor:
    """
    Agente #Ingestor-01.
    Transforma planilhas CSV em ordens de produção para a Fábrica Genius.
    """
    
    INGESTION_PATH = "e:/Diretorios/Diretorio_Agentes/0-IN/_ingestao_massiva"

    @classmethod
    def read_spreadsheet(cls) -> List[Dict[str, Any]]:
        """
        Lê o arquivo CSV mais recente na pasta de ingestão.
        """
        if not os.path.exists(cls.INGESTION_PATH):
            os.makedirs(cls.INGESTION_PATH, exist_ok=True)
            return []
            
        files = [f for f in os.listdir(cls.INGESTION_PATH) if f.endswith(".csv")]
        if not files:
            print("   [INGESTOR] ⚠️ Nenhum arquivo CSV encontrado para processamento.")
            return []
            
        # Pega o arquivo mais recente
        latest_file = os.path.join(cls.INGESTION_PATH, sorted(files)[-1])
        print(f"   [INGESTOR] 📥 Lendo planilha: {os.path.basename(latest_file)}")
        
        tickets = []
        with open(latest_file, mode='r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                # Normalizar colunas para garantir captura de Nivel e Pai
                ticket = {
                    "nome": row.get("Nome", row.get("nome", "Sem_Nome")),
                    "setor": row.get("Setor", row.get("setor", "PADRAO")),
                    "nivel": row.get("Nivel", row.get("nivel", "FRACTAL")).upper(),
                    "pai": row.get("Pai", row.get("pai", "")),
                    "objetivo": row.get("Objetivo", row.get("objetivo", ""))
                }
                tickets.append(ticket)
                
        return tickets

def ingestor_node(state: Dict[str, Any]) -> Dict[str, Any]:
    """
    Nó que processa a planilha e prepara a fila de produção.
    """
    tickets = BatchIngestor.read_spreadsheet()
    
    if not tickets:
        state["status"] = "failed"
        state["final_report"] = "Nenhuma ordem de produção encontrada na planilha."
        return state
        
    print(f"   [INGESTOR] ✅ {len(tickets)} ordens de produção extraídas.")
    
    # Armazena a fila no estado para ser processada pela fábrica
    state["context_data"]["production_queue"] = tickets
    state["status"] = "processing_batch"
    
    return state
