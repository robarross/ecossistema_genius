-- Vincular tarefas aos Agentes Genius
ALTER TABLE public.clickup_tasks 
ADD COLUMN IF NOT EXISTS agent_id UUID REFERENCES public.agents(id);

-- Atualizar view aprimorada para incluir dados do Agente
DROP VIEW IF EXISTS v_clickup_tasks_enhanced;
CREATE VIEW v_clickup_tasks_enhanced AS
SELECT 
    t.*,
    w.name as workspace_name,
    s.name as space_name,
    l.name as list_name,
    a.name as agent_name,
    a.display_id as agent_display_id,
    a.metadata->>'avatar_url' as agent_avatar_url,
    CASE 
        WHEN t.priority = 'Urgente' THEN 100
        WHEN t.priority = 'Alta' THEN 50
        WHEN t.priority = 'Normal' THEN 20
        ELSE 10
    END as task_xp,
    (SELECT count(*) FROM public.clickup_checklists c WHERE c.task_id = t.id) as checklist_count,
    (SELECT count(*) FROM public.clickup_checklists c WHERE c.task_id = t.id AND c.is_completed = true) as checklist_completed_count
FROM public.clickup_tasks t
LEFT JOIN public.clickup_workspaces w ON t.workspace_id = w.id
LEFT JOIN public.clickup_spaces s ON t.space_id = s.id
LEFT JOIN public.clickup_lists l ON t.list_id = l.id
LEFT JOIN public.agents a ON t.agent_id = a.id;
