-- SCRIPT DE INFRAESTRUTURA: GENIUS BUS SYSTEM
-- Este script cria as tabelas necessárias para Telemetria, XP e Observabilidade de Agentes.

-- 1. Tabela de Estatísticas e Gamificação do Usuário
CREATE TABLE IF NOT EXISTS public.genius_user_stats (
    profile_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    xp_total INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    medals JSONB DEFAULT '[]',
    badges JSONB DEFAULT '[]',
    trust_score INTEGER DEFAULT 100,
    current_theme TEXT DEFAULT 'default',
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabela de Eventos de Sistema (Telemetria)
CREATE TABLE IF NOT EXISTS public.genius_system_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type TEXT NOT NULL,
    payload JSONB DEFAULT '{}',
    criticality TEXT DEFAULT 'INFO', -- INFO, WARN, CRITICAL
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabela de Decisões de Agentes (Observabilidade)
CREATE TABLE IF NOT EXISTS public.genius_agent_decisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agent_id TEXT, -- ID do agente ou display_id
    decision_type TEXT NOT NULL,
    reasoning TEXT,
    payload JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Habilitar RLS (Row Level Security) - Ajuste conforme sua política de segurança
ALTER TABLE public.genius_user_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.genius_system_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.genius_agent_decisions ENABLE ROW LEVEL SECURITY;

-- Políticas Simples (Permitir leitura/escrita para usuários autenticados)
CREATE POLICY "Permitir tudo para autenticados" ON public.genius_user_stats FOR ALL TO authenticated USING (true);
CREATE POLICY "Permitir tudo para autenticados" ON public.genius_system_events FOR ALL TO authenticated USING (true);
CREATE POLICY "Permitir tudo para autenticados" ON public.genius_agent_decisions FOR ALL TO authenticated USING (true);

-- Criar trigger para atualizar o timestamp de stats
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER tr_update_user_stats_time
BEFORE UPDATE ON public.genius_user_stats
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
