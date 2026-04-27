-- Migration: 20260415020000_create_bi_factory_agents.sql
-- Objetivo: Instanciar as Fábricas de BI (#28 e #29) sob o Criador de Agentes (#05)

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
BEGIN
    -- 1. Capturar ID do Pai: Criador de Agentes (#05)
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05';

    -- 2. Inserir Criador de Dashboards (#28)
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id)
    VALUES (
        '#28', 
        'Criador de Dashboards', 
        'Projetista de Interfaces Visuais e Conectores de Dados', 
        'Super', 
        'Online', 
        v_factory_agentes_id
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        creator_id = EXCLUDED.creator_id;

    -- 3. Inserir Criador de KPIs (#29)
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id)
    VALUES (
        '#29', 
        'Criador de KPIs', 
        'Projetista de Métricas e Lógica de Performance', 
        'Super', 
        'Online', 
        v_factory_agentes_id
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        creator_id = EXCLUDED.creator_id;

    -- 4. Inserir Skills Base
    INSERT INTO public.skills (agent_id, name, description)
    VALUES 
    ((SELECT id FROM public.agents WHERE display_id = '#28'), 'Design Visual Genius', 'Estética premium HTML/CSS/JS.'),
    ((SELECT id FROM public.agents WHERE display_id = '#28'), 'Data Connector', 'Exportação de dados para BI externo.'),
    ((SELECT id FROM public.agents WHERE display_id = '#29'), 'Engenharia de KPI', 'Modelagem matemática de performance agrícola.');

    -- 5. Audit Log
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_factory_agentes_id, 'BI_FACTORY_ACTIVATION', '{"msg": "Fábricas de BI (#28 e #29) ativadas sob comando do #05"}');

END $$;
