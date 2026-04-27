-- Migration: 20260415100000_register_librarian_agent.sql
-- Objetivo: Instanciar o Super Agente Bibliotecário (#35) no ecossistema

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
    v_agent_id UUID;
BEGIN
    -- 1. Capturar ID do Pai: Criador de Agentes (#05)
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05';

    -- 2. Inserir Super Agente Bibliotecário (#35)
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id, metadata)
    VALUES (
        '35', 
        'Super Agente Bibliotecário', 
        'Gestor de Ativos de Conhecimento e Indexador', 
        'Super', 
        'Online', 
        v_factory_agentes_id,
        jsonb_build_object(
            'specialization', 'DMS / LMS / Taxonomia',
            'monitoring_path', '_DIFUSAO_CONHECIMENTO_DRAFT',
            'metadata_format', '.json',
            'intelligence_model', 'Gemini 1.5 Pro'
        )
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        metadata = public.agents.metadata || EXCLUDED.metadata;

    SELECT id INTO v_agent_id FROM public.agents WHERE display_id = '35';

    -- 3. Inserir Skill Base
    INSERT INTO public.skills (agent_id, name, description)
    VALUES (v_agent_id, 'Gestão de Ativos de Conhecimento', 'Capacidade de categorizar, resumir e indexar documentos técnicos e operacionais.')
    ON CONFLICT DO NOTHING;

    -- 4. Audit Log
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_agent_id, 'LIBRARIAN_CORE_ACTIVATED', '{"msg": "Agente #35 pronto para gerir a memória do ecossistema."}');

END $$;
