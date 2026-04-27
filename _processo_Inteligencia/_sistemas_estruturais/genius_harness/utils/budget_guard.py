import os
import json
import time
from typing import Dict, Any

PRICING = {
    "gpt-4o": {"input": 5.00, "output": 15.00},  # Por 1M tokens
    "gpt-4o-mini": {"input": 0.15, "output": 0.60}
}

class MicroCFO:
    """
    Gestor Financeiro Local do Fractal.
    Controla o budget.json e aplica limites de gastos.
    """
    
    @staticmethod
    def check_budget(module_path: str) -> str:
        """
        Verifica o status financeiro e retorna o modelo recomendado.
        """
        budget_path = os.path.join(module_path, "budget.json")
        if not os.path.exists(budget_path):
            return "gpt-4o" # Default se não houver budget (ajustável)
            
        with open(budget_path, "r") as f:
            data = json.load(f)
            
        limit = data.get("monthly_limit", 10.0)
        spent = data.get("current_spend", 0.0)
        
        if spent >= limit:
            print(f"   [MICRO-CFO] 🛑 Teto de gastos atingido (${spent}/${limit}). BLOQUEANDO.")
            return "STOP"
        
        if spent >= (limit * 0.8):
            print(f"   [MICRO-CFO] ⚠️ Modo Econômico ativado (Gasto: ${spent:.4f})")
            return "gpt-4o-mini"
            
        return "gpt-4o"

    @staticmethod
    def update_spend(module_path: str, model: str, input_tokens: int, output_tokens: int):
        """
        Calcula e atualiza o gasto no budget.json
        """
        budget_path = os.path.join(module_path, "budget.json")
        if not os.path.exists(budget_path): return
        
        # Cálculo de custo (simplificado para USD/1M tokens)
        prices = PRICING.get(model, PRICING["gpt-4o-mini"])
        cost = (input_tokens / 1_000_000 * prices["input"]) + (output_tokens / 1_000_000 * prices["output"])
        
        with open(budget_path, "r") as f:
            data = json.load(f)
            
        data["current_spend"] = data.get("current_spend", 0.0) + cost
        data["last_update"] = time.strftime("%Y-%m-%d %H:%M:%S")
        
        with open(budget_path, "w") as f:
            json.dump(data, f, indent=4)
            
        print(f"   [MICRO-CFO] 💰 Gasto atualizado: +${cost:.6f} (Total: ${data['current_spend']:.4f})")
