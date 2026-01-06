# Setup Instructions for Supabase Keep Alive

## Current Status

The workflow is **working** but using fallback read queries instead of insert/delete operations due to Row Level Security (RLS) policies.

### Current Behavior:
- ⚠️ Insert operations fail (RLS permissions)
- ✅ Falls back to read queries (HTTP 200)
- ✅ Databases stay alive

### Optimal Behavior (Recommended):
- ✅ Insert + Delete operations succeed
- ✅ Stronger activity signal to Supabase
- ✅ More reliable keepalive mechanism

---

## Option 1: Enable Write Permissions (RECOMMENDED)

This allows the workflow to perform insert/delete operations for maximum effectiveness.

### For Database 1 (Water Bottle Management)

Run this SQL in your **Database 1** SQL Editor:

```sql
-- Add RLS policies to allow anonymous inserts/deletes on drivers table
-- This is ONLY for keepalive records (name starts with 'keepalive_')

CREATE POLICY "Allow keepalive driver inserts" ON public.drivers
    FOR INSERT TO anon
    WITH CHECK (name LIKE 'keepalive_%');

CREATE POLICY "Allow keepalive driver deletes" ON public.drivers
    FOR DELETE TO anon
    USING (name LIKE 'keepalive_%');
```

### For Database 2

Run the SQL in `create_keepalive_table.sql` which already includes the correct RLS policies:

```bash
# Open your Database 2 SQL Editor and paste the contents of create_keepalive_table.sql
```

The script creates:
- `keep_alive` table
- Anonymous insert/delete/select permissions
- Proper indexes

---

## Option 2: Keep Current Setup (Fallback Mode)

If you prefer not to modify RLS policies, the current setup works fine:

- ✅ Read queries keep databases alive
- ✅ No security changes needed
- ⚠️ Less robust than write operations
- ⚠️ Relies on fallback mechanism

**No action needed** - your databases are already being kept alive with the current workflow.

---

## How to Apply Changes

### Step 1: Choose Your Option

- **Option 1** (Recommended): Better keepalive, requires SQL changes
- **Option 2**: Works now, no changes needed

### Step 2: If Choosing Option 1

1. Open **Database 1** in Supabase Dashboard
2. Go to **SQL Editor**
3. Run the SQL for Database 1 (see above)
4. Open **Database 2** in Supabase Dashboard
5. Go to **SQL Editor**
6. Copy and paste all contents from `create_keepalive_table.sql`
7. Run the script

### Step 3: Test

After applying changes, manually trigger the workflow:

1. Go to your GitHub repository
2. Click **Actions** tab
3. Click **Keep Supabase Alive** workflow
4. Click **Run workflow**
5. Wait for completion and check logs

You should see:
```
✓ Driver inserted successfully with ID: <uuid>
✓ Database 1 kept alive successfully (insert+delete)
```

---

## Security Considerations

### Is it safe to allow anonymous writes?

**Yes**, when properly restricted:

1. **Database 1**: Only allows writes where `name LIKE 'keepalive_%'`
   - Cannot affect real driver data
   - Workflow deletes records immediately
   - Timestamp ensures uniqueness

2. **Database 2**: Dedicated `keep_alive` table
   - Separate from production data
   - Only used for keepalive pings
   - No sensitive information

### Option 3: Use Service Role Keys (EASIEST - RECOMMENDED)

Instead of modifying RLS policies, simply use service role keys:

1. Get your service_role keys from Supabase (Settings → API)
2. Run the update script:
   ```bash
   cd /Users/dhruvvekariya/keepalive
   ./update-secrets.sh
   ```
3. Paste your service role keys when prompted

**Benefits:**
- ✅ No SQL changes needed
- ✅ Bypasses RLS automatically
- ✅ Insert/delete operations work immediately
- ✅ Secure when stored in GitHub Secrets

**Or use GitHub CLI:**
```bash
gh secret set SUPABASE_KEY_1  # Paste Database 1 service_role key
gh secret set SUPABASE_KEY_2  # Paste Database 2 service_role key
```

⚠️ **Never commit service role keys to git** - only store them in GitHub Secrets.

---

## Troubleshooting

### Workflow succeeds but I want to enable writes

Follow **Option 1** instructions above.

### Insert still fails after running SQL

1. Check that RLS policies were created:
   ```sql
   -- In SQL Editor
   SELECT * FROM pg_policies WHERE tablename = 'drivers';
   SELECT * FROM pg_policies WHERE tablename = 'keep_alive';
   ```

2. Verify `anon` role has permissions

3. Check GitHub Actions logs for specific error messages

### How to verify it's working?

Check the **Actions** tab in GitHub:
- Green checkmark = Success
- Look for "✓ Database X kept alive successfully (insert+delete)"

---

## Summary

| Aspect | Current (Fallback) | With Option 1 |
|--------|-------------------|---------------|
| Databases stay alive | ✅ Yes | ✅ Yes |
| Insert/Delete works | ❌ No | ✅ Yes |
| Stronger activity signal | ⚠️ Moderate | ✅ Strong |
| Setup required | ✅ None | 🔧 Run SQL |
| Security impact | ✅ No change | ✅ Minimal (restricted) |

**Recommendation:** Apply Option 1 for best results, but your databases are already protected with the current fallback mechanism.
