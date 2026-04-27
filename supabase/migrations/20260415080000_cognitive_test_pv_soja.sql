-- Migration: 20260415080000_cognitive_test_pv_soja.sql
-- Objetivo: Simular a inteligência da VERA processando o contrato de insumos de Soja (PV)

DO $$ 
DECLARE 
    v_vera_id UUID;
    v_manager_pv_id UUID;
    v_tech_solo_id UUID;
    v_tech_fito_id UUID;
    v_tech_plan_id UUID;
    v_extraction_data JSONB;
BEGIN
    -- 1. Capturar IDs
    SELECT id INTO v_vera_id FROM public.agents WHERE display_id = '#24';
    SELECT id INTO v_manager_pv_id FROM public.agents WHERE display_id = '#M-PV';
    SELECT id INTO v_tech_solo_id FROM public.agents WHERE display_id = '#T-PV-SOLO';
    SELECT id INTO v_tech_fito_id FROM public.agents WHERE display_id = '#T-PV-FITO';
    SELECT id INTO v_tech_plan_id FROM public.agents WHERE display_id = '#T-PV-PLAN';

    -- 2. Payload de Inteligência (Simulação Gemini)
    v_extraction_data := '{
        "doc_type": "Compra de Insumos Agrícolas",
        "crop": "SOJA",
        "safra": "2026/27",
        "items": [
            {"item": "Sementes G-MAX", "value": 500, "un": "sacos"},
            {"item": "NPK 04-14-08", "value": 200, "un": "toneladas"},
            {"item": "Fungicida Elite", "value": 50, "un": "galões"}
        ],
        "total_brl": 850000.00,
        "delivery_deadline": "2026-09-15"
    }'::jsonb;

    -- 3. Registrar Log de Extração (VERA)
    INSERT INTO public.audit_logs (agent_id, action, details, severity)
    VALUES (v_vera_id, 'COGNITIVE_EXTRACTION', v_extraction_data, 'info');

    -- 4. Disparar no Genius Bus (Telemetria)
    INSERT INTO public.genius_system_events (agent_id, event_type, payload, criticality)
    VALUES (v_vera_id, 'XP_GAIN', jsonb_build_object('pontos', 50, 'msg', 'Extração de contrato Soja PV'), 'INFO');

    -- 5. Entrega Inteligente para o Gerente PV (#M-PV)
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_manager_pv_id, 'INTELLIGENCE_RECEIVED', 
        jsonb_build_object('source', 'VERA #24', 'task', 'Validar Compra Soja 2026/27', 'payload', v_extraction_data));

    -- 6. Notificação para os Técnicos Específicos (Distribuição Tática)
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_tech_plan_id, 'TASK_ASSIGNED', '{"task": "Planejar logística de sacaria G-MAX"}'),
           (v_tech_solo_id, 'TASK_ASSIGNED', '{"task": "Receber 200 ton NPK no depósito"}'),
           (v_tech_fito_id, 'TASK_ASSIGNED', '{"task": "Estocar 50 galões de Fungicida Elite"}');

END $$;
