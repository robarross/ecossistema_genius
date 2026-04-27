-- SCHEMA: ClickUp Genius System
-- Arquitetura Industrial de Backlog e Governança Operacional

-- 1. Tabela de Tarefas ClickUp
CREATE TABLE IF NOT EXISTS public.clickup_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'A Fazer', -- 'A Fazer', 'Em Andamento', 'Em Revisão', 'Concluído'
    priority TEXT NOT NULL DEFAULT 'Normal', -- 'Baixa', 'Normal', 'Alta', 'Urgente'
    start_date DATE,
    due_date DATE,
    assignee_id TEXT, -- ID do Agente ou Perfil
    system_id UUID, -- Referência ao Sistema Pai
    module_id UUID, -- Referência ao Módulo Pai
    submodule_id UUID, -- Referência ao Submódulo Pai
    fractal_id UUID, -- Referência ao Fractal (List)
    dependency_id UUID REFERENCES public.clickup_tasks(id) ON DELETE SET NULL,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. View Consolidada (com nomes amigáveis)
CREATE OR REPLACE VIEW public.v_clickup_tasks_full AS
SELECT 
    t.*,
    f.name AS fractal_name,
    m.name AS module_name
FROM public.clickup_tasks t
LEFT JOIN public.fractals f ON t.fractal_id = f.id
LEFT JOIN public.modules m ON t.module_id = m.id;

-- 3. Habilitar Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.clickup_tasks;

-- 4. RLS (Políticas de Segurança)
ALTER TABLE public.clickup_tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Acesso Universal para Agentes" 
ON public.clickup_tasks FOR ALL 
USING (true);
