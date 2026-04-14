-- Genius Bus: Gamification & Telemetry Schema
-- Created: 2026-04-14
-- Depends on: 20260413000100_core_schema.sql, 20260414000340_profiles_schema.sql

-- 1. FUNCTIONS
-- Automatic Level Calculation (1000 XP per Level)
CREATE OR REPLACE FUNCTION public.calculate_genius_level(xp INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN (FLOOR(xp / 1000) + 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 2. TABLES
-- User Stats (Gamification)
CREATE TABLE IF NOT EXISTS public.genius_user_stats (
    profile_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    xp_total INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    medals JSONB DEFAULT '[]'::jsonb,
    current_theme TEXT DEFAULT 'default',
    metadata JSONB DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- System Events (Telemetry Bus)
CREATE TABLE IF NOT EXISTS public.genius_system_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID REFERENCES public.agents(id) ON DELETE SET NULL,
    system_id UUID REFERENCES public.systems(id) ON DELETE SET NULL,
    event_type TEXT NOT NULL, -- 'XP_GAIN', 'MEDAL_UNLOCKED', 'SYSTEM_AUDIT', 'UI_CHANGE'
    payload JSONB DEFAULT '{}'::jsonb,
    criticality TEXT DEFAULT 'INFO', -- 'INFO', 'WARN', 'CRITICAL'
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. TRIGGERS
-- Auto-calculate level on XP change
CREATE OR REPLACE FUNCTION public.on_xp_change()
RETURNS TRIGGER AS $$
BEGIN
    NEW.level := public.calculate_genius_level(NEW.xp_total);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_level
    BEFORE INSERT OR UPDATE OF xp_total ON public.genius_user_stats
    FOR EACH ROW
    EXECUTE FUNCTION public.on_xp_change();

-- Auto-update updated_at for stats
CREATE TRIGGER update_user_stats_updated_at
    BEFORE UPDATE ON public.genius_user_stats
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Auto-create stats when a profile is created
CREATE OR REPLACE FUNCTION public.handle_new_profile_stats()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.genius_user_stats (profile_id)
    VALUES (NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_user_stats
    AFTER INSERT ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_profile_stats();

-- 4. INDEXES
CREATE INDEX IF NOT EXISTS idx_system_events_agent_id ON public.genius_system_events(agent_id);
CREATE INDEX IF NOT EXISTS idx_system_events_event_type ON public.genius_system_events(event_type);
CREATE INDEX IF NOT EXISTS idx_system_events_created_at ON public.genius_system_events(created_at);
