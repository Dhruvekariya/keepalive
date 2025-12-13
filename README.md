# Supabase Keep Alive

Automatically pings Supabase databases every 3 days to prevent them from pausing due to inactivity.

## Databases
- Database 1: dfqaayjihclbmnwijryi.supabase.co
- Database 2: mkfpswmzsuulhzytlvmp.supabase.co

## How it works
GitHub Actions runs a scheduled workflow every 3 days that sends a REST API request to each Supabase project, keeping them active.

## Setup
1. Add your Supabase API keys as GitHub Secrets:
   - `SUPABASE_KEY_1` - Anon/Public key for database 1
   - `SUPABASE_KEY_2` - Anon/Public key for database 2

2. The workflow runs automatically on schedule
3. You can also trigger it manually from the Actions tab

## Getting your Supabase API keys
1. Go to your Supabase project dashboard
2. Click on Settings → API
3. Copy the "anon" or "public" key
