-- Migration: 20260416000000_seed_initial_bus_state.sql
-- Objetivo: Garantir estado inicial do Genius Bus e instanciar perfil do Roberto

DO $$ 
DECLARE 
    v_profile_id UUID;
BEGIN
    -- 1. Pegar o ID do perfil principal (Roberto)
    SELECT id INTO v_profile_id FROM public.profiles WHERE name ILIKE '%Roberto%' LIMIT 1;

    -- 2. Garantir que o perfil tem uma entrada no User Stats
    IF v_profile_id IS NOT NULL THEN
        INSERT INTO public.genius_user_stats (profile_id, xp_total, level)
        VALUES (v_profile_id, 1250, 2) -- Começando no Nível 2 como demonstração
        ON CONFLICT (profile_id) DO NOTHING;

        -- 3. Inserir evento inicial de conexão
        INSERT INTO public.genius_system_events (agent_id, event_type, payload, criticality)
        SELECT id, 'SYSTEM_STARTUP', '{"message": "Ecossistema Genius: Industrialização do Bus Concluída"}'::jsonb, 'INFO'
        FROM public.agents WHERE display_id = '#04' LIMIT 1;
    END IF;

END $$;
