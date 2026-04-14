-- Mass Seeding of Modules from mapa_de_modulos.md
-- Created: 2026-04-14
-- Depends on: 20260414000300_modules_schema.sql

DO $$ 
BEGIN
    ---------------------------------------------------------------------------
    -- CATEGORY A: Administrativo
    ---------------------------------------------------------------------------
    INSERT INTO modules (display_id, name, category, folder_path, status)
    VALUES 
    ('MOD-A-01', 'Gestão da Unidade Agrícola', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Unidade_Agricola', 'Ready'),
    ('MOD-A-02', 'Gestão Administrativa', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Administrativa', 'Ready'),
    ('MOD-A-03', 'Gestão de RH', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_RH', 'Ready'),
    ('MOD-A-04', 'Gestão Financeira', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Financeira', 'Ready'),
    ('MOD-A-05', 'Gestão Contábil', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Contabil', 'Ready'),
    ('MOD-A-06', 'Gestão Fiscal e Tributária', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Fiscal_Tributaria', 'Ready'),
    ('MOD-A-07', 'Gestão Jurídica', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Juridica', 'Ready'),
    ('MOD-A-08', 'Gestão Comercial', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Comercial', 'Ready'),
    ('MOD-A-09', 'Gestão de Compras e Suprimentos', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Compras_Suprimentos', 'Ready'),
    ('MOD-A-10', 'Gestão de Contratos', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Contratos', 'Ready'),
    ('MOD-A-11', 'Gestão da Governança', 'Administrativo', '_processo_Inteligencia/_modulos/A_Modulos_Administrativo_Corporativo/Mod_Gestao_Governanca', 'Ready')
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        folder_path = EXCLUDED.folder_path;

    ---------------------------------------------------------------------------
    -- CATEGORY B: Territorial
    ---------------------------------------------------------------------------
    INSERT INTO modules (display_id, name, category, folder_path, status)
    VALUES 
    ('MOD-B-01', 'Gestão da Regularização Fundiária', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_Regularizacao_Fundiaria', 'Ready'),
    ('MOD-B-02', 'Gestão do Georreferenciamento', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_Georreferenciamento', 'Ready'),
    ('MOD-B-03', 'Gestão do Sensoriamento Remoto', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_Sensoriamento_Remoto', 'Ready'),
    ('MOD-B-04', 'Gestão do SIG', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_SIG', 'Ready'),
    ('MOD-B-05', 'Gestão da Agricultura de Precisão', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_Agricultura_Precisao', 'Ready'),
    ('MOD-B-06', 'Gestão do Meio Ambiente', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_Meio_Ambiente', 'Ready'),
    ('MOD-B-07', 'Gestão ESG Rural', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_ESG_Rural', 'Ready'),
    ('MOD-B-08', 'Gestão de Carbono e Serviços Ambientais', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_Carbono_Servicos_Ambientais', 'Ready'),
    ('MOD-B-09', 'Gestão da Inteligência Territorial', 'Territorial', '_processo_Inteligencia/_modulos/B_Modulos_Territorial_Ambiental/Mod_Gestao_Inteligencia_Territorial', 'Ready')
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        folder_path = EXCLUDED.folder_path;

    ---------------------------------------------------------------------------
    -- CATEGORY C: Infraestrutura
    ---------------------------------------------------------------------------
    INSERT INTO modules (display_id, name, category, folder_path, status)
    VALUES 
    ('MOD-C-01', 'Gestão das Construções Rurais', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Construcoes_Rurais', 'Ready'),
    ('MOD-C-02', 'Gestão do Patrimônio', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Patrimonio', 'Ready'),
    ('MOD-C-03', 'Gestão da Manutenção', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Manutencao', 'Ready'),
    ('MOD-C-04', 'Gestão da Energia e Utilidades', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Energia_Utilidades', 'Ready'),
    ('MOD-C-05', 'Gestão da Irrigação e Drenagem', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Irrigacao_Drenagem', 'Ready'),
    ('MOD-C-06', 'Gestão dos Recursos Hídricos', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Recursos_Hidricos', 'Ready'),
    ('MOD-C-07', 'Gestão da Logística', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Logistica', 'Ready'),
    ('MOD-C-08', 'Gestão da Segurança Rural', 'Infraestrutura', '_processo_Inteligencia/_modulos/C_Modulos_Infraestrutura_Operacao/Mod_Gestao_Seguranca_Rural', 'Ready')
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        folder_path = EXCLUDED.folder_path;

    ---------------------------------------------------------------------------
    -- CATEGORY D: Tecnologico
    ---------------------------------------------------------------------------
    INSERT INTO modules (display_id, name, category, folder_path, status)
    VALUES 
    ('MOD-D-01', 'Gestão da TI & IoT Rural', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_TI_IoT_Rural', 'Ready'),
    ('MOD-D-02', 'Gestão das Integrações e APIs', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Integracoes_APIs', 'Ready'),
    ('MOD-D-03', 'Gestão dos Dashboards e BI', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Dashboards_BI', 'Ready'),
    ('MOD-D-04', 'Gestão de Dados e Data Lake', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Dados_DataLake', 'Ready'),
    ('MOD-D-05', 'Gestão de Automações', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Automacoes', 'Ready'),
    ('MOD-D-06', 'Gestão de Segurança da Informação', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Seguranca_Informacao', 'Ready'),
    ('MOD-D-07', 'Gestão Técnica-Especialista', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Tecnica_Especialista', 'Ready'),
    ('MOD-D-08', 'Gestão do Genius Hub', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Genius_Hub', 'Ready'),
    ('MOD-D-09', 'Gestão do Genius In', 'Tecnologico', '_processo_Inteligencia/_modulos/D_Modulos_Tecnologico_Inteligente/Mod_Gestao_Genius_In', 'Ready')
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        folder_path = EXCLUDED.folder_path;

    ---------------------------------------------------------------------------
    -- CATEGORY E: Produtivo
    ---------------------------------------------------------------------------
    INSERT INTO modules (display_id, name, category, folder_path, status)
    VALUES 
    ('MOD-E-01', 'Gestão da Produção Agrícola', 'Produtivo', '_processo_Inteligencia/_modulos/E_Modulos_Produtivo/Mod_Gestao_Producao_Agricola', 'Ready'),
    ('MOD-E-02', 'Gestão dos Alimentos', 'Produtivo', '_processo_Inteligencia/_modulos/E_Modulos_Produtivo/Mod_Gestao_Alimentos', 'Ready'),
    ('MOD-E-03', 'Gestão da Produção Animal', 'Produtivo', '_processo_Inteligencia/_modulos/E_Modulos_Produtivo/Mod_Gestao_Producao_Animal', 'Ready'),
    ('MOD-E-04', 'Gestão da Agroecologia', 'Produtivo', '_processo_Inteligencia/_modulos/E_Modulos_Produtivo/Mod_Gestao_Agroecologia', 'Ready'),
    ('MOD-E-05', 'Gestão Florestal', 'Produtivo', '_processo_Inteligencia/_modulos/E_Modulos_Produtivo/Mod_Gestao_Florestal', 'Ready'),
    ('MOD-E-06', 'Gestão da Pós-Colheita', 'Produtivo', '_processo_Inteligencia/_modulos/E_Modulos_Produtivo/Mod_Gestao_PosColheita', 'Ready'),
    ('MOD-E-07', 'Gestão da Agroindústria Rural', 'Produtivo', '_processo_Inteligencia/_modulos/E_Modulos_Produtivo/Mod_Gestao_Agroindustria_Rural', 'Ready')
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        folder_path = EXCLUDED.folder_path;

    ---------------------------------------------------------------------------
    -- CATEGORY F: Negocio
    ---------------------------------------------------------------------------
    INSERT INTO modules (display_id, name, category, folder_path, status)
    VALUES 
    ('MOD-F-01', 'Gestão da Plataforma Genius', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Plataforma_Genius', 'Ready'),
    ('MOD-F-02', 'Gestão de Projetos', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Projetos', 'Ready'),
    ('MOD-F-03', 'Gestão de Consultoria e Serviços', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Consultoria_Servicos', 'Ready'),
    ('MOD-F-04', 'Gestão do Instituto Escola', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Instituto_Escola', 'Ready'),
    ('MOD-F-05', 'Gestão da Biblioteca Agro', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Biblioteca_Agro', 'Ready'),
    ('MOD-F-06', 'Gestão da Comunidade Agrícola', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Comunidade_Agricola', 'Ready'),
    ('MOD-F-07', 'Gestão do Marketplace Agrícola', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Marketplace_Agricola', 'Ready'),
    ('MOD-F-08', 'Gestão do Banco Rural Genius', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Banco_Rural_Genius', 'Ready'),
    ('MOD-F-09', 'Gestão Imobiliária Rural', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Imobiliaria_Rural', 'Ready'),
    ('MOD-F-10', 'Gestão do Simulador Rural 3D', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Simulador_Rural_3D', 'Ready'),
    ('MOD-F-11', 'Gestão da Genius News Rural', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Genius_News_Rural', 'Ready'),
    ('MOD-F-12', 'Gestão da Expansão e Novos Negócios', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Expansao_NovosNegocios', 'Ready'),
    ('MOD-F-13', 'Gestão da Genius Cloud', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Genius_Cloud', 'Ready'),
    ('MOD-F-14', 'Gestão do Genius Cowork', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Genius_Cowork', 'Ready'),
    ('MOD-F-15', 'Gestão do Genius Workspace', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_Genius_Workspace', 'Ready'),
    ('MOD-F-16', 'Gestão da IA (Agentes Passivos e Ativos)', 'Negocio', '_processo_Inteligencia/_modulos/F_Modulos_Negocio_Expansao/Mod_Gestao_IA_Agentes', 'Ready')
    ON CONFLICT (display_id) DO UPDATE SET 
        name = EXCLUDED.name,
        category = EXCLUDED.category,
        folder_path = EXCLUDED.folder_path;

END $$;
