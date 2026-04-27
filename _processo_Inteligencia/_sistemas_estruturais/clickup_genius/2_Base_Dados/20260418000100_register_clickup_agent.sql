-- Migration: 20260418000100_register_clickup_agent.sql
-- Objetivo: Instanciar o Super Agente ClickUp (#38)

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
    v_agent_id UUID;
BEGIN
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05';

    INSERT INTO public.agents (display_id, name, role, category, status, creator_id, metadata)
    VALUES (
        '#38', 
        'Super Agente ClickUp', 
        'Arquiteto de Fluxos Operacionais e Gestor de Backlog', 
        'Super', 
        'Online', 
        v_factory_agentes_id,
        jsonb_build_object(
            'mode', 'Task Orchestrator',
            'system', 'ClickUp Genius',
            'hierarchy_layer', 'Operational/Tactical'
        )
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role;

    SELECT id INTO v_agent_id FROM public.agents WHERE display_id = '#38';

    INSERT INTO public.skills (agent_id, name, description)
    VALUES 
    (v_agent_id, 'Orquestração de Backlog', 'Capacidade de decompor projetos em Tasks e Subtasks vinculadas a Fractais.'),
    (v_agent_id, 'Gestão de Checklists', 'Sincronização com o Auditor para validação de critérios de aceite.')
    ON CONFLICT DO NOTHING;

END $$;
