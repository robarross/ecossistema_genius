-- Genius Bus: Visibility and Hardening
-- Created: 2026-04-14
-- Depends on: 20260414000800_gamification_telemetry_schema.sql

-- 1. ENABLE ROW LEVEL SECURITY
ALTER TABLE public.genius_user_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.genius_system_events ENABLE ROW LEVEL SECURITY;

-- 2. POLICIES: User Stats
-- Users can read their own stats
CREATE POLICY "Users can view their own stats"
  ON public.genius_user_stats FOR SELECT
  USING (auth.uid() = profile_id);

-- Admins can update stats (for rewarding etc)
CREATE POLICY "Admins can update stats"
  ON public.genius_user_stats FOR UPDATE
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'Admin'));

-- 3. POLICIES: System Events
-- Users can view events related to their actions or system health
CREATE POLICY "Users can view system events"
  ON public.genius_system_events FOR SELECT
  USING (true);

-- Agents/Systems (service_role) can insert events
-- (In Supabase, service_role usually bypasses RLS, but we can be explicit if needed)

-- 4. ENABLE REALTIME
-- Critical for the Genius Bus to sync across Portals
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'genius_user_stats'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_user_stats;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'genius_system_events'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_system_events;
  END IF;
EXCEPTION
  WHEN OTHERS THEN NULL;
END $$;

-- 5. DOCUMENTATION
COMMENT ON TABLE public.genius_user_stats IS 'Estatísticas de gamificação do usuário (XP, Level, Medalhas).';
COMMENT ON TABLE public.genius_system_events IS 'Barramento universal de eventos e telemetria do ecossistema.';
