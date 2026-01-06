# Supabase Keep Alive

Automatically keeps Supabase databases active by performing write operations twice daily, preventing them from pausing due to inactivity on the free tier.

## How it works

GitHub Actions runs a scheduled workflow **twice daily** (every 12 hours at 6 AM and 6 PM UTC) that:

1. **Inserts** a temporary record into your database
2. **Deletes** the record immediately after
3. This active write/delete cycle signals strong database activity to Supabase

### Database-specific operations:

- **Database 1**: Inserts/deletes a temporary record in the `keep_alive` table
- **Database 2**: Inserts/deletes a temporary record in the `keep_alive` table

Both databases use dedicated `keep_alive` tables that are separate from your production schema, ensuring no interference with your application data.

This approach is more effective than simple read queries because write operations are a stronger indicator of active database usage.

## Setup

### 1. Configure GitHub Secrets

Add your Supabase project details as GitHub Secrets in your repository:

- `SUPABASE_URL_1` - Full URL for database 1 (e.g., `https://xxxxx.supabase.co`)
- `SUPABASE_KEY_1` - **Service role key** for database 1 (NOT anon/public)
- `SUPABASE_URL_2` - Full URL for database 2 (e.g., `https://xxxxx.supabase.co`)
- `SUPABASE_KEY_2` - **Service role key** for database 2 (NOT anon/public)

**Important:** Use the **service_role** key to enable insert/delete operations without RLS policy modifications.

### 2. Verify keep_alive tables exist

**Database 1**: Already has a `keep_alive` table ✅ (no action needed)

**Database 2**: Run the SQL script `create_keepalive_table.sql` in your Database 2 SQL Editor:

```sql
-- This creates the keep_alive table with proper RLS policies
-- See create_keepalive_table.sql for the full script
```

If you already ran this script, you're all set! ✅

### 3. Automated Execution

- The workflow runs automatically twice daily (6 AM & 6 PM UTC)
- You can also trigger it manually from the GitHub Actions tab
- No additional configuration needed!

## Getting your Supabase details

1. Go to your Supabase project dashboard
2. Navigate to **Settings** → **General**
3. Copy the "Project URL" (e.g., `https://xxxxxxxxxxxxx.supabase.co`)
4. Navigate to **Settings** → **API**
5. Copy the **`service_role`** key (scroll down to find it)
   - ⚠️ **Do NOT use the anon/public key**
   - The service_role key bypasses RLS and allows insert/delete operations

## Quick Setup with Script

The easiest way to set up your secrets:

```bash
cd /Users/dhruvvekariya/keepalive
./update-secrets.sh
```

The script will prompt you to paste your service role keys.

## Manual Setup (Alternative)

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Update/create these secrets:
   - `SUPABASE_URL_1` - Your Database 1 URL
   - `SUPABASE_KEY_1` - Your Database 1 **service_role** key
   - `SUPABASE_URL_2` - Your Database 2 URL
   - `SUPABASE_KEY_2` - Your Database 2 **service_role** key

Or use the GitHub CLI:

```bash
gh secret set SUPABASE_KEY_1  # Paste service_role key when prompted
gh secret set SUPABASE_KEY_2  # Paste service_role key when prompted
```

## Schedule Details

The workflow runs twice daily at:
- **6:00 AM UTC** (morning run)
- **6:00 PM UTC** (evening run)

This ensures at least 2 write operations per day, well within the 7-day inactivity threshold.

## Troubleshooting

### Database is paused
If your database gets paused, manually resume it from the Supabase dashboard. The workflow will keep it alive going forward.

### Workflow fails with "table not found"
- **Database 1**: The `keep_alive` table should already exist in your schema
- **Database 2**: Make sure you've created the `keep_alive` table using `create_keepalive_table.sql`

### Permission errors (401/403)
The workflow includes fallback read queries. Even if insert/delete fails due to RLS policies, the read query will keep the database alive.

### Check workflow status
Go to the **Actions** tab in your GitHub repository to see detailed logs of each run.

## Security Notes

### Why Service Role Keys?

- **Bypasses RLS**: No need to modify Row Level Security policies
- **Full permissions**: Can insert and delete records
- **Secure storage**: GitHub Secrets are encrypted
- **No exposure**: Keys never appear in logs or code

### Is this safe?

✅ **Yes, when stored in GitHub Secrets:**
- GitHub encrypts all secrets
- Secrets are never visible in workflow logs
- Only your GitHub Actions can access them
- The workflow only performs insert+delete operations

⚠️ **Important:**
- Never commit service role keys to git
- Only store them in GitHub Secrets
- The workflow deletes records immediately after inserting

## Technical Details

- Uses REST API with insert/delete operations
- Service role key bypasses RLS for write operations
- Timestamps ensure unique records
- Automatic cleanup (delete immediately after insert)
- Fallback to read queries if write operations fail
- Runs on GitHub's infrastructure (no cost to you)
