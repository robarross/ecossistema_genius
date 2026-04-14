-- Modules SQL Schema for Genius Ecosystem
-- Created: 2026-04-14
-- Depends on: 20260413000100_core_schema.sql

-- 1. ENUMS
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'module_category_type') THEN
        CREATE TYPE module_category_type AS ENUM (
            'Administrativo', 
            'Territorial', 
            'Infraestrutura', 
            'Tecnologico', 
            'Produtivo', 
            'Negocio'
        );
    END IF;
END $$;

-- 2. TABLES
-- Modules Master Table
CREATE TABLE IF NOT EXISTS modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_id TEXT UNIQUE NOT NULL, -- e.g., "MOD-A-01"
    name TEXT NOT NULL,
    category module_category_type NOT NULL,
    description TEXT,
    folder_path TEXT,
    status TEXT DEFAULT 'Pending',
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 3. LINKING AGENTS TO MODULES
-- Adding module_id to agents table
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agents' AND column_name = 'module_id') THEN
        ALTER TABLE agents ADD COLUMN module_id UUID REFERENCES modules(id) ON DELETE SET NULL;
    END IF;
END $$;

-- 4. TRIGGERS
-- Auto-update updated_at for modules
DROP TRIGGER IF EXISTS update_modules_updated_at ON modules;
CREATE TRIGGER update_modules_updated_at
    BEFORE UPDATE ON modules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 5. INDEXES
CREATE INDEX IF NOT EXISTS idx_modules_category ON modules(category);
CREATE INDEX IF NOT EXISTS idx_agents_module_id ON agents(module_id);
