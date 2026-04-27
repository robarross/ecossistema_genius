import os
import time
from typing import Dict, Any, List
from supabase import create_client, Client

class GeniusEventBus:
    """
    Sistema Nervoso do Ecossistema Genius.
    Gerencia a comunicação assíncrona entre módulos via Eventos.
    """
    
    def __init__(self):
        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")
        if url and key:
            self.supabase: Client = create_client(url, key)
        else:
            self.supabase = None
            print("   [EVENT-BUS] ⚠️ Supabase offline. Eventos serão apenas logados localmente.")

    def publish(self, source: str, event_type: str, payload: Dict[str, Any]):
        """
        Publica um evento no barramento global.
        """
        event_data = {
            "source_module": source,
            "event_type": event_type,
            "payload": payload,
            "timestamp": "now()"
        }
        
        print(f"   [EVENT-BUS] 📡 PUBLICANDO: [{source}] -> {event_type}")
        
        if self.supabase:
            try:
                self.supabase.table("genius_events").insert(event_data).execute()
            except Exception as e:
                print(f"   [EVENT-BUS] ❌ Erro ao persistir evento: {e}")
        
        # Log local para redundância
        log_path = "e:/Diretorios/Diretorio_Agentes/_processo_Inteligencia/_sistemas_estruturais/0_sistema_core/[SYS]__genius_core/event_bus.log"
        with open(log_path, "a", encoding="utf-8") as f:
            f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {source} emitiu {event_type}\n")

    def get_pending_events(self, event_type: str = None) -> List[Dict[str, Any]]:
        """
        Recupera eventos para processamento.
        """
        if not self.supabase: return []
        
        query = self.supabase.table("genius_events").select("*").eq("status", "PENDING")
        if event_type:
            query = query.eq("event_type", event_type)
            
        return query.execute().data
