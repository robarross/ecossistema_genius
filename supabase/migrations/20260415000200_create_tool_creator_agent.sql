-- Migration: 20260415000200_create_tool_creator_agent.sql
-- Objetivo: Instanciar a Agente #25 (Criadora de Ferramentas) no Ecossistema

DO $$ 
DECLARE 
    v_parent_id UUID;
BEGIN
    -- 1. Capturar ID do Pai: Criador de Agentes (#05)
    SELECT id INTO v_parent_id FROM public.agents WHERE display_id = '#05';

    -- 2. Inserir a nova Agente
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id)
    VALUES (
        '#25', 
        'Criadora de Ferramentas', 
        'Projetista de Instrumentos e Utilidades Agênticas', 
        'Super', 
        'Online', 
        v_parent_id
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        creator_id = EXCLUDED.creator_id;

    -- 3. Inserir Skills base da Agente
    INSERT INTO public.skills (agent_id, name, description)
    VALUES 
    ((SELECT id FROM public.agents WHERE display_id = '#25'), 'Design de Instrumentos', 'Capacidade de modelar ferramentas digitais úteis e simples.'),
    ((SELECT id FROM public.agents WHERE display_id = '#25'), 'Lógica de Cálculo', 'Motores matemáticos para simulação e resultados operacionais.');

    -- 4. Audit Log do Nascimento
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES ((SELECT id FROM public.agents WHERE display_id = '#25'), 'AGENT_CREATION', '{"msg": "Agente Criadora de Ferramentas instanciada pelo Criador de Agentes (#05)"}');

END $$;
