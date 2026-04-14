-- Mass Synchronization of Skills from Documentation (.md files)
-- Created: 2026-04-14
-- Depends on: 20260414000400_skills_organization.sql

DO $$ 
DECLARE 
    v_agent_id UUID;
BEGIN
    ---------------------------------------------------------------------------
    -- #01 Genius IN
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#01';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Planejamento Estratégico', 'Capacidade de definir diretrizes de alto nível para o ecossistema.', 'Estrategica', '1.0.0'),
        (v_agent_id, 'Governança Cognitiva', 'Monitoramento da evolução da inteligência do sistema.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #03 Archon
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#03';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura Meta-Agêntica', 'Design de estruturas autogovernadas e fractais.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Orquestra de Agentes', 'Gestão de interações complexas entre múltiplos agentes.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #04 Genius Systems
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#04';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Fábrica de Sistemas', 'Geração automatizada de infraestrutura SQL e arquivos.', 'Automacao', '1.0.0'),
        (v_agent_id, 'Governança de Código', 'Auditoria de integridade de scripts e migrações.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #05 Criador de Agentes
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#05';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Design de DNA', 'Criação da essência Identidade (Camadas 1-4) de um agente.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Arquitetura de Identidade', 'Definição de arquétipos e guardrails comportamentais.', 'Criacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #06 Criador de Módulos
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#06';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Geração de Código Base', 'Geração automática de estruturas fundamentais e portais visuais HTML.', 'Automacao', '1.0.0'),
        (v_agent_id, 'Orquestração Modular', 'Conexão entre diferentes módulos garantindo unidade coesa.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #07 Criador de Fractais
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#07';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Geração de Arquitetura Fractal', 'Design de micro-sistemas independentes e escaláveis.', 'Criacao', '1.0.0'),
        (v_agent_id, 'Sentinela de Integridade', 'Monitoramento de entropia e homeostase em fractais.', 'Tecnica', '1.0.0'),
        (v_agent_id, 'Fractal Marketplace', 'Gestão de reuso e publicação de componentes agênticos.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #11 Criador de Robôs
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#11';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura de RPA', 'Criação de robôs focados em automação de tarefas repetitivas.', 'Automacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #14 Criador de Secretários
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#14';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura Administrativa', 'Governança da criação de assistentes e organização de tempo.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #15 Criador de 2º Cérebro
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#15';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Escrita na Vault Pessoal', 'Materialização do pensamento agêntico em formato Obsidian.', 'Gestao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #16 Criador de ERP
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#16';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Engenharia de ERP Genius', 'Orquestração do ciclo de vida completo de sistemas de gestão rurais.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #17 Criador de Plataformas
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#17';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Arquitetura de Plataformas', 'Design de ecossistemas digitais e conectores de rede.', 'Criacao', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

    ---------------------------------------------------------------------------
    -- #18 Criador de Coda (Sistemas Relacionais)
    ---------------------------------------------------------------------------
    SELECT id INTO v_agent_id FROM agents WHERE display_id = '#18';
    IF v_agent_id IS NOT NULL THEN
        INSERT INTO skills (agent_id, name, description, category, version)
        VALUES 
        (v_agent_id, 'Modelagem Relacional Coda', 'Criação de bases de dados relacionais e painéis no Coda.', 'Tecnica', '1.0.0')
        ON CONFLICT (agent_id, name) DO UPDATE SET description = EXCLUDED.description;
    END IF;

END $$;
