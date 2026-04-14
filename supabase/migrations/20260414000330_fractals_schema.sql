-- Fractals SQL Schema for Genius Ecosystem
-- Created: 2026-04-14
-- Depends on: 20260414000320_submodules_schema.sql

-- 1. TABLES
-- Fractals Table
CREATE TABLE IF NOT EXISTS fractals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    submodule_id UUID NOT NULL REFERENCES submodules(id) ON DELETE CASCADE,
    display_id TEXT UNIQUE NOT NULL, -- e.g., "FRAC-01-01-01"
    name TEXT NOT NULL,
    role TEXT,
    folder_path TEXT,
    status TEXT DEFAULT 'Pending',
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. TRIGGERS
-- Auto-update updated_at for fractals
DROP TRIGGER IF EXISTS update_fractals_updated_at ON fractals;
CREATE TRIGGER update_fractals_updated_at
    BEFORE UPDATE ON fractals
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 3. INDEXES
CREATE INDEX IF NOT EXISTS idx_fractals_submodule_id ON fractals(submodule_id);
CREATE INDEX IF NOT EXISTS idx_fractals_display_id ON fractals(display_id);
