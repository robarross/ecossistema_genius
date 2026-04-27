-- Migration: 20260415000300_refine_professor_hierarchy.sql
-- Objetivo: Evoluir o Agente #12 para Super Agente Professor e ajustar a árvore genealógica

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
    v_super_professor_id UUID;
    v_modular_professor_id UUID;
BEGIN
    -- 1. Capturar IDs
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05'; -- Criador de Agentes
    SELECT id INTO v_super_professor_id FROM public.agents WHERE display_id = '#12'; -- Antiga Fábrica de Professores
    SELECT id INTO v_modular_professor_id FROM public.agents WHERE display_id = '#20'; -- Professor Modular

    -- 2. Evoluir a Identidade do #12
    UPDATE public.agents 
    SET name = 'Super Agente Professor',
        role = 'Mentor Mestre e Fábrica de Didática',
        creator_id = v_factory_agentes_id -- Vinculado ao Criador de Agentes conforme solicitado
    WHERE id = v_super_professor_id;

    -- 3. Estabelecer a Paternidade sobre os Modulares
    UPDATE public.agents 
    SET creator_id = v_super_professor_id 
    WHERE id = v_modular_professor_id;

    -- 4. Audit Log da Evolução
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_super_professor_id, 'AGENT_EVOLUTION', '{"msg": "Evolução para Super Agente Professor e ajuste de linhagem (#05 -> #12 -> #20)"}');

END $$;
