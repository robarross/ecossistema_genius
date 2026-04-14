-- Business Schema for Gestão da Unidade Agrícola (MOD-A-01)
-- Created: 2026-04-14
-- Depends on: 20260413000100_core_schema.sql

-- 1. TABLES
-- Proprietários (Owners/Holdings)
CREATE TABLE IF NOT EXISTS public.proprietarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_id TEXT UNIQUE NOT NULL, -- e.g., "PRP-001"
    name TEXT NOT NULL,
    document TEXT UNIQUE, -- CPF or CNPJ
    participation_percentage NUMERIC DEFAULT 100,
    fiscal_status TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Fazendas (Farms)
CREATE TABLE IF NOT EXISTS public.fazendas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proprietario_id UUID REFERENCES public.proprietarios(id) ON DELETE SET NULL,
    display_id TEXT UNIQUE NOT NULL, -- e.g., "FZD-001"
    name TEXT NOT NULL,
    total_area_ha NUMERIC,
    profit_center TEXT,
    coordinates TEXT, -- Placeholder for simple Lat/Long or Geography
    folder_path TEXT,
    status TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Glebas (Land Plots)
CREATE TABLE IF NOT EXISTS public.glebas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fazenda_id UUID NOT NULL REFERENCES public.fazendas(id) ON DELETE CASCADE,
    display_id TEXT UNIQUE NOT NULL, -- e.g., "GLB-001"
    name TEXT NOT NULL,
    area_ha NUMERIC,
    soil_type TEXT,
    geophysical_status TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Talhões (Production Plots)
CREATE TABLE IF NOT EXISTS public.talhoes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gleba_id UUID NOT NULL REFERENCES public.glebas(id) ON DELETE CASCADE,
    display_id TEXT UNIQUE NOT NULL, -- e.g., "TLH-001"
    name TEXT,
    usable_area_ha NUMERIC,
    crop_type TEXT,
    central_coordinates TEXT,
    inventory_status TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Ativos Imobiliários (Certificates/Deeds)
CREATE TABLE IF NOT EXISTS public.ativos_imobiliários (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fazenda_id UUID REFERENCES public.fazendas(id) ON DELETE SET NULL,
    display_id TEXT UNIQUE NOT NULL, -- e.g., "ATV-001"
    category TEXT,
    title_document TEXT,
    area_ha NUMERIC,
    status_vencimento TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Chaves de Identidade (Mapping IDs)
CREATE TABLE IF NOT EXISTS public.chaves_identidade (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    genius_id TEXT UNIQUE NOT NULL,
    external_system_id TEXT,
    origin_system TEXT,
    active_type TEXT,
    sync_status TEXT,
    last_verification TIMESTAMPTZ,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. TRIGGERS
-- Auto-update updated_at for all business tables
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND table_name IN ('proprietarios', 'fazendas', 'glebas', 'talhoes', 'ativos_imobiliários', 'chaves_identidade')
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS update_%I_updated_at ON public.%I', t, t);
        EXECUTE format('CREATE TRIGGER update_%I_updated_at BEFORE UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()', t, t);
    END LOOP;
END $$;

-- 3. INDEXES
CREATE INDEX IF NOT EXISTS idx_fazendas_proprietario_id ON public.fazendas(proprietario_id);
CREATE INDEX IF NOT EXISTS idx_glebas_fazenda_id ON public.glebas(fazenda_id);
CREATE INDEX IF NOT EXISTS idx_talhoes_gleba_id ON public.talhoes(gleba_id);
CREATE INDEX IF NOT EXISTS idx_ativos_fazenda_id ON public.ativos_imobiliários(fazenda_id);
