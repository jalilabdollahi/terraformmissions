# Sensitive Keys Forbidden

## What Was Broken
`for_each = var.service_tokens` used a sensitive variable. Terraform cannot use sensitive values
as `for_each` keys because the keys appear in resource addresses and plan output.

## The Fix
```hcl
for_each = nonsensitive(var.service_tokens)
```

## nonsensitive() vs sensitive()
- `sensitive(value)` — marks a value as sensitive (hides it in output)
- `nonsensitive(value)` — asserts that a value is safe to expose (removes sensitivity marking)

## When to Use nonsensitive()
Only when the value is genuinely non-sensitive (e.g., service names as keys, even if the
overall map is sensitive). Never use `nonsensitive()` on actual secrets.

## Why It Matters
This constraint prevents resource addresses (which appear in logs and state) from containing
secret values. If you need sensitive keys, restructure to use non-sensitive keys separately.