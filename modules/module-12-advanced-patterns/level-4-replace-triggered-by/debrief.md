# Triggered by Nothing

## What Was Broken
`replace_triggered_by = [null_resource.wrong_ref]` references a resource label `wrong_ref` that
does not exist. Terraform validates all references during `terraform validate`.

## The Fix
```hcl
lifecycle {
  replace_triggered_by = [null_resource.trigger]
}
```

## replace_triggered_by
This lifecycle argument forces replacement of the resource when any of the listed resources change.
All listed resources must be declared in the same configuration.

## Why It Matters
Dangling references are caught at validate/plan time, not at apply time. Always ensure every
resource reference points to a declared resource.