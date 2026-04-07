# String vs Reference

## What Was Broken
`provider = "local.primary"` is a string literal. Terraform expects a provider configuration
reference, which is written without quotes: `provider = local.primary`.

## The Fix
```hcl
# Wrong
provider = "local.primary"

# Correct
provider = local.primary
```

## Why It Matters
Terraform uses a distinct syntax for provider references to distinguish them from string values.
This is consistent with how resource references work elsewhere in HCL — they are bare identifiers,
not strings.