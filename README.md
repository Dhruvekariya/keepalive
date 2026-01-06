# Supabase Keep Alive

Automatically keeps Supabase databases active by performing write operations twice daily, preventing them from pausing due to inactivity on the free tier.

## How it works

GitHub Actions runs a scheduled workflow **twice daily** (every 12 hours at 6 AM and 6 PM UTC) that:

1. **Inserts** a temporary record into your database
2. **Deletes** the record immediately after
3. This active write/delete cycle signals strong database activity to Supabase

### Database-specific operations:

- **Database 1**: Inserts/deletes a temporary driver named `keepalive_<timestamp>` in the `drivers` table
- **Database 2**: Inserts/deletes a temporary record in the `keep_alive` table

This approach is more effective than simple read queries because write operations are a stronger indicator of active database usage.

## Setup

### 1. Configure GitHub Secrets

Add your Supabase project details as GitHub Secrets in your repository:

- `SUPABASE_URL_1` - Full URL for database 1 (e.g., `https://xxxxx.supabase.co`)
- `SUPABASE_KEY_1` - Anon/Public key for database 1
- `SUPABASE_URL_2` - Full URL for database 2 (e.g., `https://xxxxx.supabase.co`)
- `SUPABASE_KEY_2` - Anon/Public key for database 2

### 2. Create the keep_alive table in Database 2

Run the SQL script `create_keepalive_table.sql` in your Database 2 SQL Editor (Supabase Dashboard):

```sql
-- This creates the keep_alive table with proper RLS policies
-- See create_keepalive_table.sql for the full script
```

### 3. Automated Execution

- The workflow runs automatically twice daily (6 AM & 6 PM UTC)
- You can also trigger it manually from the GitHub Actions tab
- No additional configuration needed!

## Getting your Supabase details

1. Go to your Supabase project dashboard
2. Navigate to **Settings** → **General**
3. Copy the "Project URL" (e.g., `https://xxxxxxxxxxxxx.supabase.co`)
4. Navigate to **Settings** → **API**
5. Copy the "anon/public" key from the API keys section

## How to add GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret (SUPABASE_URL_1, SUPABASE_KEY_1, etc.)

## Schedule Details

The workflow runs twice daily at:
- **6:00 AM UTC** (morning run)
- **6:00 PM UTC** (evening run)

This ensures at least 2 write operations per day, well within the 7-day inactivity threshold.

## Troubleshooting

### Database is paused
If your database gets paused, manually resume it from the Supabase dashboard. The workflow will keep it alive going forward.

### Workflow fails with "table not found"
- **Database 2**: Make sure you've created the `keep_alive` table using `create_keepalive_table.sql`
- **Database 1**: The `drivers` table should already exist in your water bottle management schema

### Permission errors (401/403)
The workflow includes fallback read queries. Even if insert/delete fails due to RLS policies, the read query will keep the database alive.

### Check workflow status
Go to the **Actions** tab in your GitHub repository to see detailed logs of each run.

## Technical Details

- Uses REST API with insert/delete operations
- Timestamps ensure unique records
- Automatic cleanup (delete immediately after insert)
- Fallback to read queries if write operations fail
- Runs on GitHub's infrastructure (no cost to you)
