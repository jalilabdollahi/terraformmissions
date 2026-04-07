# Wrong Iterator in Dynamic Block

## What Was Broken
`each.value.name` and `each.value.value` are not valid in a `for` expression or outside a `for_each` resource.
Inside `for k, v in var.tags`, use `k` and `v` directly.

## Correct for Expression
```hcl
content = join("\n", [for k, v in var.tags : "${k}=${v}"])
```

## Dynamic Block Iterator Naming
When using `dynamic` blocks, the iterator is named after the block label:
```hcl
dynamic "tag" {
  for_each = var.tags
  content {
    key   = tag.key     # not each.key
    value = tag.value   # not each.value
  }
}
```

## Concepts
- In `for` expressions: use the declared loop variables (`k`, `v`)
- In `dynamic` blocks: use `<block_label>.key` and `<block_label>.value`
- `each` is only available in `for_each` resources/modules