-- Migration: 20260416001000_elite_integration_schema.sql
-- Objetivo: Suportar Logs de Decisão e KPIs de Confiança

-- 1. Tabela de Logs de Decisão (Observabilidade)
CREATE TABLE IF NOT EXISTS public.genius_agent_decisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id UUID REFERENCES public.agents(id),
    module_id TEXT,
    decision_type TEXT NOT NULL, -- ex: 'FILE_CLASSIFICATION', 'ACCESS_GRANT'
    reasoning TEXT, -- O "porquê" da decisão
    payload JSONB, -- Dados contextuais
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Adicionar Campos de Confiança e Badges (Gamificação 2.0)
ALTER TABLE public.genius_user_stats 
ADD COLUMN IF NOT EXISTS trust_score INTEGER DEFAULT 100,
ADD COLUMN IF NOT EXISTS badges JSONB DEFAULT '[]'::jsonb;

ALTER TABLE public.agents
ADD COLUMN IF NOT EXISTS reliability_index DECIMAL(3,2) DEFAULT 1.0;

-- 3. Habilitar Realtime para as novas tabelas
ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_agent_decisions;

-- Comentários de Documentação
COMMENT ON TABLE public.genius_agent_decisions IS 'Registra o raciocínio por trás das ações automáticas dos agentes.';
COMMENT ON COLUMN public.genius_user_stats.trust_score IS 'Métrica de confiabilidade do usuário no sistema (0-1000).';
