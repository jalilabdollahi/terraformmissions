# Wrong Dynamic Block Name

## What Was Broken
The `dynamic` block label must match the nested block type name exactly.
`dynamic "setting"` generates `setting` blocks, not `settings` blocks.

## dynamic Block Syntax
```hcl
dynamic "<block_type>" {
  for_each = var.items
  content {
    # uses <block_type>.key, <block_type>.value
  }
}
```

The `<block_type>` must be the exact name of the nested block that the resource accepts.

## Common Pattern with null_resource
For `null_resource`, use `triggers` instead of dynamic blocks:
```hcl
resource "null_resource" "demo" {
  triggers = {
    for pair in var.config_pairs : pair.key => pair.value
  }
}
```

## Concepts
- `dynamic` block name = the nested block type it produces
- The iterator object inside `content {}` is named after the dynamic block label