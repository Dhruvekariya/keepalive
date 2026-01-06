-- Create keep_alive table for Database 2
-- This table is used solely for keeping the database active
-- Run this SQL in your Database 2 Supabase SQL Editor

CREATE TABLE IF NOT EXISTS public.keep_alive (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    ping_time timestamptz DEFAULT now() NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

-- Enable Row Level Security (optional, but recommended)
ALTER TABLE public.keep_alive ENABLE ROW LEVEL SECURITY;

-- Create a policy to allow anonymous inserts and deletes
-- This allows the GitHub Actions workflow to insert/delete without authentication
CREATE POLICY "Allow anonymous inserts" ON public.keep_alive
    FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "Allow anonymous deletes" ON public.keep_alive
    FOR DELETE TO anon USING (true);

CREATE POLICY "Allow anonymous reads" ON public.keep_alive
    FOR SELECT TO anon USING (true);

-- Create an index on created_at for better performance
CREATE INDEX IF NOT EXISTS keep_alive_created_at_idx ON public.keep_alive(created_at);

-- Add a comment
COMMENT ON TABLE public.keep_alive IS 'Used by GitHub Actions to keep the Supabase database active';
