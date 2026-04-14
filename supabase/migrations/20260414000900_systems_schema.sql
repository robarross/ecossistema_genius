-- Systems Tracking SQL Schema for Genius Ecosystem
-- Created: 2026-04-14
-- Depends on: 20260413000100_core_schema.sql, 20260414000300_modules_schema.sql

-- 1. TABLES
-- Systems Table
CREATE TABLE IF NOT EXISTS public.systems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_id TEXT UNIQUE NOT NULL, -- e.g., "SYS-001"
    name TEXT NOT NULL,
    description TEXT,
    type TEXT, -- 'Barramento', 'ERP', 'Micro-SaaS', 'Website'
    status TEXT DEFAULT 'Idea', -- 'Idea', 'Development', 'Production', 'Evolution'
    current_stage INTEGER DEFAULT 1 CHECK (current_stage >= 1 AND current_stage <= 11),
    module_id UUID REFERENCES public.modules(id) ON DELETE SET NULL,
    submodule_id UUID REFERENCES public.submodules(id) ON DELETE SET NULL,
    creator_agent_id UUID REFERENCES public.agents(id) ON DELETE SET NULL,
    repository_url TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. TRIGGERS
-- Auto-update updated_at for systems
DROP TRIGGER IF EXISTS update_systems_updated_at ON public.systems;
CREATE TRIGGER update_systems_updated_at
    BEFORE UPDATE ON public.systems
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 3. INDEXES
CREATE INDEX IF NOT EXISTS idx_systems_module_id ON public.systems(module_id);
CREATE INDEX IF NOT EXISTS idx_systems_creator_agent_id ON public.systems(creator_agent_id);
CREATE INDEX IF NOT EXISTS idx_systems_display_id ON public.systems(display_id);
