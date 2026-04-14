-- Submodules SQL Schema for Genius Ecosystem
-- Created: 2026-04-14
-- Depends on: 20260414000300_modules_schema.sql

-- 1. TABLES
-- Submodules Table
CREATE TABLE IF NOT EXISTS submodules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    display_id TEXT UNIQUE NOT NULL, -- e.g., "SUB-01-01"
    name TEXT NOT NULL,
    folder_path TEXT,
    status TEXT DEFAULT 'Pending',
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. TRIGGERS
-- Auto-update updated_at for submodules
DROP TRIGGER IF EXISTS update_submodules_updated_at ON submodules;
CREATE TRIGGER update_submodules_updated_at
    BEFORE UPDATE ON submodules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 3. INDEXES
CREATE INDEX IF NOT EXISTS idx_submodules_module_id ON submodules(module_id);
CREATE INDEX IF NOT EXISTS idx_submodules_display_id ON submodules(display_id);
