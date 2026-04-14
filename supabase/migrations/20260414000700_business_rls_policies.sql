-- Business Data Security Policies (RLS)
-- Created: 2026-04-14
-- Depends on: 20260414000600_business_unidade_agricola_schema.sql and 20260414000340_profiles_schema.sql

-- 1. ENABLE ROW LEVEL SECURITY
ALTER TABLE public.proprietarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fazendas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.glebas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.talhoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ativos_imobiliários ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chaves_identidade ENABLE ROW LEVEL SECURITY;

-- 2. POLICIES: Proprietários
-- Admins can do everything
CREATE POLICY "Admins have full access to proprietarios"
  ON public.proprietarios FOR ALL
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'Admin'));

-- Owners can view their own holding
CREATE POLICY "Owners can view their own holding"
  ON public.proprietarios FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'Owner'));

-- 3. POLICIES: Fazendas
CREATE POLICY "Admins have full access to fazendas"
  ON public.fazendas FOR ALL
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'Admin'));

CREATE POLICY "Owners can view their fazendas"
  ON public.fazendas FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.profiles p 
    WHERE p.id = auth.uid() 
    AND (p.role = 'Owner' OR p.role = 'Manager')
  ));

-- 4. POLICIES: Glebas & Talhões (Read access for everyone in the ecosystem)
CREATE POLICY "Ecosystem read access for glebas"
  ON public.glebas FOR SELECT
  USING (true);

CREATE POLICY "Ecosystem read access for talhoes"
  ON public.talhoes FOR SELECT
  USING (true);

-- 5. POLICIES: Chaves (Highly restricted)
CREATE POLICY "Only Admins can view keys"
  ON public.chaves_identidade FOR ALL
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'Admin'));
