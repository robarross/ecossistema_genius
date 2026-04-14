-- Seeding Initial Utility Tools into the Registry
-- Created: 2026-04-14
-- Depends on: 20260414000380_tools_schema.sql

DO $$ 
DECLARE 
    v_sub_ativos_id UUID;
    v_sub_chaves_id UUID;
    v_sub_fazendas_id UUID;
    v_sub_glebas_id UUID;
    v_sub_proprietarios_id UUID;
    v_sub_talhoes_id UUID;
BEGIN
    -- Get Submodule UUIDs
    SELECT id INTO v_sub_ativos_id FROM submodules WHERE display_id = 'SUB-01-01';
    SELECT id INTO v_sub_chaves_id FROM submodules WHERE display_id = 'SUB-01-02';
    SELECT id INTO v_sub_fazendas_id FROM submodules WHERE display_id = 'SUB-01-03';
    SELECT id INTO v_sub_glebas_id FROM submodules WHERE display_id = 'SUB-01-04';
    SELECT id INTO v_sub_proprietarios_id FROM submodules WHERE display_id = 'SUB-01-05';
    SELECT id INTO v_sub_talhoes_id FROM submodules WHERE display_id = 'SUB-01-06';

    ---------------------------------------------------------------------------
    -- Centralized Tools Insertion
    ---------------------------------------------------------------------------
    INSERT INTO tools (submodule_id, display_id, name, description, type, folder_path, status)
    VALUES 
    (v_sub_ativos_id, 'TOOL-01-01-01', 'Validador de Matrícula', 'Verifica a integridade e formato de matrículas imobiliárias rurais.', 'Validator', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_ativos/3_saida/ferramentas_ativos.html', 'Ready'),
    
    (v_sub_chaves_id, 'TOOL-01-02-01', 'Gerador Genius ID', 'Gera identificadores únicos globais para novos registros no ecossistema.', 'Generator', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_chaves/3_saida/ferramentas_chaves.html', 'Ready'),
    
    (v_sub_fazendas_id, 'TOOL-01-03-01', 'Conversor de Hectares', 'Conversão de áreas entre Hectares, Alqueire Paulista e Mineiro.', 'Calculator', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_fazendas/3_saida/ferramentas_fazendas.html', 'Ready'),
    
    (v_sub_glebas_id, 'TOOL-01-04-01', 'Auditor de Declividade', 'Analisa a inclinação do terreno para aptidão agrícola.', 'Validator', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_glebas/3_saida/ferramentas_glebas.html', 'Ready'),
    
    (v_sub_proprietarios_id, 'TOOL-01-05-01', 'Simulador de Quotas', 'Simulação de divisão societária e quotas de capital.', 'Calculator', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_proprietarios/saida_proprietarios/ferramentas_proprietarios.html', 'Ready'),
    
    (v_sub_talhoes_id, 'TOOL-01-06-01', 'Busca de Coordenadas', 'Localização geográfica de pontos críticos no talhão.', 'Search', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola/2_processo/submodulos/sub_talhoes/3_saida/ferramentas_talhoes.html', 'Ready')
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        description = EXCLUDED.description,
        type = EXCLUDED.type,
        folder_path = EXCLUDED.folder_path;

END $$;
