-- Create keep_alive table for Database 2
-- This table is used solely for keeping the database active
-- Run this SQL in your Database 2 Supabase SQL Editor

-- Drop the table if it exists (to start fresh)
DROP TABLE IF EXISTS public.keep_alive CASCADE;

-- Create the keep_alive table with minimal schema
CREATE TABLE public.keep_alive (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    ping_time timestamptz DEFAULT now() NOT NULL
);

-- Since you're using service_role keys, RLS is not strictly necessary
-- But we'll enable it anyway for good practice
ALTER TABLE public.keep_alive ENABLE ROW LEVEL SECURITY;

-- Create policies (note: service_role key bypasses these anyway)
CREATE POLICY "Allow all operations" ON public.keep_alive
    FOR ALL
    TO public
    USING (true)
    WITH CHECK (true);

-- Create an index for better query performance
CREATE INDEX IF NOT EXISTS keep_alive_ping_time_idx ON public.keep_alive(ping_time);

-- Add a comment
COMMENT ON TABLE public.keep_alive IS 'Used by GitHub Actions to keep the Supabase database active';

-- Verify the table was created
SELECT 'keep_alive table created successfully!' as message;
