# Alias Confusion

## What Was Broken
The resource block used `provider = local.wrong`, but no provider with alias `wrong` was declared.
Only `local.primary` and `local.secondary` existed.

## The Fix
Change the `provider` meta-argument to reference a valid alias:
```hcl
provider = local.primary
```

## Provider Alias Pattern
When you declare multiple provider blocks of the same type, each (except one) must have an `alias`.
Resources then opt into a specific configuration using `provider = <type>.<alias>`.

## Why It Matters
Provider aliases are essential for multi-region or multi-account deployments. Getting the alias wrong
causes a validation error before any infrastructure is touched.