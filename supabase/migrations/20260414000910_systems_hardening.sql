-- Systems Table Hardening and Visibility
-- Created: 2026-04-14
-- Depends on: 20260414000900_systems_schema.sql

-- 1. ENABLE ROW LEVEL SECURITY
ALTER TABLE public.systems ENABLE ROW LEVEL SECURITY;

-- 2. POLICIES
-- Admins have full access
CREATE POLICY "Admins have full access to systems"
  ON public.systems FOR ALL
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'Admin'));

-- All authenticated users can see systems (Discovery)
CREATE POLICY "Anyone in the ecosystem can view systems"
  ON public.systems FOR SELECT
  USING (true);

-- 3. ENABLE REALTIME
-- Add systems to the realtime publication
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = 'systems'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.systems;
  END IF;
EXCEPTION
  WHEN OTHERS THEN -- Handle cases where publication doesn't exist
    NULL;
END $$;

-- 4. DOCUMENTATION (SQL COMMENTS)
-- These comments will appear as tooltips in the Supabase Table Editor
COMMENT ON TABLE public.systems IS 'Tabela mestra de sistemas criados no Ecossistema Genius (ERP, Portais, Micro-SaaS).';
COMMENT ON COLUMN public.systems.display_id IS 'Identificador único de negócio (ex: SYS-001).';
COMMENT ON COLUMN public.systems.current_stage IS 'Estágio atual na metodologia Genius (1: IDEIA até 11: EVOLUÇÃO).';
COMMENT ON COLUMN public.systems.status IS 'Status operacional do sistema (Idea, Development, Production).';
COMMENT ON COLUMN public.systems.repository_url IS 'URL do código-fonte no GitHub para industrialização.';
COMMENT ON COLUMN public.systems.metadata IS 'Metadados adicionais, incluindo links para PRD, SPEC e IDEIA.';
