-- Migration: 20260415090000_fix_governance_hierarchy.sql
-- Objetivo: Reestruturar a linhagem de todos os agentes modulares e técnicos sob o Guardião (#G).
-- O Guardião passa a ser o Root do comando em cada módulo.

DO $$ 
DECLARE 
    v_guardiao_ua_id UUID;
    v_guardiao_pv_id UUID;
BEGIN
    -- 1. Capturar IDs dos Guardiões Raiz de cada Módulo
    SELECT id INTO v_guardiao_ua_id FROM public.agents WHERE display_id = '#G-UA';
    SELECT id INTO v_guardiao_pv_id FROM public.agents WHERE display_id = '#G-PV';

    -- 2. Atualizar Linhagem UA: Pesquisador, Professor, Gerente, Secretária -> Criador é o Guardião
    UPDATE public.agents 
    SET creator_id = v_guardiao_ua_id
    WHERE display_id IN ('#P-UA', '#PR-UA', '#M-UA', '#S-UA');

    -- 3. Atualizar Linhagem PV: Pesquisador, Professor, Gerente, Secretária -> Criador é o Guardião
    UPDATE public.agents 
    SET creator_id = v_guardiao_pv_id
    WHERE display_id IN ('#P-PV', '#PR-PV', '#M-PV', '#S-PV');

    -- 4. Re-centrar Submódulos Técnicos PV no Guardião (Conforme pedido pelo usuário)
    UPDATE public.agents 
    SET creator_id = v_guardiao_pv_id
    WHERE display_id LIKE '#T-PV-%';

    -- 5. Audit Log da Mudança Hierárquica Estrutural
    INSERT INTO public.audit_logs (action, details)
    VALUES ('HIERARCHY_RESTRUCTURING_COMPLETE', '{"leader": "Guardião", "status": "Centralized"}');

END $$;
