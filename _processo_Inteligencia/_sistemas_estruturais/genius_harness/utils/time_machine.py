import os
import shutil
import time
from typing import List, Dict, Any

class FractalTimeMachine:
    """
    Motor de Snapshot e Rollback para Fractais Genius.
    Garante a imutabilidade das versões estáveis.
    """
    
    @staticmethod
    def create_snapshot(module_path: str, reason: str = "auto_snapshot") -> str:
        """
        Cria um backup do DNA e Socket atual.
        """
        snapshot_dir = os.path.join(module_path, ".snapshots")
        os.makedirs(snapshot_dir, exist_ok=True)
        
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        version_path = os.path.join(snapshot_dir, f"v_{timestamp}")
        os.makedirs(version_path, exist_ok=True)
        
        # Copiar DNA e Socket
        dna_src = os.path.join(module_path, "1-DNA")
        socket_src = os.path.join(module_path, "socket.json")
        
        if os.path.exists(dna_src):
            shutil.copytree(dna_src, os.path.join(version_path, "1-DNA"), dirs_exist_ok=True)
        if os.path.exists(socket_src):
            shutil.copy2(socket_src, os.path.join(version_path, "socket.json"))
            
        with open(os.path.join(version_path, "meta.txt"), "w") as f:
            f.write(f"Reason: {reason}\nTimestamp: {timestamp}\n")
            
        print(f"   [TIME-MACHINE] Snapshot v_{timestamp} criado para {os.path.basename(module_path)}")
        return f"v_{timestamp}"

    @staticmethod
    def rollback(module_path: str, version_id: str):
        """
        Restaura o módulo para uma versão anterior.
        """
        version_path = os.path.join(module_path, ".snapshots", version_id)
        if not os.path.exists(version_path):
            raise Exception(f"Versão {version_id} não encontrada.")
            
        # Restaurar
        dna_dest = os.path.join(module_path, "1-DNA")
        socket_dest = os.path.join(module_path, "socket.json")
        
        shutil.copytree(os.path.join(version_path, "1-DNA"), dna_dest, dirs_exist_ok=True)
        shutil.copy2(os.path.join(version_path, "socket.json"), socket_dest)
        
        print(f"   [TIME-MACHINE] ROLLBACK REALIZADO: {os.path.basename(module_path)} -> {version_id}")
