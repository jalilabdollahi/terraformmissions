# Index Out of Range

## What Was Broken
`count = 3` creates instances with indices `0`, `1`, and `2`. Accessing index `3` is out of bounds
and causes a plan-time error.

## The Fix
```hcl
output "first_config" {
  value = data.local_file.configs[0].content
}
```

## Count Indexing Rules
- `count = N` creates instances indexed `0` through `N-1`.
- Access them with `resource_type.name[index]`.
- Within the resource, use `count.index` to get the current instance's index.

## Accessing All Instances
```hcl
output "all_configs" {
  value = [for f in data.local_file.configs : f.content]
}
```