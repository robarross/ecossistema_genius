-- Seeding Business Data for Gestão da Unidade Agrícola (MOD-A-01)
-- Created: 2026-04-14
-- Depends on: 20260414000600_business_unidade_agricola_schema.sql

DO $$ 
DECLARE 
    v_prop_id UUID;
    v_faz_id UUID;
    v_glb_id UUID;
BEGIN
    ---------------------------------------------------------------------------
    -- 1. Proprietários
    ---------------------------------------------------------------------------
    INSERT INTO public.proprietarios (display_id, name, document, participation_percentage, fiscal_status)
    VALUES ('PRP-001', 'Holding Genius Agro', '12.345.678/0001-90', 100, 'Regular')
    ON CONFLICT (display_id) DO UPDATE SET name = EXCLUDED.name
    RETURNING id INTO v_prop_id;

    ---------------------------------------------------------------------------
    -- 2. Fazendas
    ---------------------------------------------------------------------------
    -- Fazenda Machadinho
    INSERT INTO public.fazendas (proprietario_id, display_id, name, total_area_ha, profit_center, status)
    VALUES (v_prop_id, 'FZD-001', 'Fazenda Machadinho', 1240.50, 'Sede / Produção', 'Online')
    ON CONFLICT (display_id) DO UPDATE SET total_area_ha = EXCLUDED.total_area_ha
    RETURNING id INTO v_faz_id;

    -- Fazenda Recanto
    INSERT INTO public.fazendas (proprietario_id, display_id, name, total_area_ha, profit_center, status)
    VALUES (v_prop_id, 'FZD-002', 'Fazenda Recanto', 850.25, 'Produção Setor Sul', 'Audição')
    ON CONFLICT (display_id) DO NOTHING;

    ---------------------------------------------------------------------------
    -- 3. Glebas (Sample for Machadinho)
    ---------------------------------------------------------------------------
    INSERT INTO public.glebas (fazenda_id, display_id, name, area_ha, soil_type, geophysical_status)
    VALUES (v_faz_id, 'GLB-01-01', 'Gleba Leste', 450.00, 'Argiloso', 'Regularizado')
    ON CONFLICT (display_id) DO UPDATE SET area_ha = EXCLUDED.area_ha
    RETURNING id INTO v_glb_id;

    ---------------------------------------------------------------------------
    -- 4. Talhões (Sample for Gleba Leste)
    ---------------------------------------------------------------------------
    INSERT INTO public.talhoes (gleba_id, display_id, name, usable_area_ha, crop_type, inventory_status)
    VALUES (v_glb_id, 'TLH-01-01-01', 'Talhão de Soja A1', 120.00, 'Soja', 'Ativo')
    ON CONFLICT (display_id) DO NOTHING;

    ---------------------------------------------------------------------------
    -- 5. Ativos Imobiliários (Sample)
    ---------------------------------------------------------------------------
    INSERT INTO public.ativos_imobiliários (fazenda_id, display_id, category, title_document, area_ha, status_vencimento)
    VALUES (v_faz_id, 'ATV-001', 'Matrícula', 'Matrícula #1234 - RI Machadinho', 1240.50, 'Válida')
    ON CONFLICT (display_id) DO NOTHING;

END $$;
