-- Global Infrastructure Visibility and Security (Core Layers)
-- Created: 2026-04-14
-- Depends on: 20260413000100_core_schema.sql, 20260414000300_modules_schema.sql, 20260414000400_skills_organization.sql

-- 1. ENABLE ROW LEVEL SECURITY
ALTER TABLE public.agents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submodules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fractals ENABLE ROW LEVEL SECURITY;

-- 2. POLICIES: Discovery (Read access for all authenticated users)
-- We use a loop for consistency
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND table_name IN ('agents', 'skills', 'modules', 'submodules', 'fractals')
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS "Anyone can view %I" ON public.%I', t, t);
        EXECUTE format('CREATE POLICY "Anyone can view %I" ON public.%I FOR SELECT USING (true)', t, t);
        
        EXECUTE format('DROP POLICY IF EXISTS "Admins have full access to %I" ON public.%I', t, t);
        EXECUTE format('CREATE POLICY "Admins have full access to %I" ON public.%I FOR ALL USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = ''Admin''))', t, t);
    END LOOP;
END $$;

-- 3. ENABLE REALTIME
-- Adding all infrastructure to the realtime publication
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM (VALUES ('agents'), ('skills'), ('modules'), ('submodules'), ('fractals')) AS t(table_name)
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM pg_publication_tables 
            WHERE pubname = 'supabase_realtime' AND schemaname = 'public' AND tablename = t
        ) THEN
            EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE public.%I', t);
        END IF;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN NULL; -- Skip if publication doesn't exist yet
END $$;

-- 4. DOCUMENTATION (SQL COMMENTS)
-- Descriptions for the Supabase Table Editor UI

-- Agents
COMMENT ON TABLE public.agents IS 'Entidades conscientes do Ecossistema Genius (Core, Super Agentes e Agentes Modulares).';
COMMENT ON COLUMN public.agents.display_id IS 'Identificador público (ex: #03 Archon).';
COMMENT ON COLUMN public.agents.role IS 'A função principal ou arquétipo do agente no sistema.';

-- Skills
COMMENT ON TABLE public.skills IS 'Capacidades granulares e talentos técnicos dos agentes registrados.';
COMMENT ON COLUMN public.skills.category IS 'Agrupamento funcional (Didática, Técnica, Marketing, etc.).';
COMMENT ON COLUMN public.skills.metadata IS 'Dados extras, como caminho do arquivo .md original ou requisitos de hardware.';

-- Infrastructure
COMMENT ON TABLE public.modules IS 'Módulos mestres do ecossistema (Categorias A até F).';
COMMENT ON TABLE public.submodules IS 'Sub-áreas de negócio vinculadas a módulos específicos.';
COMMENT ON TABLE public.fractals IS 'Micro-sistemas independentes e replicáveis (Camada 3 da hierarquia).';
