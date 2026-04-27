-- SUPABASE_SCHEMA_TEMPLATE.sql
-- Substituir {{NOME_MODULO}}, {{SCHEMA_MODULO}} e tabelas conforme módulo gerado.

create extension if not exists pgcrypto;
create schema if not exists {{SCHEMA_MODULO}};

create table if not exists {{SCHEMA_MODULO}}.entidade_base (
  id_entidade_base uuid primary key default gen_random_uuid(),
  codigo text unique not null,
  nome text not null,
  status text not null default 'pendente',
  payload jsonb not null default '{}'::jsonb,
  sync_status text not null default 'pendente',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
