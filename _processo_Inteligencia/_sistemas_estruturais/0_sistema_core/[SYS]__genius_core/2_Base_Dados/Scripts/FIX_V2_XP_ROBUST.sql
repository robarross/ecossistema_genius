-- =========================================================
-- FIX V2: GATILHOS DE XP ROBUSTOS (TRY/CATCH)
-- Ecossistema Genius
-- =========================================================

CREATE OR REPLACE FUNCTION process_agent_xp_event()
RETURNS TRIGGER AS $$
DECLARE 
    v_xp_points INTEGER := 0;
BEGIN
    -- Se não for ganho de XP ou não tiver agente, ignora silenciosamente
    IF NEW.event_type != 'XP_GAIN' OR NEW.agent_id IS NULL THEN
        RETURN NEW;
    END IF;

    BEGIN
        -- Tenta extrair os pontos do JSON
        v_xp_points := (NEW.payload->>'pontos')::INTEGER;
        
        IF v_xp_points > 0 THEN
            UPDATE public.agents 
            SET 
                xp = COALESCE(xp, 0) + v_xp_points,
                level = FLOOR((COALESCE(xp, 0) + v_xp_points) / 1000) + 1,
                updated_at = NOW()
            WHERE id = NEW.agent_id;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        -- Em caso de erro (ex: pontos não é número), apenas ignora para não travar a inserção
        RETURN NEW;
    END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION process_gamification_event()
RETURNS TRIGGER AS $$
DECLARE 
    v_xp_points INTEGER := 0;
BEGIN
    IF NEW.event_type != 'XP_GAIN' THEN
        RETURN NEW;
    END IF;

    BEGIN
        v_xp_points := (NEW.payload->>'pontos')::INTEGER;
        
        IF v_xp_points > 0 THEN
            UPDATE public.genius_user_stats 
            SET 
                xp_total = COALESCE(xp_total, 0) + v_xp_points, 
                updated_at = NOW();
        END IF;
    EXCEPTION WHEN OTHERS THEN
        RETURN NEW;
    END;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
