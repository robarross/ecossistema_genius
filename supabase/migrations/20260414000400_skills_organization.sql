-- Skills SQL Refactoring and Seeding
-- Created: 2026-04-14
-- Depends on: 20260413000100_core_schema.sql

-- 1. ENUMS
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'skill_category_type') THEN
        CREATE TYPE skill_category_type AS ENUM (
            'Academica',
            'Analise', 
            'Automacao', 
            'Cognitiva',
            'Comunicacao', 
            'Criacao',
            'Didatica',
            'Estrategica',
            'Gestao', 
            'Governanca',
            'Marketing',
            'Midia',
            'Proatividade',
            'Seguranca',
            'Tecnica'
        );
    END IF;
END $$;

-- 2. ALTER TABLE
-- Adding new columns to existing skills table
DO $$ 
BEGIN
    -- Add category column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'skills' AND column_name = 'category') THEN
        ALTER TABLE skills ADD COLUMN category skill_category_type DEFAULT 'Tecnica';
    END IF;

    -- Add status column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'skills' AND column_name = 'status') THEN
        ALTER TABLE skills ADD COLUMN status TEXT DEFAULT 'Active';
    END IF;

    -- Add metadata column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'skills' AND column_name = 'metadata') THEN
        ALTER TABLE skills ADD COLUMN metadata JSONB DEFAULT '{}'::jsonb;
    END IF;

    -- Add updated_at column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'skills' AND column_name = 'updated_at') THEN
        ALTER TABLE skills ADD COLUMN updated_at TIMESTAMPTZ DEFAULT now();
    END IF;
END $$;

-- 3. TRIGGERS
-- Auto-update updated_at for skills
DROP TRIGGER IF EXISTS update_skills_updated_at ON skills;
CREATE TRIGGER update_skills_updated_at
    BEFORE UPDATE ON skills
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 4. SEED DATA (Skills for Core and Super Agents)
DO $$ 
DECLARE 
    v_agent_id UUID;
BEGIN
    -- Skills for #01 Genius IN
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#01';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Planejamento Estratégico', 'Capacidade de definir diretrizes de alto nível para o ecossistema.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Governança Cognitiva', 'Monitoramento da evolução da inteligência do sistema.', 'Gestao', '1.0.0')
        ON CONFLICT DO NOTHING;
    END IF;

    -- Skills for #03 Archon
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#03';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura Meta-Agêntica', 'Design de estruturas autogovernadas e fractais.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Orquestra de Agentes', 'Gestão de interações complexas entre múltiplos agentes.', 'Gestao', '1.0.0')
        ON CONFLICT DO NOTHING;
    END IF;

    -- Skills for #04 Genius Systems
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#04';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Fábrica de Sistemas', 'Geração automatizada de infraestrutura SQL e arquivos.', 'Automacao', '1.0.0')
        ON CONFLICT DO NOTHING;
    END IF;

    -- Skills for #05 Criador de Agentes
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#05';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Design de DNA', 'Criação da essência Identidade (Camadas 1-4) de um agente.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Arquitetura de Identidade', 'Definição de arquétipos e guardrails comportamentais.', 'Criacao', '1.0.0')
        ON CONFLICT DO NOTHING;
    END IF;

    -- Skills for #16 Criador de ERP
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#16';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Modelagem de Processos', 'Tradução de necessidades de negócio em fluxos sistêmicos.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Arquitetura de Sistemas Rurais', 'Especialização em banco de dados para o agronegócio.', 'Tecnica', '1.0.0')
        ON CONFLICT DO NOTHING;
    END IF;

END $$;
