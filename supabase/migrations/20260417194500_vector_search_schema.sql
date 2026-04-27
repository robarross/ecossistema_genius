-- Migration: 20260417194500_vector_search_schema.sql
-- Objetivo: Habilitar busca vetorial (RAG) para o Segundo Cérebro

-- 1. Habilitar a extensão pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Criar tabela para fragmentos de conhecimento (Chunks)
CREATE TABLE IF NOT EXISTS public.knowledge_chunks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    content TEXT NOT NULL, -- O trecho de texto
    embedding vector(768), -- Vetor do Gemini (768 dimensões)
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Criar função para busca por similaridade
-- Esta função será usada pelos agentes para encontrar os trechos mais relevantes
CREATE OR REPLACE FUNCTION match_knowledge (
  query_embedding vector(768),
  match_threshold float,
  match_count int
)
RETURNS TABLE (
  id UUID,
  file_name TEXT,
  file_path TEXT,
  content TEXT,
  metadata JSONB,
  similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    knowledge_chunks.id,
    knowledge_chunks.file_name,
    knowledge_chunks.file_path,
    knowledge_chunks.content,
    knowledge_chunks.metadata,
    1 - (knowledge_chunks.embedding <=> query_embedding) AS similarity
  FROM knowledge_chunks
  WHERE 1 - (knowledge_chunks.embedding <=> query_embedding) > match_threshold
  ORDER BY similarity DESC
  LIMIT match_count;
END;
$$;

-- 4. Ativar RLS
ALTER TABLE public.knowledge_chunks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Acesso Público para Leitura" ON public.knowledge_chunks FOR SELECT USING (true);
