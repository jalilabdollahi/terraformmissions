# Unknown for_each Keys

## What Was Broken
`for_each = { for r in random_string.ids : r.result => r.result }` uses computed `result`
values as keys. Since these are unknown at plan time, Terraform cannot enumerate the instances
that will be created.

## The Fix
Use static, predetermined keys:
```hcl
for_each = toset(["item-0", "item-1", "item-2"])
```

## for_each Key Requirements
- Keys must be **known at plan time**
- Keys must be **strings or null** (not sensitive values)
- Keys must form a **finite, deterministic set**

## Why It Matters
Terraform builds its execution plan by enumerating all resource instances. Unknown keys make
this impossible — Terraform cannot create a plan that says "I will create these specific resources"
if it doesn't know what those resources are until apply.