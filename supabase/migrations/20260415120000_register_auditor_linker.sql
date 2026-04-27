-- Migration: 20260415120000_register_auditor_linker.sql
-- Objetivo: Instanciar o Super Agente Auditor e Linker (#36)

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
    v_agent_id UUID;
BEGIN
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05';

    INSERT INTO public.agents (display_id, name, role, category, status, creator_id, metadata)
    VALUES (
        '36', 
        'Super Agente Auditor e Linker', 
        'Escriturador de Vínculos e Auditor de Saídas', 
        'Super', 
        'Online', 
        v_factory_agentes_id,
        jsonb_build_object(
            'mode', 'Virtual Hub Linker',
            'hub_root', '_saidas_final',
            'fallback', 'Windows .lnk Shortcuts'
        )
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role;

    SELECT id INTO v_agent_id FROM public.agents WHERE display_id = '36';

    INSERT INTO public.skills (agent_id, name, description)
    VALUES (v_agent_id, 'Escrituração de Vínculos Virtuais', 'Capacidade de criar e gerir espelhos de arquivos via Symlinks ou Atalhos Windows.')
    ON CONFLICT DO NOTHING;

END $$;
