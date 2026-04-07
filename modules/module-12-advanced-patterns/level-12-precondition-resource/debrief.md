# Too Strict a Gate

## What Was Broken
`condition = var.env == "production"` rejects all non-production environments, making it
impossible to plan with `var.env = "dev"` (the default).

## The Fix
```hcl
precondition {
  condition     = contains(["dev", "staging", "production"], var.env)
  error_message = "Environment must be one of: dev, staging, production."
}
```

## Precondition Best Practices
- Conditions should validate *validity*, not enforce a specific value unless truly required.
- Use `contains()` for membership checks against an allowlist.
- Pair preconditions with variable `validation` blocks for early feedback.

## Why It Matters
Overly strict preconditions can block legitimate plans. Conditions should reflect your actual
business rules, not incidental constraints.