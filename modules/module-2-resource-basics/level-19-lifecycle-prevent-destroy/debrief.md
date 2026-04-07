# Protected from Deletion

## What Was Broken
`lifecycle { prevent_destroy = true }` instructs Terraform to abort any plan that would destroy
this resource. This is an intentional safety feature for critical production resources.

## The Fix
```hcl
lifecycle {
  prevent_destroy = false
}
```

## `lifecycle` Meta-Arguments

| Argument                | Description |
|------------------------|-------------|
| `prevent_destroy`       | Block destroy operations when `true` |
| `create_before_destroy` | Create replacement before destroying old resource |
| `ignore_changes`        | Ignore specified attribute changes in future plans |
| `replace_triggered_by`  | Replace this resource when other resources change |

## When to Use `prevent_destroy = true`
- Production databases
- S3 buckets with irreplaceable data
- DNS zones
- Any resource where accidental deletion is catastrophic

## Why It Matters
`prevent_destroy` is a deliberate safeguard. Removing it requires a conscious code change, making
accidental destruction much harder — exactly as designed.