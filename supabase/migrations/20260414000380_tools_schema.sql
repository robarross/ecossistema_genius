-- Tools SQL Schema for Genius Ecosystem
-- Created: 2026-04-14
-- Depends on: 20260414000320_submodules_schema.sql

-- 1. TABLES
-- Tools Registry Table
CREATE TABLE IF NOT EXISTS tools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submodule_id UUID REFERENCES submodules(id) ON DELETE CASCADE,
    display_id TEXT UNIQUE NOT NULL, -- e.g., "TOOL-01-03-01"
    name TEXT NOT NULL,
    description TEXT,
    type TEXT, -- 'Calculator', 'Validator', 'Generator', 'API'
    folder_path TEXT,
    status TEXT DEFAULT 'Pending',
    input_schema JSONB DEFAULT '{}'::jsonb,
    output_schema JSONB DEFAULT '{}'::jsonb,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. TRIGGERS
-- Auto-update updated_at for tools
DROP TRIGGER IF EXISTS update_tools_updated_at ON tools;
CREATE TRIGGER update_tools_updated_at
    BEFORE UPDATE ON tools
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 3. INDEXES
CREATE INDEX IF NOT EXISTS idx_tools_submodule_id ON tools(submodule_id);
CREATE INDEX IF NOT EXISTS idx_tools_display_id ON tools(display_id);
