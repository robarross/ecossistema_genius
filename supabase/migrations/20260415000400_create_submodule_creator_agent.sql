-- Migration: 20260415000400_create_submodule_creator_agent.sql
-- Objetivo: Instanciar a Agente #27 e redefinir a linhagem do Arquiteto #06

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
    v_factory_modulos_id UUID;
    v_target_submodulo_id UUID;
BEGIN
    -- 1. Capturar IDs de referência
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05'; -- Criador de Agentes
    SELECT id INTO v_factory_modulos_id FROM public.agents WHERE display_id = '#06'; -- Criador de Módulos

    -- 2. Atualizar o #06 para ser filho do #05 (Linhagem Técnica)
    UPDATE public.agents 
    SET creator_id = v_factory_agentes_id 
    WHERE id = v_factory_modulos_id;

    -- 3. Inserir a nova Agente #27 subordinada ao #06
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id)
    VALUES (
        '#27', 
        'Criadora de Submódulos', 
        'Projetista Fractal de Sub-estruturas Técnicas', 
        'Super', 
        'Online', 
        v_factory_modulos_id
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        creator_id = EXCLUDED.creator_id;

    -- 4. Inserir Skills da #27
    SELECT id INTO v_target_submodulo_id FROM public.agents WHERE display_id = '#27';
    
    INSERT INTO public.skills (agent_id, name, description)
    VALUES 
    (v_target_submodulo_id, 'Provisionamento de Pastas', 'Geração automática da estrutura 1_entrada, 2_processo, 3_saida.'),
    (v_target_submodulo_id, 'Fractalização Estrutural', 'Decomposição de sistemas complexos em unidades menores funcionais.');

    -- 5. Audit Log
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_target_submodulo_id, 'AGENT_SPECIALIZATION', '{"msg": "Descentralização do #06 efetuada. #27 instanciada como especialista fractal."}');

END $$;
