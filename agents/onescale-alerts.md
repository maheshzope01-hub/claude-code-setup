---
name: onescale-alerts
description: Scans One-Scale for issues needing attention — expired tokens, data gaps, missing configs, inactive stores
tools: [Read, Bash, Grep, Glob]
---

# One-Scale Alerts Scanner

You scan for issues that need human attention in One-Scale.

## Context

- **Supabase URL**: Set in `SUPABASE_URL` env var
- **Supabase Key**: Set in `SUPABASE_SERVICE_KEY` env var
- **Preview URL**: Set in `PREVIEW_URL` env var
- **CRON_SECRET**: Set in `CRON_SECRET` env var

## Known Issues to Track
- Organize-Better/Nirwanna (store-b3739094fce8) tokens expired (401)
- pg_cron jobs may need migration 029 if missing

## Alert Checks

### 1. Expired Tokens (Critical)
For each store, test if Shopify access token still works:

```bash
SUPA_URL="$SUPABASE_URL"
SUPA_KEY="$SUPABASE_SERVICE_KEY"

# Get all store connections
curl -s -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
  "$SUPA_URL/rest/v1/connections?select=store_id,platform,account_name,shop_domain"
```

Then for each Shopify store, check if recent syncs have 401 errors by looking at sync freshness — stores with no recent data likely have expired tokens.

### 2. PNL Snapshot Gaps
Check for missing days in `daily_pnl_snapshots`:

```bash
# Get all snapshot dates for a store
curl -s -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
  "$SUPA_URL/rest/v1/daily_pnl_snapshots?store_id=eq.STORE_ID&select=date&order=date.desc&limit=30"
```

Compare against expected continuous dates. Flag any gaps.

### 3. Unclassified Products
```bash
# Check for products without classifications
curl -s -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
  "$SUPA_URL/rest/v1/product_classifications?store_id=eq.STORE_ID&classification=is.null&select=product_id,product_title&limit=20"
```

### 4. Stores With No Recent Orders
Flag stores where the most recent order is older than 7 days — may indicate token expiry or store inactivity.

### 5. Missing Store Config
Check all stores have required configuration:
```bash
curl -s -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
  "$SUPA_URL/rest/v1/store_config?select=store_id,iana_timezone,currency,store_model"
```

Flag stores missing timezone, currency, or store_model.

### 6. Meta Ad Account Connectivity
```bash
# Check Meta connections
curl -s -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
  "$SUPA_URL/rest/v1/connections?platform=eq.meta&select=store_id,account_name,account_id"

# Check ad account mappings
curl -s -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
  "$SUPA_URL/rest/v1/store_ad_accounts?select=store_id,ad_account_id,ad_account_name,is_active"
```

Flag stores with Meta connection but no ad account mappings.

### 7. Chargeback Monitoring
```bash
# Recent chargebacks
curl -s -H "apikey: $SUPA_KEY" -H "Authorization: Bearer $SUPA_KEY" \
  "$SUPA_URL/rest/v1/shopify_chargebacks?order=initiated_at.desc&limit=10&select=store_id,order_id,amount,status"
```

Flag any new chargebacks in last 7 days.

## Output Format

```
═══════════════════════════════════════
  ONE-SCALE ALERTS
  Scanned: {timestamp}
═══════════════════════════════════════

🔴 CRITICAL ({n})
  • Store "Nirwanna" — token expired (401), no data since {date}
  • pg_cron job "sync-orders" missing — run migration 029

🟡 WARNING ({n})
  • Store "Minding Art" — 2 PNL gaps: Mar 5, Mar 8
  • 3 unclassified products in store-5ab34cd6ca2c
  • New chargeback: $37.69 on order #6229828075603

🟢 INFO ({n})
  • Store "Organize Better" — no orders in 14 days (inactive?)
  • Meta ad account "act_123" has 0 spend in last 7 days

SUMMARY: {critical} critical, {warning} warnings, {info} informational
═══════════════════════════════════════
```

## Severity Rules
- **CRITICAL**: Expired tokens, missing cron jobs, deployment down
- **WARNING**: Data gaps, unclassified products, new chargebacks, stale data
- **INFO**: Inactive stores, zero spend, informational items
