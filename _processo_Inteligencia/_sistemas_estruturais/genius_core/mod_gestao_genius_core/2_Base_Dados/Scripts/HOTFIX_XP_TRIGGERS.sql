-- =========================================================
-- HOTFIX: CORREÇÃO DOS GATILHOS DE XP
-- Ecossistema Genius
-- =========================================================

-- 1. CORREÇÃO DA FUNÇÃO DE XP DO AGENTE
CREATE OR REPLACE FUNCTION process_agent_xp_event()
RETURNS TRIGGER AS $$
DECLARE v_xp_points INTEGER := 0;
BEGIN
    IF NEW.event_type = 'XP_GAIN' AND NEW.agent_id IS NOT NULL THEN
        -- Extrai pontos garantindo que seja um número
        v_xp_points := COALESCE((NEW.payload->>'pontos')::INTEGER, 0);
        
        IF v_xp_points > 0 THEN
            UPDATE public.agents 
            SET 
                xp = COALESCE(xp, 0) + v_xp_points,
                level = FLOOR((COALESCE(xp, 0) + v_xp_points) / 1000) + 1,
                updated_at = NOW()
            WHERE id = NEW.agent_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. CORREÇÃO DA FUNÇÃO DE XP DO USUÁRIO
CREATE OR REPLACE FUNCTION process_gamification_event()
RETURNS TRIGGER AS $$
DECLARE v_xp_points INTEGER := 0;
BEGIN
    IF NEW.event_type = 'XP_GAIN' THEN
        v_xp_points := COALESCE((NEW.payload->>'pontos')::INTEGER, 0);
        
        IF v_xp_points > 0 THEN
            UPDATE public.genius_user_stats 
            SET 
                xp_total = COALESCE(xp_total, 0) + v_xp_points, 
                updated_at = NOW();
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. GARANTIR QUE OS AGENTES EXISTENTES NÃO TENHAM XP NULO
UPDATE public.agents SET xp = 0 WHERE xp IS NULL;
UPDATE public.agents SET level = 1 WHERE level IS NULL;
