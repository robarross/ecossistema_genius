-- Migration: 20260415000100_fix_agent_hierarchy.sql
-- Objetivo: Organizar os vínculos de criação (creator_id) conforme a hierarquia oficial

DO $$ 
DECLARE 
    v_supreme_id UUID;
    v_root_id UUID;
    v_factory_secretaria_id UUID;
    v_factory_agentes_id UUID;
BEGIN
    -- 1. Capturar IDs de referência
    SELECT id INTO v_supreme_id FROM public.agents WHERE display_id = '#100'; -- Supervisor Supremo
    SELECT id INTO v_root_id FROM public.agents WHERE display_id = '#04'; -- Genius Systems
    SELECT id INTO v_factory_secretaria_id FROM public.agents WHERE display_id = '#14'; -- Criador de Secretários
    SELECT id INTO v_factory_agentes_id FROM public.agents WHERE display_id = '#05'; -- Criador de Agentes

    -- 2. Vincular Core Agents ao Supervisor Supremo (#100)
    UPDATE public.agents 
    SET creator_id = v_supreme_id 
    WHERE display_id IN ('#01', '#02', '#03', '#04');

    -- 3. Vincular Super Agentes (Fábricas) ao Genius Systems (#04)
    UPDATE public.agents 
    SET creator_id = v_root_id 
    WHERE display_id IN ('#05', '#06', '#07', '#08', '#09', '#10', '#11', '#12', '#13', '#14', '#15', '#16', '#17');

    -- 3. Vincular Agentes Modulares às suas respectivas fábricas
    -- VERA (#24) pertence ao Criador de Secretários (#14)
    UPDATE public.agents 
    SET creator_id = v_factory_secretaria_id 
    WHERE display_id = '#24';

    -- Gestor Agronômico (#22) pertence ao Criador de Agentes (#05) ou similar 
    UPDATE public.agents 
    SET creator_id = v_factory_agentes_id 
    WHERE display_id IN ('#22', '#23');

    -- 5. Audit Log da Reorganização
    INSERT INTO public.audit_logs (agent_id, action, details)
    VALUES (v_supreme_id, 'HIERARCHY_REORGANIZATION', '{"msg": "Genius Ecossistema estabelecido como Supervisor Supremo"}');

END $$;
