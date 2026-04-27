-- Migration: 20260415070000_spawn_full_pv_hierarchy.sql
-- Objetivo: Instanciar a rede completa do Módulo PV (10 agentes)

DO $$ 
DECLARE 
    v_arch_id UUID;
    v_sub_id UUID;
BEGIN
    -- 1. Capturar IDs dos Criadores
    SELECT id INTO v_arch_id FROM public.agents WHERE display_id = '#06';
    SELECT id INTO v_sub_id FROM public.agents WHERE display_id = '#27';

    -- 2. Inserir Pentatrilogia Modular (Governança PV) -> Creator: #06
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id)
    VALUES 
    ('#G-PV', 'agente_guardiao_modular_gestao_da_producao_vegetal', 'Guardião de Conformidade PV', 'Modular', 'Online', v_arch_id),
    ('#P-PV', 'agente_pesquisador_modular_gestao_da_producao_vegetal', 'Pesquisador de Dados PV', 'Modular', 'Online', v_arch_id),
    ('#PR-PV', 'agente_professor_modular_gestao_da_producao_vegetal', 'Professor de Manejo PV', 'Modular', 'Online', v_arch_id),
    ('#M-PV', 'agente_gerente_modular_gestao_da_producao_vegetal', 'Gerente de Produção Vegetal', 'Modular', 'Online', v_arch_id),
    ('#S-PV', 'agente_secretaria_modular_gestao_da_producao_vegetal', 'Secretária de Produção Vegetal', 'Modular', 'Online', v_arch_id)
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        creator_id = EXCLUDED.creator_id;

    -- 3. Inserir Equipe Técnica (Submódulos PV) -> Creator: #27
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id)
    VALUES 
    ('#T-PV-SOLO', 'agente_tecnico_producao_vegetal_solo', 'Técnico de Solo e Nutrição', 'Technical', 'Online', v_sub_id),
    ('#T-PV-FITO', 'agente_tecnico_producao_vegetal_fito', 'Técnico de Fitossanidade', 'Technical', 'Online', v_sub_id),
    ('#T-PV-PLAN', 'agente_tecnico_producao_vegetal_plantio', 'Técnico de Planejamento de Plantio', 'Technical', 'Online', v_sub_id),
    ('#T-PV-MONI', 'agente_tecnico_producao_vegetal_monitoramento', 'Técnico de Monitoramento e Clima', 'Technical', 'Online', v_sub_id),
    ('#T-PV-COLH', 'agente_tecnico_producao_vegetal_colheita', 'Técnico de Colheita e Rendimento', 'Technical', 'Online', v_sub_id)
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        creator_id = EXCLUDED.creator_id;

    -- 4. Audit Log de Nascimento em Lote
    INSERT INTO public.audit_logs (action, details)
    VALUES ('MASS_AGENT_SPAWN', '{"module": "Produção Vegetal", "agents_created": 10, "status": "Success"}');

END $$;
