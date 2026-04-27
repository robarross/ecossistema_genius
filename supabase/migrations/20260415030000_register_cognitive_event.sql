-- Migration: 20260415030000_register_cognitive_event.sql
-- Objetivo: Simular o rastro de inteligência da VERA e a entrega ao Gerente UA

DO $$ 
DECLARE 
    v_vera_id UUID;
    v_manager_ua_id UUID;
    v_extraction_data JSONB;
BEGIN
    -- 1. Capturar IDs
    SELECT id INTO v_vera_id FROM public.agents WHERE display_id = '#24';
    SELECT id INTO v_manager_ua_id FROM public.agents WHERE display_id = '#M-UA';

    -- 2. Definir Payload de Inteligência (Simulação Gemini)
    v_extraction_data := '{
        "doc_type": "Contrato de Arrendamento Rural",
        "entities": {
            "arrendador": "João da Silva",
            "arrendatário": "Agropecuária Genius Ltda",
            "fazenda": "Santa Cecília",
            "area_ha": 500,
            "valor_safra_brl": 150000.00,
            "prazo_anos": 5
        },
        "inventory": [
            {"item": "Trator John Deere 6125J", "qty": 1},
            {"item": "Colheitadeira Case IH 2566", "qty": 1},
            {"item": "Plantadeira Massey Ferguson", "qty": 2}
        ],
        "status": "Aguardando Aprovação Gerencial"
    }'::jsonb;

    -- 3. Registrar Log de Extração (VERA)
    INSERT INTO public.audit_logs (agent_id, action, details, severity)
    VALUES (v_vera_id, 'COGNITIVE_EXTRACTION', v_extraction_data, 'info');

    -- 4. Registrar Entrega ao Gerente (#M-UA)
    INSERT INTO public.audit_logs (agent_id, action, details, severity)
    VALUES (v_manager_ua_id, 'INTELLIGENCE_RECEIVED', 
        jsonb_build_object('source', 'VERA #24', 'task', 'Validar Dados de Arrendamento', 'payload', v_extraction_data), 
        'info');

END $$;
