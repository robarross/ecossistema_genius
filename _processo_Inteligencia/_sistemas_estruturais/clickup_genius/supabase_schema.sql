-- ESQUEMA COMPLETO: CLICKUP GENIUS INDUSTRIAL
-- Rode este script no SQL Editor do Supabase

-- 1. TABELAS DE HIERARQUIA
CREATE TABLE IF NOT EXISTS clickup_workspaces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS clickup_spaces (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workspace_id UUID REFERENCES clickup_workspaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS clickup_folders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    space_id UUID REFERENCES clickup_spaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS clickup_lists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    folder_id UUID REFERENCES clickup_folders(id) ON DELETE CASCADE,
    space_id UUID REFERENCES clickup_spaces(id) ON DELETE CASCADE, -- Fallback se não houver folder
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABELA DE AGENTES
CREATE TABLE IF NOT EXISTS clickup_agents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    display_id TEXT UNIQUE, -- Ex: #01, #05
    avatar_url TEXT,
    skills TEXT[],
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABELA DE TAREFAS
CREATE TABLE IF NOT EXISTS clickup_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    list_id UUID REFERENCES clickup_lists(id) ON DELETE CASCADE,
    agent_id UUID REFERENCES clickup_agents(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'A Fazer',
    priority TEXT DEFAULT 'Normal',
    start_date DATE,
    due_date DATE,
    knowledge_link TEXT, -- Link para Obsidian
    task_xp INTEGER DEFAULT 100,
    modulo TEXT,
    submodulo TEXT,
    fractal TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. TABELA DE CHECKLISTS
CREATE TABLE IF NOT EXISTS clickup_checklists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES clickup_tasks(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. VIEW ENRIQUECIDA (Para performance no Frontend)
DROP VIEW IF EXISTS v_clickup_tasks_enhanced CASCADE;
CREATE OR REPLACE VIEW v_clickup_tasks_enhanced AS
SELECT 
    t.*,
    a.name as agent_name,
    a.display_id as agent_display_id,
    a.avatar_url as agent_avatar_url,
    l.name as list_name,
    f.name as folder_name,
    s.name as space_name,
    w.name as workspace_name,
    (SELECT count(*) FROM clickup_checklists WHERE task_id = t.id) as checklist_count,
    (SELECT count(*) FROM clickup_checklists WHERE task_id = t.id AND is_completed = true) as checklist_completed_count
FROM clickup_tasks t
LEFT JOIN clickup_agents a ON t.agent_id = a.id
LEFT JOIN clickup_lists l ON t.list_id = l.id
LEFT JOIN clickup_folders f ON l.folder_id = f.id
LEFT JOIN clickup_spaces s ON l.space_id = s.id OR f.space_id = s.id
LEFT JOIN clickup_workspaces w ON s.workspace_id = w.id;

-- 6. INFRAESTRUTURA HARNESS (Orquestração)
DROP TABLE IF EXISTS harness_chat_executions CASCADE;
DROP TABLE IF EXISTS harness_pipelines CASCADE;
DROP TABLE IF EXISTS harness_skills CASCADE;
DROP TABLE IF EXISTS harness_connectors CASCADE;
DROP TABLE IF EXISTS harness_guardrails CASCADE;

CREATE TABLE IF NOT EXISTS harness_skills (
    id TEXT PRIMARY KEY,
    agent_id TEXT REFERENCES clickup_agents(display_id),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    config JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS harness_pipelines (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    steps JSONB, -- Sequência de ações/agentes
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS harness_chat_executions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID REFERENCES clickup_tasks(id) ON DELETE CASCADE,
    pipeline_id TEXT REFERENCES harness_pipelines(id),
    status TEXT DEFAULT 'running', -- running, completed, failed
    logs JSONB,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS harness_connectors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type TEXT, -- 'webhook', 'api', 'db'
    config JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS harness_guardrails (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    rule_type TEXT,
    criteria JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- SEED: AGENTES CORE (HARNESS)
INSERT INTO clickup_agents (name, display_id, avatar_url, skills) 
VALUES 
('Atlas', '#Atlas', 'https://api.dicebear.com/7.x/bottts/svg?seed=Atlas', ARRAY['Pesquisa', 'RAG', 'Knowledge']),
('Echo', '#Echo', 'https://api.dicebear.com/7.x/bottts/svg?seed=Echo', ARRAY['Comunicação', 'Notificação', 'Feedback']),
('Sage', '#Sage', 'https://api.dicebear.com/7.x/bottts/svg?seed=Sage', ARRAY['Análise', 'Crítica', 'Otimização']),
('Flow', '#Flow', 'https://api.dicebear.com/7.x/bottts/svg?seed=Flow', ARRAY['Automação', 'Workflow', 'Pipeline']),
('Agente #30', '#30', 'https://api.dicebear.com/7.x/bottts/svg?seed=30', ARRAY['Telegram', 'Interface', 'Input']),
('CEO Genius', '#CEO-01', 'https://api.dicebear.com/7.x/bottts/svg?seed=CEO', ARRAY['Estratégia', 'Decisão', 'Decreto']),
('CFO Genius', '#CFO-01', 'https://api.dicebear.com/7.x/bottts/svg?seed=CFO', ARRAY['Financeiro', 'ROI', 'Eficiência'])
ON CONFLICT (display_id) DO UPDATE 
SET name = EXCLUDED.name, skills = EXCLUDED.skills;

-- 12. Skill #Atlas: Pesquisa e RAG (Conexão Segundo Cérebro)
INSERT INTO harness_skills (id, agent_id, name, description, config)
VALUES (
    'skill-atlas-research',
    '#Atlas',
    'Contextual Research',
    'Busca semântica e leitura de fractais no Segundo Cérebro (Obsidian).',
    jsonb_build_object(
        'vault_path', 'e:/Diretorios/Diretorio_Agentes',
        'index_mode', 'semantic',
        'allowed_folders', ARRAY['_processo_Inteligencia', '_sistemas_estruturais']
    )
) ON CONFLICT (id) DO NOTHING;

-- Tabela para Simular o Índice de Conhecimento (RAG Index)
CREATE TABLE IF NOT EXISTS harness_knowledge_index (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    path TEXT NOT NULL,
    content_preview TEXT,
    last_indexed TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    embedding_status TEXT DEFAULT 'pending'
);

-- Seed de exemplo para o índice do Atlas
INSERT INTO harness_knowledge_index (title, path, content_preview)
VALUES 
('Arquitetura Harness', 'arquitetura_harness.md', 'Fluxo de orquestração entre agentes core...'),
('DNA Agentes', '4_Agentes/DNA_Core_Agents.md', 'Definição de papéis e responsabilidades dos especialistas...'),
('Manual de Industrialização', 'README.md', 'Guia para expansão modular do ecossistema...'),
('Workflow: Criação de Sistemas', '5_Metodologia/workflow_criacao_sistemas.md', 'Checklist estratégico para novos módulos...'),
('Pipeline: Criação de Sistemas', '5_Metodologia/pipeline_criacao_sistemas.md', 'Esteira agentica de produção de software...')
ON CONFLICT DO NOTHING;

-- 13. Skill #Sage: Auditoria Crítica e Guardrails
INSERT INTO harness_skills (id, agent_id, name, description, config)
VALUES (
    'skill-sage-audit',
    '#Sage',
    'Critical Audit',
    'Validação de outputs com base em contratos de conformidade e guardrails.',
    jsonb_build_object(
        'check_modes', ARRAY['syntactic', 'semantic', 'compliance'],
        'auto_reject', true
    )
) ON CONFLICT (id) DO NOTHING;

-- Definindo Guardrails (Critérios de Qualidade)
INSERT INTO harness_guardrails (id, name, description, rule_type, criteria)
VALUES 
(
    'gr-non-redundancy',
    'Lei da Não-Redundância',
    'Garante que a tarefa não cria informações ou arquivos já existentes no ecossistema.',
    'compliance',
    jsonb_build_object('check_knowledge_base', true, 'threshold', 0.8)
),
(
    'gr-modular-standard',
    'Padrão Modular LEGO',
    'Valida se o output segue a estrutura 0-IN, 1-DNA, 2-OUT, 3-LIB.',
    'structural',
    jsonb_build_object('required_sections', ARRAY['IN', 'DNA', 'OUT', 'LIB'])
),
(
    'gr-operational-clarity',
    'Clareza Operacional',
    'Verifica se a tarefa possui descrição clara e checklist de execução.',
    'semantic',
    jsonb_build_object('min_words', 20, 'require_checklist', true)
) ON CONFLICT (id) DO NOTHING;

-- Ativar Realtime para todas as tabelas relevantes
DO $$
BEGIN
    -- Tabelas ClickUp
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'clickup_tasks') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE clickup_tasks;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'clickup_checklists') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE clickup_checklists;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'clickup_workspaces') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE clickup_workspaces;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'clickup_lists') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE clickup_lists;
    END IF;
    -- Tabelas Harness
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'harness_chat_executions') THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE harness_chat_executions;
    END IF;
END $$;


-- 14. Skill #Flow: Orquestração e Sequenciamento
INSERT INTO harness_skills (id, agent_id, name, description, config)
VALUES (
    'skill-flow-chaining',
    '#Flow',
    'Pipeline Chaining',
    'Capacidade de encadear tarefas entre múltiplos agentes especialistas.',
    jsonb_build_object('max_nodes', 10, 'retry_strategy', 'exponential_backoff')
) ON CONFLICT (id) DO NOTHING;

-- 15. Skill #Echo: Feedback e Notificação
INSERT INTO harness_skills (id, agent_id, name, description, config)
VALUES (
    'skill-echo-notification',
    '#Echo',
    'Feedback & Reporting',
    'Geração de relatórios de auditoria e notificações de status de pipeline.',
    jsonb_build_object('channels', ARRAY['ui_console', 'telegram_proxy'], 'report_format', 'markdown')
) ON CONFLICT (id) DO NOTHING;

-- 16. Definindo o Pipeline 'Digital Harvest 1.0' (Fluxo End-to-End)
INSERT INTO harness_pipelines (id, name, description, steps)
VALUES (
    'pl-digital-harvest-1.0',
    'Safra Digital 1.0',
    'Fluxo completo: Pesquisa (#Atlas) -> Auditoria (#Sage) -> Notificação (#Echo).',
    jsonb_build_array(
        jsonb_build_object('step', 1, 'agent', '#Atlas', 'action', 'context_retrieval'),
        jsonb_build_object('step', 2, 'agent', '#Sage', 'action', 'quality_audit'),
        jsonb_build_object('step', 3, 'agent', '#Echo', 'action', 'delivery_report')
    )
) ON CONFLICT (id) DO NOTHING;

-- 16.5 Definindo o Pipeline 'Review Standard' (Gatilho de Tarefas)
INSERT INTO harness_pipelines (id, name, description, steps)
VALUES (
    'pl-review-standard',
    'Auditoria Padrão',
    'Audita uma tarefa que foi movida para Em Revisão.',
    jsonb_build_array(
        jsonb_build_object('step', 1, 'agent', '#Sage', 'action', 'compliance_check')
    )
) ON CONFLICT (id) DO NOTHING;

-- 16.6 Definindo o Pipeline 'Executive Governance' (Revisão Estratégica)
INSERT INTO harness_pipelines (id, name, description, steps)
VALUES (
    'pl-executive-governance',
    'Governança Executiva',
    'Analisa resultados semanais (#CEO) e otimiza custos/eficiência (#CFO).',
    jsonb_build_array(
        jsonb_build_object('step', 1, 'agent', '#CEO-01', 'action', 'strategic_review'),
        jsonb_build_object('step', 2, 'agent', '#CFO-01', 'action', 'financial_audit')
    )
) ON CONFLICT (id) DO NOTHING;

-- 11. Automação de Orquestração (Gatilhos Autônomos)
-- Simula o comportamento do Agente #Flow monitorando o estado do sistema
CREATE OR REPLACE FUNCTION fn_trigger_harness_orchestration()
RETURNS TRIGGER AS $$
BEGIN
    -- Se a tarefa mudar para 'Em Revisão', dispara o Agente #Sage via Harness
    IF (NEW.status = 'Em Revisão' AND (OLD.status IS NULL OR OLD.status != 'Em Revisão')) THEN
        INSERT INTO harness_chat_executions (pipeline_id, status, metadata)
        VALUES (
            'pl-review-standard',
            'running',
            jsonb_build_object(
                'trigger', 'status_change',
                'agent', '#Sage',
                'task_id', NEW.id,
                'task_title', NEW.title
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_on_task_review ON clickup_tasks;
CREATE TRIGGER tr_on_task_review
AFTER UPDATE ON clickup_tasks
FOR EACH ROW EXECUTE PROCEDURE fn_trigger_harness_orchestration();

-- 17. Configuração do Webhook Automático (FastAPI Backend)
-- Exige a extensão pg_net habilitada no Supabase
CREATE EXTENSION IF NOT EXISTS pg_net;

CREATE OR REPLACE FUNCTION fn_webhook_harness_trigger()
RETURNS TRIGGER AS $$
BEGIN
  -- ATENÇÃO: Substitua a URL abaixo pelo seu link do Ngrok ou do servidor em Nuvem
  PERFORM net.http_post(
      url:='https://revocable-quartet-sediment.ngrok-free.dev/webhook/orchestrate',
      headers:='{"Content-Type": "application/json"}'::jsonb,
      body:=json_build_object(
        'type', TG_OP,
        'table', TG_TABLE_NAME,
        'schema', TG_TABLE_SCHEMA,
        'record', row_to_json(NEW)
      )::jsonb
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Cria o gatilho que avisa o FastAPI sempre que uma orquestração for inserida
DROP TRIGGER IF EXISTS tr_on_harness_execution_created ON harness_chat_executions;
CREATE TRIGGER tr_on_harness_execution_created
  AFTER INSERT ON harness_chat_executions
  FOR EACH ROW EXECUTE PROCEDURE fn_webhook_harness_trigger();
