-- ClickUp System Schema for Genius Ecosystem
-- Created: 2026-04-18
-- Depends on: 20260413000100_core_schema.sql, 20260414000300_modules_schema.sql, 20260414000320_submodules_schema.sql, 20260414000330_fractals_schema.sql

-- 1. TABLES
-- ClickUp Tasks
CREATE TABLE IF NOT EXISTS public.clickup_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    display_id TEXT UNIQUE NOT NULL, -- e.g., "TASK-001"
    name TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'Todo', -- 'Todo', 'In Progress', 'Review', 'Done', 'Blocked'
    priority TEXT DEFAULT 'Medium', -- 'Low', 'Medium', 'High', 'Urgent'
    fractal_id UUID REFERENCES public.fractals(id) ON DELETE SET NULL,
    assigned_agent_id UUID REFERENCES public.agents(id) ON DELETE SET NULL,
    due_date TIMESTAMPTZ,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ClickUp Subtasks
CREATE TABLE IF NOT EXISTS public.clickup_subtasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES public.clickup_tasks(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    status TEXT DEFAULT 'Todo',
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ClickUp Checklists
CREATE TABLE IF NOT EXISTS public.clickup_checklists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID REFERENCES public.clickup_tasks(id) ON DELETE CASCADE,
    subtask_id UUID REFERENCES public.clickup_subtasks(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    is_checked BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT one_parent CHECK (
        (task_id IS NOT NULL AND subtask_id IS NULL) OR 
        (task_id IS NULL AND subtask_id IS NOT NULL)
    )
);

-- 2. VIEWS
-- Full ClickUp Hierarchy View
CREATE OR REPLACE VIEW public.v_clickup_full_hierarchy AS
SELECT 
    s.name AS system_name,
    m.name AS module_name,
    sm.name AS submodule_name,
    f.name AS fractal_name,
    t.display_id AS task_id,
    t.name AS task_name,
    t.status AS task_status,
    t.priority AS task_priority,
    a.name AS assigned_agent
FROM public.clickup_tasks t
JOIN public.fractals f ON t.fractal_id = f.id
JOIN public.submodules sm ON f.submodule_id = sm.id
JOIN public.modules m ON sm.module_id = m.id
LEFT JOIN public.systems s ON m.id = s.module_id
LEFT JOIN public.agents a ON t.assigned_agent_id = a.id;

-- 3. TRIGGERS
-- Auto-update updated_at for tasks
DROP TRIGGER IF EXISTS update_clickup_tasks_updated_at ON public.clickup_tasks;
CREATE TRIGGER update_clickup_tasks_updated_at
    BEFORE UPDATE ON public.clickup_tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Auto-update updated_at for subtasks
DROP TRIGGER IF EXISTS update_clickup_subtasks_updated_at ON public.clickup_subtasks;
CREATE TRIGGER update_clickup_subtasks_updated_at
    BEFORE UPDATE ON public.clickup_subtasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 4. INDEXES
CREATE INDEX IF NOT EXISTS idx_clickup_tasks_fractal_id ON public.clickup_tasks(fractal_id);
CREATE INDEX IF NOT EXISTS idx_clickup_tasks_assigned_agent_id ON public.clickup_tasks(assigned_agent_id);
CREATE INDEX IF NOT EXISTS idx_clickup_subtasks_task_id ON public.clickup_subtasks(task_id);
