-- Migration: 20260415050000_agent_individual_xp_system.sql
-- Objetivo: Implementar o rastreamento individual de XP e Níveis para os Agentes

-- 1. ADICIONAR COLUNAS NA TABELA AGENTS
ALTER TABLE public.agents 
ADD COLUMN IF NOT EXISTS xp INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS level INTEGER DEFAULT 1;

-- 2. FUNÇÃO DE CÁLCULO DE NÍVEL (PADRÃO 1000 XP)
CREATE OR REPLACE FUNCTION public.calculate_agent_level(p_xp INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN (FLOOR(p_xp / 1000) + 1);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 3. TRIGGER PARA CRÉDITO DINÂMICO DE XP VIA GENIUS BUS
CREATE OR REPLACE FUNCTION process_agent_xp_event()
RETURNS TRIGGER AS $$
DECLARE
    v_xp_points INTEGER := 0;
BEGIN
    -- Checa se o evento é ganho de XP
    IF NEW.event_type = 'XP_GAIN' AND NEW.agent_id IS NOT NULL THEN
        
        -- Extrai a quantidade de xp_gerado do payload
        v_xp_points := (NEW.payload->>'pontos')::INTEGER;
        
        IF v_xp_points IS NOT NULL AND v_xp_points > 0 THEN
            -- Injeta o XP diretamente no Agente que disparou o evento
            UPDATE public.agents 
               SET xp = xp + v_xp_points,
                   level = public.calculate_agent_level(xp + v_xp_points),
                   updated_at = NOW()
             WHERE id = NEW.agent_id;
             
            RAISE NOTICE 'Agente % ganhou % XP. Novo Total: %', NEW.agent_id, v_xp_points, (SELECT xp FROM public.agents WHERE id = NEW.agent_id);
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. CONECTAR O TRIGGER AO BARRAMENTO
DROP TRIGGER IF EXISTS trg_agent_xp_credit ON public.genius_system_events;

CREATE TRIGGER trg_agent_xp_credit
    AFTER INSERT ON public.genius_system_events
    FOR EACH ROW
    EXECUTE FUNCTION process_agent_xp_event();

-- 5. AUDIT LOG INICIAL
INSERT INTO public.audit_logs (action, details)
VALUES ('GAMIFICATION_INFRA_ACTIVE', '{"msg": "Sistema de XP individualizado por agente ativado com sucesso."}');
