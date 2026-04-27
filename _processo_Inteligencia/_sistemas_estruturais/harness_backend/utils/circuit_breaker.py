import os
import time
import json
from typing import Dict, Any

class FractalCircuitBreaker:
    """
    Disjuntor de Segurança para Fractais Genius.
    Previne que falhas locais derrubem o ecossistema global.
    """
    
    DB_PATH = "e:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/0_sistema_core/[SYS]__genius_core/circuit_status.json"
    FAILURE_THRESHOLD = 3
    RECOVERY_TIMEOUT = 300 # 5 minutos

    @classmethod
    def _load_status(cls) -> Dict[str, Any]:
        if not os.path.exists(cls.DB_PATH):
            os.makedirs(os.path.dirname(cls.DB_PATH), exist_ok=True)
            return {}
        with open(cls.DB_PATH, "r") as f:
            return json.load(f)

    @classmethod
    def _save_status(cls, status: Dict[str, Any]):
        with open(cls.DB_PATH, "w") as f:
            json.dump(status, f, indent=4)

    @classmethod
    def can_execute(cls, module_id: str) -> bool:
        """
        Verifica se o disjuntor está FECHADO ou se o tempo de recuperação passou.
        """
        status = cls._load_status()
        module_data = status.get(module_id, {"failures": 0, "state": "CLOSED", "last_failure": 0})
        
        if module_data["state"] == "OPEN":
            # Verificar se já passou o tempo de recuperação
            if time.time() - module_data["last_failure"] > cls.RECOVERY_TIMEOUT:
                print(f"   [CIRCUIT-BREAKER] ⏳ Módulo {module_id} em fase de testes (HALF-OPEN).")
                return True
            print(f"   [CIRCUIT-BREAKER] 🛑 Módulo {module_id} ISOLADO (Estado: OPEN).")
            return False
            
        return True

    @classmethod
    def record_failure(cls, module_id: str):
        """
        Registra uma falha e abre o disjuntor se atingir o limite.
        """
        status = cls._load_status()
        module_data = status.get(module_id, {"failures": 0, "state": "CLOSED", "last_failure": 0})
        
        module_data["failures"] += 1
        module_data["last_failure"] = time.time()
        
        if module_data["failures"] >= cls.FAILURE_THRESHOLD:
            module_data["state"] = "OPEN"
            print(f"   [CIRCUIT-BREAKER] 🔥 DISJUNTOR PULOU! Módulo {module_id} isolado.")
            
        status[module_id] = module_data
        cls._save_status(status)

    @classmethod
    def record_success(cls, module_id: str):
        """
        Reseta o disjuntor após um sucesso.
        """
        status = cls._load_status()
        if module_id in status:
            status[module_id] = {"failures": 0, "state": "CLOSED", "last_failure": 0}
            cls._save_status(status)
