-- SCHEMA: ClickUp Hierarchy (Full Industrialization)
-- Suporte completo para Workspaces, Spaces, Folders e Lists

-- 1. Workspaces
CREATE TABLE IF NOT EXISTS public.clickup_workspaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    avatar_url TEXT,
    owner_id TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Spaces
CREATE TABLE IF NOT EXISTS public.clickup_spaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    workspace_id UUID NOT NULL REFERENCES public.clickup_workspaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    color TEXT DEFAULT '#7b68ee',
    is_private BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Folders
CREATE TABLE IF NOT EXISTS public.clickup_folders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    space_id UUID NOT NULL REFERENCES public.clickup_spaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Lists
CREATE TABLE IF NOT EXISTS public.clickup_lists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    folder_id UUID REFERENCES public.clickup_folders(id) ON DELETE CASCADE, -- Opcional (Listas podem estar direto no Space)
    space_id UUID NOT NULL REFERENCES public.clickup_spaces(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    color TEXT DEFAULT '#00ff88',
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Atualizar clickup_tasks para referenciar Lists
ALTER TABLE public.clickup_tasks ADD COLUMN IF NOT EXISTS list_id UUID REFERENCES public.clickup_lists(id) ON DELETE CASCADE;

-- 6. Habilitar Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.clickup_workspaces;
ALTER PUBLICATION supabase_realtime ADD TABLE public.clickup_spaces;
ALTER PUBLICATION supabase_realtime ADD TABLE public.clickup_folders;
ALTER PUBLICATION supabase_realtime ADD TABLE public.clickup_lists;

-- 7. RLS
ALTER TABLE public.clickup_workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clickup_spaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clickup_folders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clickup_lists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Acesso Universal" ON public.clickup_workspaces FOR ALL USING (true);
CREATE POLICY "Acesso Universal" ON public.clickup_spaces FOR ALL USING (true);
CREATE POLICY "Acesso Universal" ON public.clickup_folders FOR ALL USING (true);
CREATE POLICY "Acesso Universal" ON public.clickup_lists FOR ALL USING (true);
