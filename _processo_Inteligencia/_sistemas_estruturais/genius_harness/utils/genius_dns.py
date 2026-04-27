import os
from typing import List, Dict, Any
from supabase import create_client, Client

class GeniusDNS:
    """
    Serviço de Descoberta de Capacidades (DNS de Agentes).
    Permite que módulos encontrem uns aos outros via Sockets.
    """
    
    def __init__(self):
        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")
        if url and key:
            self.supabase: Client = create_client(url, key)
        else:
            self.supabase = None
            print("   [GENIUS-DNS] ⚠️ Supabase offline. Registro operando em modo local.")

    def register(self, module_id: str, sector: str, sockets: Dict[str, Any], path: str):
        """
        Registra as capacidades do módulo no DNS.
        """
        data = {
            "module_id": module_id,
            "sector": sector,
            "inputs": sockets.get("input", []),
            "outputs": sockets.get("output", []),
            "physical_path": path,
            "status": "ACTIVE"
        }
        
        print(f"   [GENIUS-DNS] 🔎 REGISTRANDO: {module_id} [{sector}]")
        
        if self.supabase:
            try:
                self.supabase.table("genius_dns").upsert(data, on_conflict="module_id").execute()
            except Exception as e:
                print(f"   [GENIUS-DNS] ❌ Erro no registro: {e}")

    def lookup(self, capability: str) -> List[Dict[str, Any]]:
        """
        Busca módulos que possuam uma determinada capacidade (input ou output).
        """
        if not self.supabase: return []
        
        try:
            # Busca módulos onde a capacidade está na lista de inputs ou outputs
            res = self.supabase.table("genius_dns").select("*").or_(f"inputs.cs.{{ {capability} }}, outputs.cs.{{ {capability} }}").execute()
            return res.data
        except Exception as e:
            print(f"   [GENIUS-DNS] ❌ Erro na busca: {e}")
            return []
