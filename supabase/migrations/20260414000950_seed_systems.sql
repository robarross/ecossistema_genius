-- Seeding Initial Systems for Genius Ecosystem
-- Created: 2026-04-14
-- Depends on: 20260414000900_systems_schema.sql

DO $$ 
DECLARE 
    v_mod_id UUID;
    v_agent_id UUID;
BEGIN
    -- Get Module ID (Gestão da Unidade Agrícola)
    SELECT id INTO v_mod_id FROM modules WHERE display_id = 'MOD-A-01';
    
    -- Get Agent ID (Genius Systems #04)
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#04';

    ---------------------------------------------------------------------------
    -- Seed System: Genius Bus
    ---------------------------------------------------------------------------
    INSERT INTO public.systems (
        display_id, 
        name, 
        description, 
        type, 
        status, 
        current_stage, 
        module_id, 
        creator_agent_id,
        metadata
    )
    VALUES (
        'SYS-001', 
        'Genius Bus', 
        'Barramento Universal de Dados para telemetria, gamificação e intercomunicação agêntica.', 
        'Barramento', 
        'Idea', 
        1, -- Stage: IDEIA
        v_mod_id, 
        v_agent_id,
        jsonb_build_object(
            'prd_path', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/3_saida/genius_bus_system/prd.md',
            'ideia_path', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/3_saida/genius_bus_system/ideia.md'
        )
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        description = EXCLUDED.description,
        metadata = EXCLUDED.metadata;

END $$;
