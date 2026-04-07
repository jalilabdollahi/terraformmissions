# Ignoring What Doesn't Exist

## What Was Broken
`ignore_changes = [nonexistent_attr]` references an attribute that doesn't exist on `local_file`.
Terraform validates all attribute names listed in `ignore_changes` during `terraform validate`.

## The Fix
```hcl
lifecycle {
  ignore_changes = [content]
}
```

Or to ignore all attribute changes:
```hcl
lifecycle {
  ignore_changes = all
}
```

## `ignore_changes` Use Cases

| Scenario | What to ignore |
|---------|----------------|
| External system modifies tags | `ignore_changes = [tags]` |
| File content managed outside Terraform | `ignore_changes = [content]` |
| Auto-scaling modifies instance count | `ignore_changes = [desired_capacity]` |

## Valid `local_file` Attributes for `ignore_changes`
- `content`
- `content_base64`
- `filename`
- `file_permission`
- `directory_permission`

## `ignore_changes = all`
Using `all` is a blunt instrument — Terraform will never update the resource even when your
configuration changes. Use it sparingly, only when the entire lifecycle is managed externally.

## Why It Matters
Attribute names in `ignore_changes` are validated against the resource schema. A single typo
turns into a validate-time error. Cross-reference with provider documentation when in doubt.