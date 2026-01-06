#!/bin/bash

# Script to update GitHub secrets with Supabase service role keys
# This enables insert/delete operations without modifying RLS policies

set -e

echo "================================================"
echo "  Update GitHub Secrets with Service Role Keys"
echo "================================================"
echo ""
echo "⚠️  IMPORTANT: You need the SERVICE ROLE keys, not the anon/public keys"
echo ""
echo "How to get your service role keys:"
echo "1. Go to Supabase Dashboard"
echo "2. Select your project"
echo "3. Go to Settings → API"
echo "4. Copy the 'service_role' key (NOT 'anon')"
echo ""
echo "================================================"
echo ""

# Update Database 1 service role key
echo "📝 Setting SUPABASE_KEY_1 (Database 1 service role key)..."
echo "Paste your Database 1 service_role key and press Enter:"
echo ""
gh secret set SUPABASE_KEY_1

echo ""
echo "✅ SUPABASE_KEY_1 updated successfully!"
echo ""

# Update Database 2 service role key
echo "📝 Setting SUPABASE_KEY_2 (Database 2 service role key)..."
echo "Paste your Database 2 service_role key and press Enter:"
echo ""
gh secret set SUPABASE_KEY_2

echo ""
echo "✅ SUPABASE_KEY_2 updated successfully!"
echo ""

echo "================================================"
echo "  ✅ All secrets updated successfully!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. The workflow will now use service role keys"
echo "2. Insert/delete operations will work without RLS policy changes"
echo "3. Test by running: gh workflow run keep-supabase-alive.yml"
echo ""
echo "To verify the secrets were set:"
echo "  gh secret list"
echo ""
