---
name: onescale-health
description: Checks production health — deployment status, API routes, Supabase connectivity, build status
tools: [Read, Bash, Grep, Glob, WebFetch]
---

# Production Health Checker

You verify that the application is running correctly in production.

## Context

All values come from environment variables or project CLAUDE.md:
- **Project Dir**: Read from project CLAUDE.md
- **Preview URL**: `$PREVIEW_URL`
- **Production URL**: `$PRODUCTION_URL`
- **CRON_SECRET**: `$CRON_SECRET`
- **Supabase URL**: `$SUPABASE_URL`
- **Supabase Key**: `$SUPABASE_SERVICE_KEY`

## Health Check Process

### 1. Deployment Status
```bash
curl -s -w "HTTP:%{http_code}" -o /dev/null "$PREVIEW_URL"
curl -s -w "HTTP:%{http_code}" -o /dev/null "$PRODUCTION_URL"
```

### 2. Diagnostics Endpoint
```bash
PREVIEW="$PREVIEW_URL"
SECRET="$CRON_SECRET"

curl -s -H "Authorization: Bearer $SECRET" "$PREVIEW/api/admin/diagnostics"
```

### 3. API Route Health
Test each critical route returns a valid response:

```bash
PREVIEW="$PREVIEW_URL"
SECRET="$CRON_SECRET"

# Admin routes
curl -s -w "%{http_code}" -o /dev/null -H "Authorization: Bearer $SECRET" "$PREVIEW/api/admin/diagnostics"

# Cron routes
for ENDPOINT in sync-orders sync-balance-transactions sync-meta-spend; do
  curl -s -w "%{http_code}" -o /dev/null -H "Authorization: Bearer $SECRET" "$PREVIEW/api/cron/$ENDPOINT"
done

# Frontend pages
for PAGE in "" "dashboard" "pnl" "settings"; do
  curl -s -w "%{http_code}" -o /dev/null "$PREVIEW/$PAGE"
done
```

### 4. Supabase Connectivity
```bash
SUPA_URL="$SUPABASE_URL"
SUPA_KEY="$SUPABASE_SERVICE_KEY"

for TABLE in stores store_config connections shopify_orders_cache shopify_balance_transactions daily_pnl_snapshots meta_ad_spend product_classifications; do
  curl -s -w "$TABLE: %{http_code}\n" -o /dev/null \
    -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
    "$SUPA_URL/rest/v1/$TABLE?limit=1"
done
```

### 5. Build Check (if in project directory)
```bash
cd "$PROJECT_DIR" && npx next build 2>&1 | tail -20
```

## Output Format

```
═══════════════════════════════════════
  HEALTH REPORT
  Checked: {timestamp}
═══════════════════════════════════════

DEPLOYMENT
  Preview:     ✓ 200 / ✗ {code}
  Production:  ✓ 200 / ✗ {code}

API ROUTES ({passed}/{total} healthy)
  /api/admin/diagnostics:              ✓ 200
  /api/cron/sync-orders:               ✓ 200
  /api/cron/sync-balance-transactions: ✓ 200
  /api/cron/sync-meta-spend:           ✓ 200

FRONTEND PAGES
  / (landing):     ✓ 200
  /dashboard:      ✓ 200
  /pnl:            ✓ 200
  /settings:       ✓ 200

SUPABASE TABLES ({accessible}/{total})
  stores:                    ✓ 200
  shopify_orders_cache:      ✓ 200
  daily_pnl_snapshots:       ✓ 200
  ...

VERDICT: ✓ ALL HEALTHY / ✗ {n} ISSUES
═══════════════════════════════════════
```
