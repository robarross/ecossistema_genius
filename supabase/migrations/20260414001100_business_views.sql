-- Business Intelligence Views for Property Management
-- Created: 2026-04-14
-- Depends on: 20260414000600_business_unidade_agricola_schema.sql

-- 1. VIEW: Resumo de Propriedades (Owners + Farms)
CREATE OR REPLACE VIEW public.v_resumo_propriedades AS
SELECT 
    p.display_id AS proprietario_id,
    p.name AS proprietario_nome,
    f.display_id AS fazenda_id,
    f.name AS fazenda_nome,
    f.total_area_ha,
    f.profit_center,
    f.status AS fazenda_status
FROM public.proprietarios p
JOIN public.fazendas f ON p.id = f.proprietario_id
WHERE f.status != 'Offline';

-- 2. VIEW: Mapa Operacional (Glebas + Talhões)
CREATE OR REPLACE VIEW public.v_mapa_operacional AS
SELECT 
    f.name AS fazenda_nome,
    g.name AS gleba_nome,
    t.display_id AS talhao_id,
    t.name AS talhao_nome,
    t.usable_area_ha,
    t.crop_type,
    t.inventory_status
FROM public.fazendas f
JOIN public.glebas g ON f.id = g.fazenda_id
JOIN public.talhoes t ON g.id = t.gleba_id
WHERE t.inventory_status = 'Ativo';

-- 3. VIEW: Alertas de Documentação (Assets with issues)
CREATE OR REPLACE VIEW public.v_alertas_documentos AS
SELECT 
    f.name AS fazenda_nome,
    a.display_id AS ativo_id,
    a.category,
    a.title_document,
    a.status_vencimento
FROM public.fazendas f
JOIN public.ativos_imobiliários a ON f.id = a.fazenda_id
WHERE a.status_vencimento NOT IN ('Vlida', 'Regularizado');

-- 4. DOCUMENTATION
COMMENT ON VIEW public.v_resumo_propriedades IS 'Visão consolidada de Proprietários e suas respectivas Fazendas ativas.';
COMMENT ON VIEW public.v_mapa_operacional IS 'Visão operacional detalhada de Talhões em produção ativa.';
COMMENT ON VIEW public.v_alertas_documentos IS 'Filtro automático para Ativos Imobiliários com pendências ou vencimentos.';
