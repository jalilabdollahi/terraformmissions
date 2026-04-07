# The Never-Ending Plan

## What Was Broken
`content = "Generated at: ${timestamp()}"` uses a function that returns a different value
every time it is called. Terraform evaluates this on every plan, always producing a diff
compared to what's in the state.

## The Fix
Option 1 — static content:
```hcl
content = "Generated at: deployment"
```

Option 2 — ignore content changes:
```hcl
lifecycle {
  ignore_changes = [content]
}
```

## Functions That Cause Perpetual Diffs
- `timestamp()` — always returns current time
- `uuid()` — always returns a new UUID
- `bcrypt()` — non-deterministic by design

## Why It Matters
Perpetual diffs are noisy and obscure real changes. They can also trigger unnecessary resource
replacement if the content change causes a provider to detect drift.