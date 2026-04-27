-- Migration: 20260416002200_quotation_and_purchase_orders.sql
-- Objetivo: Suportar o motor de cotação e geração de pedidos de compra

-- 1. Solicitações de Cotação
CREATE TABLE IF NOT EXISTS public.genius_quotation_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID REFERENCES public.profiles(id),
    item_requested TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    category TEXT,
    status TEXT DEFAULT 'OPEN', -- 'OPEN', 'QUOTED', 'COMPLETED', 'CANCELLED'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Respostas de Fornecedores (Cotações Recebidas)
CREATE TABLE IF NOT EXISTS public.genius_quotation_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES public.genius_quotation_requests(id),
    seller_name TEXT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    delivery_time_days INTEGER,
    is_winner BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Pedidos de Compra (Finalizados)
CREATE TABLE IF NOT EXISTS public.genius_purchase_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES public.genius_quotation_requests(id),
    winner_response_id UUID REFERENCES public.genius_quotation_responses(id),
    order_status TEXT DEFAULT 'PENDING_PAYMENT',
    po_file_path TEXT, -- Caminho para o PDF na pasta 2_OUT_Saida
    total_amount DECIMAL(12,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_quotation_requests;
ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_quotation_responses;
ALTER PUBLICATION supabase_realtime ADD TABLE public.genius_purchase_orders;
