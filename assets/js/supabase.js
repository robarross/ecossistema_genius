import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm';

// ATENÇÃO: Substitua os valores abaixo com as credenciais do seu projeto Supabase.
// Você encontra isso no dashboard do Supabase (Settings > API).
export const SUPABASE_URL = 'https://eajbrkypndqlumrmuoag.supabase.co';
export const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhamJya3lwbmRxbHVtcm11b2FnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYwOTQ1OTcsImV4cCI6MjA5MTY3MDU5N30.VzoVTcGNTHCkj867C4fv4TrqKdjM8U0b5dapokX8VZg';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
