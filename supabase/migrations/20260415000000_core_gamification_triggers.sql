-- Migration: 20260415000000_core_gamification_triggers.sql
-- Objetivo: Acoplar a injeção nativa de Gamificação via Postgres Triggers

-- 1. Cria a Função que captura eventos do Bus e converte em números para o Dashboard
CREATE OR REPLACE FUNCTION process_gamification_event()
RETURNS TRIGGER AS $$
DECLARE
    v_xp_points INTEGER := 0;
    -- Por padrão, para a demonstração usaremos o User #1 (o Administrador/Gestor), 
    -- visto que a tabela events só relata "Agent", mas a pontuação vai para o gestor mestre 
    -- ou para o Perfil dono daquela unidade se estivéssemos numa multi-tenant.
    -- Vamos dar o update em todos os profiles pra fins de gamificação coletiva, 
    -- ou criar um stats se não houver. Neste MVP, damos UPDATE geral (Gamificação Corporativa Total).
BEGIN
    -- Checa se o log enviado é um ganho de XP (Secreta VERA mandou, ou qualquer outro Agente)
    IF NEW.event_type = 'XP_GAIN' THEN
        
        -- Extrai a quantidade de xp_gerado enviada dentro do JSONB usando operador ->>
        -- E converte pra INTEGER. Ex: payload: {"pontos": 150}
        v_xp_points := (NEW.payload->>'pontos')::INTEGER;
        
        IF v_xp_points IS NOT NULL AND v_xp_points > 0 THEN
            -- Injeta diretamente no Banco: atualizando xp_total de todos os usuários
            -- Na versão final você pode restringir pelo system_id ou gestor (profile_id)
            UPDATE public.genius_user_stats 
               SET xp_total = xp_total + v_xp_points,
                   updated_at = NOW();
                   
            RAISE NOTICE 'Acionado: % pontos somados no Ecossistema (Agent: %)', v_xp_points, NEW.agent_id;
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Conecta a Função (Gatilho) na tabela de Barramento (Genius Bus)
-- Deve ser AFTER INSERT porque só damos os pontos SE o log for salvo com sucesso
DROP TRIGGER IF EXISTS trg_gamification_xp_credit ON public.genius_system_events;

CREATE TRIGGER trg_gamification_xp_credit
    AFTER INSERT ON public.genius_system_events
    FOR EACH ROW
    EXECUTE FUNCTION process_gamification_event();
