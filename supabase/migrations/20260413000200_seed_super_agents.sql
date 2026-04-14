-- Seed Data: Super Agentes (#05 to #18)
-- Creator: #04 Genius Systems
-- Created: 2026-04-13

DO $$ 
DECLARE 
    v_creator_id UUID;
BEGIN
    -- Get the UUID of Genius Systems (#04)
    SELECT id INTO v_creator_id FROM agents WHERE display_id = '#04';

    -- Insert Super Agentes
    INSERT INTO agents (display_id, name, role, category, status, creator_id)
    VALUES 
    ('#05', 'Criador de Agentes', 'Projetista de Identidades e DNAs', 'Super', 'Online', v_creator_id),
    ('#06', 'Criador de Módulos', 'Projetista de Estruturas Modulares', 'Super', 'Online', v_creator_id),
    ('#07', 'Criador de Fractais', 'Projetista de Escala e Micro-SaaS', 'Super', 'Online', v_creator_id),
    ('#08', 'Criador de Gerentes', 'Fábrica de Supervisores Operacionais', 'Super', 'Online', v_creator_id),
    ('#09', 'Criador de Diretores', 'Fábrica de Gestão Executiva', 'Super', 'Online', v_creator_id),
    ('#10', 'Criador de Técnicos', 'Fábrica de Executores de Procedimentos', 'Super', 'Online', v_creator_id),
    ('#11', 'Criador de Robôs', 'Fábrica de Automações e RPA', 'Super', 'Online', v_creator_id),
    ('#12', 'Criador de Professores', 'Fábrica de Didática e Treinamento', 'Super', 'Online', v_creator_id),
    ('#13', 'Criador de Gestores', 'Fábrica de Gestão de Conhecimento', 'Super', 'Online', v_creator_id),
    ('#14', 'Criador de Secretários', 'Fábrica de Apoio Administrativo', 'Super', 'Online', v_creator_id),
    ('#15', 'Criador de 2º Cérebro', 'Fábrica de Memória e Obsidian', 'Super', 'Online', v_creator_id),
    ('#16', 'Criador de ERP', 'Fábrica de Sistemas de Gestão', 'Super', 'Online', v_creator_id),
    ('#17', 'Criador de Plataformas', 'Fábrica de Ecossistemas Digitais', 'Super', 'Online', v_creator_id),
    ('#18', 'Lançador', 'Especialista em Lançamentos e Marketing Digital', 'Modular', 'Online', v_creator_id),
    ('#19', 'Inventor', 'Especialista em P&D e Novas Tecnologias', 'Modular', 'Online', v_creator_id),
    ('#20', 'Professor', 'Especialista em Didática e Treinamento', 'Modular', 'Online', v_creator_id),
    ('#21', 'Gestor de Marketing', 'Especialista em Estratégias de Mercado', 'Modular', 'Online', v_creator_id),
    ('#22', 'Gestor Agronômico', 'Especialista em Gestão de Produção Rural', 'Modular', 'Online', v_creator_id),
    ('#23', 'Técnico em Solo e Nutrição', 'Especialista em Fertilidade e Solo', 'Modular', 'Online', v_creator_id),
    ('#24', 'Secretaria de Gestão Administrativa', 'Apoio Administrativo e Processos', 'Modular', 'Online', v_creator_id)
    ON CONFLICT (display_id) DO NOTHING;

END $$;
