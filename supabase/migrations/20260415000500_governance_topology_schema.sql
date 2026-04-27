-- Migration: 20260415000500_governance_topology_schema.sql
-- Objetivo: Preparar a infraestrutura para IDs alfanuméricos e Skills de Governança

-- 1. Adicionar suporte a metadados de jurisdição (Work Unit) se necessário
-- (A tabela já possui JSONB metadata, vamos usá-lo para 'governance_role' e 'work_unit')

-- 2. Criar Skills de Referência para os Novos Papéis
-- Estas skills serão herdadas via automação quando os agentes nascerem

-- Skill de Compliance (Guardião)
INSERT INTO public.skills (id, agent_id, name, description)
VALUES (gen_random_uuid(), (SELECT id FROM public.agents WHERE display_id = '#04'), 'Protocolo de Auditoria G-MOD', 'Padrão de conferência de integridade e segurança de módulos.')
ON CONFLICT DO NOTHING;

-- Skill de Gestão Tática (Gerente)
INSERT INTO public.skills (id, agent_id, name, description)
VALUES (gen_random_uuid(), (SELECT id FROM public.agents WHERE display_id = '#04'), 'Gestão de KPIs M-MOD', 'Padrão de distribuição de tarefas e monitoramento de indicadores.')
ON CONFLICT DO NOTHING;

-- Skill de Suporte Administrativo (Secretária)
INSERT INTO public.skills (id, agent_id, name, description)
VALUES (gen_random_uuid(), (SELECT id FROM public.agents WHERE display_id = '#04'), 'Organização de Fluxos S-MOD', 'Padrão de triagem documental e suporte administrativo via IA.')
ON CONFLICT DO NOTHING;

-- Skill de Exploração (Pesquisador)
INSERT INTO public.skills (id, agent_id, name, description)
VALUES (gen_random_uuid(), (SELECT id FROM public.agents WHERE display_id = '#04'), 'Análise de Mercado P-MOD', 'Padrão de busca e processamento de dados externos e contextuais.')
ON CONFLICT DO NOTHING;

-- Skill de Educação (Professor)
INSERT INTO public.skills (id, agent_id, name, description)
VALUES (gen_random_uuid(), (SELECT id FROM public.agents WHERE display_id = '#04'), 'Onboarding de Agentes PR-MOD', 'Padrão de transferência de conhecimento e treinamento didático.')
ON CONFLICT DO NOTHING;

-- Skill Técnica (Técnico)
INSERT INTO public.skills (id, agent_id, name, description)
VALUES (gen_random_uuid(), (SELECT id FROM public.agents WHERE display_id = '#04'), 'Operação Técnica T-SUB', 'Padrão de execução e manutenção de fractais operacionais.')
ON CONFLICT DO NOTHING;
