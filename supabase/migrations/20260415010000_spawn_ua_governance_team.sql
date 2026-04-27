-- Migration: 20260415010000_spawn_ua_governance_team.sql
-- Objetivo: Instanciar a Pentatrilogia de Gestão do Módulo Unidade Agrícola (#G, #P, #PR, #M, #S)

DO $$ 
DECLARE 
    v_creator_id UUID;
    v_mod_name TEXT := 'gestao_da_unidade_agricola';
BEGIN
    -- 1. Capturar ID do Pai: Criador de Módulos (#06)
    SELECT id INTO v_creator_id FROM public.agents WHERE display_id = '#06';

    -- 2. Inserir os 5 Agentes de Governança
    INSERT INTO public.agents (display_id, name, role, category, status, creator_id)
    VALUES 
    ('#G-UA', 'agente_guardiao_modular_' || v_mod_name, 'Compliance e Segurança do Módulo UA', 'Modular', 'Online', v_creator_id),
    ('#P-UA', 'agente_pesquisador_modular_' || v_mod_name, 'Pesquisa e Inteligência do Módulo UA', 'Modular', 'Online', v_creator_id),
    ('#PR-UA', 'agente_professor_modular_' || v_mod_name, 'Treinamento e Didática do Módulo UA', 'Modular', 'Online', v_creator_id),
    ('#M-UA', 'agente_gerente_modular_' || v_mod_name, 'Comando Tático e KPI do Módulo UA', 'Modular', 'Online', v_creator_id),
    ('#S-UA', 'agente_secretaria_modular_' || v_mod_name, 'Suporte Administrativo do Módulo UA', 'Modular', 'Online', v_creator_id)
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        role = EXCLUDED.role,
        creator_id = EXCLUDED.creator_id;

    -- 3. Inserir Skills Base (Herdadas da Governança Central)
    -- Guardião
    INSERT INTO public.skills (agent_id, name, description)
    VALUES ((SELECT id FROM public.agents WHERE display_id = '#G-UA'), 'Auditoria UA', 'Monitoramento de integridade dos cadastros territoriais.')
    ON CONFLICT DO NOTHING;

    -- Gerente
    INSERT INTO public.skills (agent_id, name, description)
    VALUES ((SELECT id FROM public.agents WHERE display_id = '#M-UA'), 'Gestão de UA', 'Coordenação das tasks de registro fundiário.')
    ON CONFLICT DO NOTHING;

    -- 4. Audit Log
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_creator_id, 'GOVERNANCE_TEAM_SPAWN', jsonb_build_object('module', v_mod_name, 'agents_count', 5));

END $$;
