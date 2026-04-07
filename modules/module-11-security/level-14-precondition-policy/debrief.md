# Precondition Blocks Production Deployment

## What Was Broken
The precondition `condition = var.env != "production"` was intended to gate invalid environments,
but it accidentally blocked the most important environment: production.

## Allowlist vs Denylist
Security best practice prefers allowlists (explicitly allow known-good values) over denylists
(explicitly block known-bad values):

```hcl
# Denylist (fragile — needs updating for every new bad value)
condition = var.env != "prod" && var.env != "production" && var.env != "prd"

# Allowlist (robust — only allows explicitly approved values)
condition = contains(["dev", "staging", "production"], var.env)
```

## Precondition vs Variable Validation
Both are appropriate here; the solution uses both for defence in depth:
- **Variable validation** catches the problem at input time (before any plan).
- **Precondition** provides a safety net at resource apply time.

## Why It Matters
A backwards security policy is often worse than no policy — it blocks legitimate work while
providing no actual protection. Always test security checks against both valid and invalid inputs.