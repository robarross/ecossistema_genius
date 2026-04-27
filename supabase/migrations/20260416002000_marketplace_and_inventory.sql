-- Migration: 20260416002000_marketplace_and_inventory.sql
-- Objetivo: Criar a economia de peças LEGO Genius

-- 1. Catálogo do Marketplace
CREATE TABLE IF NOT EXISTS public.genius_marketplace (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'FRACTAL', 'SUBMODULE', 'MODULE', 'TOOL'
    description TEXT,
    cost_xp INTEGER DEFAULT 1000,
    blueprint_path TEXT, -- Link para o modelo em _blueprints
    icon TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Inventário do Usuário
CREATE TABLE IF NOT EXISTS public.genius_user_inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID REFERENCES public.profiles(id),
    item_id UUID REFERENCES public.genius_marketplace(id),
    acquired_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    is_plugged BOOLEAN DEFAULT false,
    plugged_at TIMESTAMP WITH TIME ZONE,
    parent_instance_id UUID -- ID de onde esta peça está plugada
);

-- 3. Habilitar Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_marketplace;
ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_user_inventory;

-- Seed inicial de algumas "Peças LEGO"
INSERT INTO public.genius_marketplace (name, type, description, cost_xp, icon) VALUES
('Agente de Solo Pro', 'FRACTAL', 'Especialista em análise química de solo.', 500, '🧪'),
('Módulo Financeiro Core', 'MODULE', 'Gestão completa de fluxo de caixa rural.', 2000, '💰'),
('Skill de WebScraping', 'TOOL', 'Permite que qualquer agente busque dados na web.', 250, '🌐'),
('Submódulo de Clima Plus', 'SUBMODULE', 'Integração com previsões de satélite.', 1200, '🌦️');
