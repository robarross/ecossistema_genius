-- Migration: 20260415110000_create_library_index_table.sql
-- Objetivo: Criar o índice digital da biblioteca para buscas via Telegram e BI

-- 1. Criar Tabela de Ativos
CREATE TABLE IF NOT EXISTS public.library_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    summary TEXT,
    tags TEXT[],
    category TEXT, -- template, modelo, exemplo, acervo, operacional
    module_id TEXT, -- PV, UA, FINANCEIRO, RH
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ativar RLS e Realtime (Opcional por enquanto)
ALTER TABLE public.library_assets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Acesso Total para Serviço" ON public.library_assets FOR ALL USING (true);

-- 2. Seed Inicial com os ativos criados hoje
INSERT INTO public.library_assets (file_name, file_path, summary, tags, category, module_id)
VALUES 
(
    'apostila_manejo_soja_2026.txt', 
    'e:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos\E_Modulos_Produtivo\Mod_Gestao_Producao_Vegetal\0_biblioteca_setorial\referencia\04_acervo\apostila_manejo_soja_2026.txt',
    'Guia técnico completo sobre manejo de soja, cobrindo plantio, solo e fitossanidade.',
    ARRAY['soja', 'manejo', 'tecnico', 'safra 2026'],
    'acervo',
    'PV'
),
(
    'template_relatorio_campo.md',
    'e:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos\E_Modulos_Produtivo\Mod_Gestao_Producao_Vegetal\0_biblioteca_setorial\referencia\01_templates\template_relatorio_campo.md',
    'Template mestre para relatórios de inspeção de campo e estádios fenológicos.',
    ARRAY['template', 'campo', 'inspeção', 'padrão'],
    'template',
    'PV'
),
(
    'template_fluxo_caixa_semanal.md',
    'e:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos\A_Modulos_Administrativo_Corporativo\Mod_Gestao_Financeira\0_biblioteca_setorial\referencia\01_templates\template_fluxo_caixa_semanal.md',
    'Template para controle de fluxo de caixa semanal, entradas e saídas financeiras.',
    ARRAY['financeiro', 'fluxo de caixa', 'controlo', 'template'],
    'template',
    'FINANCEIRO'
),
(
    'template_ficha_admissao.md',
    'e:\Diretorios\Diretorio_Agentes\_processo_Inteligencia\_modulos\A_Modulos_Administrativo_Corporativo\Mod_Gestao_RH\0_biblioteca_setorial\referencia\01_templates\template_ficha_admissao.md',
    'Ficha padrão para registro de admissão de novos colaboradores e entrega de EPIs.',
    ARRAY['RH', 'admissão', 'colaborador', 'EPI', 'template'],
    'template',
    'RH'
);
