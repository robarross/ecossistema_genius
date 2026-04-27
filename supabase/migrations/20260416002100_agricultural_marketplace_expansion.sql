-- Migration: 20260416002100_agricultural_marketplace_expansion.sql
-- Objetivo: Expandir o marketplace para categorias agro físicas e serviços

-- 1. Adicionar campos de categoria e vendedor
ALTER TABLE public.genius_marketplace 
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'PEÇAS GENIUS',
ADD COLUMN IF NOT EXISTS seller_info JSONB DEFAULT '{"name": "Genius Core", "rating": 5.0}'::jsonb;

-- 2. Inserir itens de categorias físicas (Lojas Agrícolas)
INSERT INTO public.genius_marketplace (name, type, category, description, cost_xp, icon, seller_info) VALUES
('Semente Soja Master', 'PRODUCT', 'INSUMOS', 'Saca de 40kg - Alta produtividade.', 800, '🌱', '{"name": "AgroSementes LTDA", "rating": 4.8}'),
('Fertilizante NPK 10-10-10', 'PRODUCT', 'INSUMOS', 'Ton de fertilizante granulado.', 1500, '🧪', '{"name": "NutriTerra", "rating": 4.5}'),
('Trator T-5000 (Simulação)', 'MACHINERY', 'MAQUINÁRIO', 'Aluguel por dia de operação.', 5000, '🚜', '{"name": "John Rental", "rating": 4.9}'),
('Consultoria Agronômica', 'SERVICE', 'SERVIÇOS', 'Hora de consultoria especializada.', 600, '👨‍🌾', '{"name": "ExpertAgro", "rating": 5.0}');

-- Comentário
COMMENT ON COLUMN public.genius_marketplace.category IS 'Categoria do produto: INSUMOS, MAQUINÁRIO, SERVIÇOS, PEÇAS GENIUS.';
