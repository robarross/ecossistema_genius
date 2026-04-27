-- Migration: 20260415060000_register_communication_agent.sql
-- Objetivo: Instanciar o Super Agente de Comunicação (#30) e configurar segurança extraterritorial

DO $$ 
DECLARE 
    v_factory_agentes_id UUID;
    v_agent_id UUID;
BEGIN
    -- 1. Capturar ID do Pai: Criador de Agentes (#05)
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05';

    -- 2. Inserir Super Agente de Comunicação (#30)
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id, metadata)
    VALUES (
        '#30', 
        'Super Agente de Comunicação', 
        'Broker de Mensageria e Interface Extraterritorial', 
        'Super', 
        'Online', 
        v_factory_agentes_id,
        jsonb_build_object(
            'platform', 'Telegram',
            'api_version', 'Bot API 6.0+',
            'allowed_telegram_id', 'REPLACE_WITH_YOUR_ID', -- O usuário deve atualizar no dashboard
            'intelligence_model', 'Gemini 1.5 Flash'
        )
    )
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        metadata = public.agents.metadata || EXCLUDED.metadata;

    SELECT id INTO v_agent_id FROM public.agents WHERE display_id = '#30';

    -- 3. Inserir Skill Base
    INSERT INTO public.skills (agent_id, name, description)
    VALUES (v_agent_id, 'Protocolo de Mensageria Externa', 'Integração de notificações e comandos via Telegram.')
    ON CONFLICT DO NOTHING;

    -- 4. Audit Log
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_agent_id, 'COMMUNICATION_BROKER_READY', '{"msg": "Agente #30 pronto para estabelecer ponte extraterritorial."}');

END $$;
