-- SCHEMA UPDATE: Subtasks e Checklists ClickUp
-- Expansão para suporte a granularidade operacional

-- 1. Adicionar Parent ID para Subtasks (Recursividade)
ALTER TABLE public.clickup_tasks ADD COLUMN IF NOT EXISTS parent_id UUID REFERENCES public.clickup_tasks(id) ON DELETE CASCADE;

-- 2. Tabela de Checklists
CREATE TABLE IF NOT EXISTS public.clickup_checklists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES public.clickup_tasks(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    is_completed BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Habilitar Realtime para Checklists
ALTER PUBLICATION supabase_realtime ADD TABLE public.clickup_checklists;

-- 4. RLS para Checklists
ALTER TABLE public.clickup_checklists ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Acesso Universal para Checklists" ON public.clickup_checklists FOR ALL USING (true);

-- 5. View Atualizada com contagem de Subtasks/Checklists
CREATE OR REPLACE VIEW public.v_clickup_tasks_enhanced AS
SELECT 
    t.*,
    (SELECT count(*) FROM public.clickup_tasks s WHERE s.parent_id = t.id) as subtask_count,
    (SELECT count(*) FROM public.clickup_checklists c WHERE c.task_id = t.id) as checklist_count,
    (SELECT count(*) FROM public.clickup_checklists c WHERE c.task_id = t.id AND c.is_completed = true) as checklist_completed_count
FROM public.clickup_tasks t;
