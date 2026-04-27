-- Migration: 20260415130000_register_portaria_agent.sql
-- Objetivo: Instanciar o Super Agente de Portaria (#37)

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
    v_agent_id UUID;
BEGIN
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05';

    INSERT INTO public.agents (display_id, name, role, category, status, creator_id, metadata)
    VALUES (
        '37', 
        'Super Agente de Portaria', 
        'Gestor de Recepção e Triagem de Entrada', 
        'Super', 
        'Online', 
        v_factory_agentes_id,
        jsonb_build_object(
            'mode', 'Virtual Gate Keeper',
            'inbox_root', '_entrada_inical',
            'fallback', 'Windows .lnk Shortcuts'
        )
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role;

    SELECT id INTO v_agent_id FROM public.agents WHERE display_id = '37';

    INSERT INTO public.skills (agent_id, name, description)
    VALUES (v_agent_id, 'Triagem e Roteamento Virtual', 'Capacidade de recepcionar arquivos crus e encaminhá-los via espelhamento para os módulos corretos.')
    ON CONFLICT DO NOTHING;

END $$;
