-- Adicionar colunas de categorização industrial Genius
ALTER TABLE public.clickup_tasks 
ADD COLUMN IF NOT EXISTS workspace_id UUID REFERENCES public.clickup_workspaces(id),
ADD COLUMN IF NOT EXISTS space_id UUID REFERENCES public.clickup_spaces(id),
ADD COLUMN IF NOT EXISTS modulo TEXT,
ADD COLUMN IF NOT EXISTS submodulo TEXT,
ADD COLUMN IF NOT EXISTS fractal TEXT;

-- Atualizar view aprimorada para incluir novos campos
DROP VIEW IF EXISTS v_clickup_tasks_enhanced;
CREATE VIEW v_clickup_tasks_enhanced AS
SELECT 
    t.*,
    w.name as workspace_name,
    s.name as space_name,
    l.name as list_name,
    (SELECT count(*) FROM public.clickup_checklists c WHERE c.task_id = t.id) as checklist_count,
    (SELECT count(*) FROM public.clickup_checklists c WHERE c.task_id = t.id AND c.is_completed = true) as checklist_completed_count
FROM public.clickup_tasks t
LEFT JOIN public.clickup_workspaces w ON t.workspace_id = w.id
LEFT JOIN public.clickup_spaces s ON t.space_id = s.id
LEFT JOIN public.clickup_lists l ON t.list_id = l.id;
