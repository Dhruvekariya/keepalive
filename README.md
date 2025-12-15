# Supabase Keep Alive

Automatically pings Supabase databases every 3 days to prevent them from pausing due to inactivity.

## How it works

GitHub Actions runs a scheduled workflow every 3 days that sends a REST API request to each Supabase project, keeping them active.

## Setup

1. Add your Supabase project details as GitHub Secrets:

   - `SUPABASE_URL_1` - Full URL for database 1 (e.g., `https://xxxxx.supabase.co`)
   - `SUPABASE_KEY_1` - Anon/Public key for database 1
   - `SUPABASE_URL_2` - Full URL for database 2 (e.g., `https://xxxxx.supabase.co`)
   - `SUPABASE_KEY_2` - Anon/Public key for database 2

2. The workflow runs automatically on schedule
3. You can also trigger it manually from the Actions tab

## Getting your Supabase details

1. Go to your Supabase project dashboard
2. Click on Settings
3. Copy the "Project URL" for the URL secrets from General
4. Copy the "Publishable key" for the KEY secrets from API keys
