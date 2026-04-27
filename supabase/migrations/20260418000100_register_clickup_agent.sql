-- REGISTRO: Super Agente #38 - ClickUp
-- Especialista em Orquestração de Fluxos e Gestão de Backlog

INSERT INTO public.agents (id, name, type, role, status, metadata)
VALUES (
    '#38',
    'ClickUp Genius',
    'Super Agente',
    'Orquestrador de Fluxo',
    'Ativo',
    '{
        "specialties": ["Gantt", "Kanban", "Agile", "Backlog Management"],
        "standard": "LEGO Ultra-Standard",
        "interface_url": "/_processo_Inteligencia/_sistemas/clickup_genius/3_Interface/index.html"
    }'
)
ON CONFLICT (id) DO UPDATE 
SET status = 'Ativo', metadata = EXCLUDED.metadata;
