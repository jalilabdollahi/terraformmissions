# Unknown at Plan Time

## What Was Broken
`count = length(random_string.suffix.result)` depends on a value that is computed during apply.
Terraform requires `count` (and `for_each` keys) to be known at plan time so it can show you
exactly what will be created, updated, or destroyed.

## The Fix
Use a static value that is known before apply:
```hcl
count = 4
```

## What Can Be Unknown at Plan Time
| Attribute | Known at plan? |
|---|---|
| Static literals | Always |
| Variable defaults | Always |
| `random_string.result` | No — computed at apply |
| `local_file.filename` | Yes — set in config |

## Why It Matters
This constraint ensures Terraform plans are meaningful. If counts were unknown, the plan would
show "some number of resources" instead of exact counts.