-- Migration: 20260415040000_refine_genius_bus_realtime.sql
-- Objetivo: Evoluir a tabela de eventos para um Barramento de Mensagens Realtime

-- 1. ADICIONAR COLUNAS DE COMUNICAÇÃO
ALTER TABLE public.genius_system_events 
ADD COLUMN IF NOT EXISTS receiver_id UUID REFERENCES public.agents(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS priority_level INTEGER DEFAULT 1; -- 1: Info, 2: Warn, 3: Critical

-- 2. ATUALIZAR COMENTÁRIOS PARA DOCUMENTAÇÃO
COMMENT ON COLUMN public.genius_system_events.receiver_id IS 'ID do agente destinatário da mensagem (NULL para Broadcast).';
COMMENT ON COLUMN public.genius_system_events.priority_level IS 'Nível de prioridade para estilização no Dashboard.';

-- 3. GARANTIR QUE A TABELA ESTÁ NA PUBLICAÇÃO REALTIME
-- Nota: O Supabase exige que a tabela esteja na publicação 'supabase_realtime'
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'genius_system_events'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_system_events;
  END IF;
EXCEPTION
  WHEN OTHERS THEN NULL;
END $$;

-- 4. ÍNDICES DE PERFORMANCE PARA O BUS
CREATE INDEX IF NOT EXISTS idx_genius_bus_receiver_id ON public.genius_system_events(receiver_id);
CREATE INDEX IF NOT EXISTS idx_genius_bus_priority_level ON public.genius_system_events(priority_level);
