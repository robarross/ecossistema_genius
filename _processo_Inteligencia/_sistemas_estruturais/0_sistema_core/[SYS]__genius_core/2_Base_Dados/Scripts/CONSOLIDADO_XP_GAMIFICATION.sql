-- =========================================================
-- SCRIPT CONSOLIDADO: INFRAESTRUTURA DE SISTEMAS, PERFIS E XP
-- Ecossistema Genius - Célula 0 (Versão Corrigida)
-- =========================================================

-- 1. ESTRUTURA BÁSICA DE PERFIS (PROFILES)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE,
    full_name TEXT,
    role TEXT DEFAULT 'User',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. ESTRUTURA BÁSICA DE SISTEMAS (SYSTEMS)
CREATE TABLE IF NOT EXISTS public.systems (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. FUNÇÕES DE NÍVEL
CREATE OR REPLACE FUNCTION public.calculate_genius_level(xp INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN (FLOOR(xp / 1000) + 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 4. TABELA DE ESTATÍSTICAS DE USUÁRIOS
CREATE TABLE IF NOT EXISTS public.genius_user_stats (
    profile_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
    xp_total INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    medals JSONB DEFAULT '[]'::jsonb,
    current_theme TEXT DEFAULT 'default',
    metadata JSONB DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 5. BARRAMENTO DE EVENTOS DO SISTEMA (GENIUS BUS)
CREATE TABLE IF NOT EXISTS public.genius_system_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID REFERENCES public.agents(id) ON DELETE SET NULL,
    system_id UUID REFERENCES public.systems(id) ON DELETE SET NULL,
    event_type TEXT NOT NULL, -- 'XP_GAIN', 'MEDAL_UNLOCKED', etc.
    payload JSONB DEFAULT '{}'::jsonb,
    criticality TEXT DEFAULT 'INFO',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. ATUALIZAÇÃO DA TABELA DE AGENTES (XP INDIVIDUAL)
ALTER TABLE public.agents 
ADD COLUMN IF NOT EXISTS xp INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS level INTEGER DEFAULT 1;

-- 7. TRIGGER: ATUALIZAR XP DO USUÁRIO
CREATE OR REPLACE FUNCTION process_gamification_event()
RETURNS TRIGGER AS $$
DECLARE v_xp_points INTEGER := 0;
BEGIN
    IF NEW.event_type = 'XP_GAIN' THEN
        v_xp_points := (NEW.payload->>'pontos')::INTEGER;
        IF v_xp_points IS NOT NULL AND v_xp_points > 0 THEN
            -- Update user stats if they exist
            UPDATE public.genius_user_stats SET xp_total = xp_total + v_xp_points, updated_at = NOW();
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_gamification_xp_credit ON public.genius_system_events;
CREATE TRIGGER trg_gamification_xp_credit AFTER INSERT ON public.genius_system_events FOR EACH ROW EXECUTE FUNCTION process_gamification_event();

-- 8. TRIGGER: ATUALIZAR XP DO AGENTE
CREATE OR REPLACE FUNCTION process_agent_xp_event()
RETURNS TRIGGER AS $$
DECLARE v_xp_points INTEGER := 0;
BEGIN
    IF NEW.event_type = 'XP_GAIN' AND NEW.agent_id IS NOT NULL THEN
        v_xp_points := (NEW.payload->>'pontos')::INTEGER;
        IF v_xp_points IS NOT NULL AND v_xp_points > 0 THEN
            UPDATE public.agents SET xp = xp + v_xp_points, level = (FLOOR((xp + v_xp_points) / 1000) + 1), updated_at = NOW() WHERE id = NEW.agent_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_agent_xp_credit ON public.genius_system_events;
CREATE TRIGGER trg_agent_xp_credit AFTER INSERT ON public.genius_system_events FOR EACH ROW EXECUTE FUNCTION process_agent_xp_event();

-- 9. LOG DE ATIVAÇÃO
INSERT INTO public.audit_logs (action, details) VALUES ('GAMIFICATION_INFRA_ACTIVE', '{"msg": "Sistema de XP e Gamificação ativado com sucesso."}');
