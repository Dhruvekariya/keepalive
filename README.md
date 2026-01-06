# Supabase Keep Alive

Keeps your Supabase free-tier databases from pausing after 7 days of inactivity.

Runs twice daily (6 AM & 6 PM UTC), inserts a record into a `keep_alive` table, then deletes it immediately.

---

## Setup

### 1. Get your Supabase service role keys

For each database:
1. Open Supabase Dashboard
2. Go to Settings → API
3. Copy the **`service_role`** key (not the anon key)

### 2. Add keys to GitHub Secrets

```bash
gh secret set SUPABASE_URL_1     # Paste your Database 1 URL
gh secret set SUPABASE_KEY_1     # Paste your Database 1 service_role key
gh secret set SUPABASE_URL_2     # Paste your Database 2 URL
gh secret set SUPABASE_KEY_2     # Paste your Database 2 service_role key
```

Or set them manually: GitHub repo → Settings → Secrets and variables → Actions → New repository secret

### 3. Create keep_alive table in both databases

Open Supabase Dashboard → SQL Editor → New query

Run this in **Database 1**:

```sql
DROP TABLE IF EXISTS public.keep_alive CASCADE;

CREATE TABLE public.keep_alive (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    ping_time timestamptz DEFAULT now() NOT NULL
);

ALTER TABLE public.keep_alive ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations" ON public.keep_alive
    FOR ALL TO public USING (true) WITH CHECK (true);
```

Run the same SQL in **Database 2**.

### 4. Done

The workflow runs automatically twice a day. You can also trigger it manually:

```bash
gh workflow run keep-supabase-alive.yml
```

---

## How it works

- Inserts a record with timestamp
- Deletes the record immediately
- Write operations signal active database usage to Supabase
- Service role key bypasses RLS policies

---

## Verify it's working

```bash
gh run list --limit 1
```

Should show `success`. Check logs:

```bash
gh run view <run-id> --log | grep "✓"
```

Should see:
```
✓ Record inserted successfully with ID: X
✓ Database 1 kept alive successfully (insert+delete)
✓ Record inserted successfully with ID: Y
✓ Database 2 kept alive successfully (insert+delete)
```

---

## Troubleshooting

**Workflow fails**: Check that you used `service_role` key, not `anon` key

**Table not found**: Run the SQL script for Database 2

**Want to change schedule**: Edit `.github/workflows/keep-supabase-alive.yml` line 6
