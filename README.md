# Supabase Keep Alive

Automatically pings Supabase databases every 2 days to prevent them from pausing due to inactivity on the free tier.

## How it works

GitHub Actions runs a scheduled workflow every 2 days that sends REST API requests to your Supabase databases. This keeps them active and prevents the automatic pause that occurs after 7 days of inactivity.

The workflow queries the `profiles` table (or any existing table in your database) to register activity.

## Setup

1. Add your Supabase project details as GitHub Secrets:

   - `SUPABASE_URL_1` - Full URL for database 1 (e.g., `https://xxxxx.supabase.co`)
   - `SUPABASE_KEY_1` - Anon/Public key for database 1
   - `SUPABASE_URL_2` - Full URL for database 2 (e.g., `https://xxxxx.supabase.co`)
   - `SUPABASE_KEY_2` - Anon/Public key for database 2

2. The workflow runs automatically every 2 days at 10:00 AM UTC
3. You can also trigger it manually from the Actions tab

## Getting your Supabase details

1. Go to your Supabase project dashboard
2. Navigate to **Settings** → **General**
3. Copy the "Project URL" (e.g., `https://xxxxxxxxxxxxx.supabase.co`)
4. Navigate to **Settings** → **API**
5. Copy the "anon/public" key from the API keys section

## Troubleshooting

- **Database is paused**: If your database gets paused, you need to manually resume it from the Supabase dashboard. The workflow will then keep it alive going forward.
- **Workflow fails**: Check the Actions tab to see error logs. Common issues include incorrect secrets or database being paused.
- **Schedule frequency**: Running every 2 days provides a buffer before the 7-day inactivity limit.
