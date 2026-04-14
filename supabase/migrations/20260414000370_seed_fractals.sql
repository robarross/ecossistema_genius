-- Seeding Fractals for Identified Submodules
-- Created: 2026-04-14
-- Depends on: 20260414000330_fractals_schema.sql

DO $$ 
DECLARE 
    v_sub_fazendas_id UUID;
    v_sub_proprietarios_id UUID;
BEGIN
    -- Get Submodule UUIDs
    SELECT id INTO v_sub_fazendas_id FROM submodules WHERE display_id = 'SUB-01-03';
    SELECT id INTO v_sub_proprietarios_id FROM submodules WHERE display_id = 'SUB-01-05';

    ---------------------------------------------------------------------------
    -- Submodule: Fazendas (SUB-01-03)
    ---------------------------------------------------------------------------
    IF v_sub_fazendas_id IS NOT NULL THEN
        INSERT INTO fractals (submodule_id, display_id, name, role, folder_path, status)
        VALUES 
        (v_sub_fazendas_id, 'FRAC-01-03-01', 'Cartógrafo', 'Especialista em Georreferenciamento e Mapas', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_fazendas/2_processo/fractal_1_cartografo', 'Ready'),
        (v_sub_fazendas_id, 'FRAC-01-03-02', 'Lucro', 'Especialista em Análise de Rentabilidade e Margem', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_fazendas/2_processo/fractal_2_lucro', 'Ready'),
        (v_sub_fazendas_id, 'FRAC-01-03-03', 'Geovirtual', 'Especialista em Simulação Rápida e Gwinning Digital', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_fazendas/2_processo/fractal_3_geovirtual', 'Ready')
        ON CONFLICT (display_id) DO UPDATE SET 
            name = EXCLUDED.name,
            role = EXCLUDED.role,
            folder_path = EXCLUDED.folder_path;
    END IF;

    ---------------------------------------------------------------------------
    -- Submodule: Proprietários (SUB-01-05)
    ---------------------------------------------------------------------------
    IF v_sub_proprietarios_id IS NOT NULL THEN
        INSERT INTO fractals (submodule_id, display_id, name, role, folder_path, status)
        VALUES 
        (v_sub_proprietarios_id, 'FRAC-01-05-01', 'Holding', 'Especialista em Gestão de Patrimônio e Sociedades', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_proprietarios/processo_proprietarios/fractal_1_holding', 'Ready'),
        (v_sub_proprietarios_id, 'FRAC-01-05-02', 'Fiscal', 'Especialista em Regularidade Tributária e ITR', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_proprietarios/processo_proprietarios/fractal_2_fiscal', 'Ready'),
        (v_sub_proprietarios_id, 'FRAC-01-05-03', 'Certidões', 'Especialista em Gestão de Documentos e Certidões', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_proprietarios/processo_proprietarios/fractal_3_certidoes', 'Ready')
        ON CONFLICT (display_id) DO UPDATE SET 
            name = EXCLUDED.name,
            role = EXCLUDED.role,
            folder_path = EXCLUDED.folder_path;
    END IF;

END $$;
