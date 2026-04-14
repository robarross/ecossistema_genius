-- Seeding Submodules for MOD-A-01 (Gestão da Unidade Agrícola)
-- Created: 2026-04-14
-- Depends on: 20260414000320_submodules_schema.sql

DO $$ 
DECLARE 
    v_module_id UUID;
BEGIN
    -- Get the UUID of MOD-A-01
    SELECT id INTO v_module_id FROM modules WHERE display_id = 'MOD-A-01';

    IF v_module_id IS NOT NULL THEN
        INSERT INTO submodules (module_id, display_id, name, folder_path, status)
        VALUES 
        (v_module_id, 'SUB-01-01', 'Ativos', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_ativos', 'Ready'),
        (v_module_id, 'SUB-01-02', 'Chaves', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_chaves', 'Ready'),
        (v_module_id, 'SUB-01-03', 'Fazendas', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_fazendas', 'Ready'),
        (v_module_id, 'SUB-01-04', 'Glebas', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_glebas', 'Ready'),
        (v_module_id, 'SUB-01-05', 'Proprietários', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_proprietarios', 'Ready'),
        (v_module_id, 'SUB-01-06', 'Talhões', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_talhoes', 'Ready')
        ON CONFLICT (display_id) DO UPDATE SET 
            name = EXCLUDED.name,
            folder_path = EXCLUDED.folder_path,
            module_id = EXCLUDED.module_id;
    END IF;

END $$;
