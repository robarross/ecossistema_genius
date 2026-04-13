-- Core SQL Schema for Genius Ecosystem
-- Created: 2026-04-13

-- 1. ENUMS
CREATE TYPE agent_category AS ENUM ('Core', 'Super', 'Modular');
CREATE TYPE agent_status AS ENUM ('Online', 'Offline', 'Maintenance');

-- 2. TABLES
-- Agents Master Table
CREATE TABLE IF NOT EXISTS agents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_id TEXT UNIQUE NOT NULL, -- e.g., "#04"
    name TEXT NOT NULL,
    role TEXT,
    category agent_category NOT NULL,
    status agent_status DEFAULT 'Online',
    creator_id UUID REFERENCES agents(id), -- Link to "Creator" Parent
    folder_path TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Skills Table (Separate as requested)
CREATE TABLE IF NOT EXISTS skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES agents(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    version TEXT DEFAULT '1.0.0',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Audit/Interaction Logs
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID REFERENCES agents(id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    details JSONB DEFAULT '{}'::jsonb,
    severity TEXT DEFAULT 'info',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. TRIGGERS (Auto-update updated_at)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_agents_updated_at
    BEFORE UPDATE ON agents
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 4. SEED DATA (Base on Mesh Map)
-- Core Agents (Creators of the ecosystem)
INSERT INTO agents (display_id, name, role, category, status)
VALUES 
('#01', 'Genius IN', 'Núcleo Cognitivo e Estratégico', 'Core', 'Online'),
('#02', 'Genius HUB', 'Central de Conexão e Registro', 'Core', 'Online'),
('#03', 'Archon', 'Arquiteto de Sistemas Agênticos', 'Core', 'Online'),
('#04', 'Genius Systems', 'Governança e Fábrica de Sistemas', 'Core', 'Online'),
('#100', 'Genius Ecossistema', 'Homeostase e Monitoramento', 'Core', 'Online')
ON CONFLICT (display_id) DO NOTHING;

-- Note: We can add more agents and link them via creator_id once the IDs are known in the DB.
