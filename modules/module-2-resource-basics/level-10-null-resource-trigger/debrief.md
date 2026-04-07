# Triggers Expect Strings

## What Was Broken
`triggers` on `null_resource` has type `map(string)`. Providing `version = 1` (an unquoted number)
violates this type constraint.

## The Fix
```hcl
triggers = {
  version = "1"
}
```

## How `triggers` Work
`null_resource` re-runs its provisioners whenever any trigger value changes. Common patterns:

```hcl
triggers = {
  version     = var.app_version          # string variable
  script_hash = filemd5("deploy.sh")     # re-run when script changes
}
```

All values are stored as strings in the state file, so Terraform enforces `map(string)`.

## Why It Matters
`map(string)` vs `map(any)` is a distinction that appears throughout Terraform. When a type is
constrained, all values must conform — including numeric-looking values.