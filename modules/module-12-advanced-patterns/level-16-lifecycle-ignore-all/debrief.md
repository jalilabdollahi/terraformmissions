# Ignoring Everything (Including Security)

## What Was Broken
`ignore_changes = all` instructs Terraform to never update the resource regardless of what changes.
A permission change from `0600` to `0777` would go undetected and uncorrected.

## The Fix
```hcl
lifecycle {
  ignore_changes = [content]
}
```

## ignore_changes Best Practices
| Use case | Recommendation |
|---|---|
| Externally updated content (e.g., app writes to file) | `ignore_changes = [content]` |
| Fully externally managed resource | `ignore_changes = all` (use sparingly) |
| Security-critical attributes | Never ignore |

## Why It Matters
`ignore_changes = all` is a blunt instrument that should be used only when Terraform should
never manage updates to a resource. Security-critical attributes like permissions, encryption
settings, and access controls should always be monitored.