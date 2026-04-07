# Impossible Precondition

## What Was Broken
`precondition { condition = var.item_count > 10 }` requires a value greater than 10.
With `default = 1`, this condition always fails.

## lifecycle Precondition
```hcl
resource "local_file" "items" {
  lifecycle {
    precondition {
      condition     = var.item_count > 0   # sensible guard
      error_message = "item_count must be greater than 0."
    }
  }
  # ...
}
```

## Precondition vs Validation
| Feature | `validation` block | `lifecycle precondition` |
|--------|-------------------|--------------------------|
| Where | `variable` block | `resource` / `data` lifecycle |
| When | Plan time (variable evaluation) | Plan time (resource evaluation) |
| Scope | Variable value only | Can reference other values |

## Concepts
- Preconditions check assumptions about the context in which a resource is used.
- They run during plan and apply phases.