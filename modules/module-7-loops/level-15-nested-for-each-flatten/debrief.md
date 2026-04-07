# Nested for Expression Needs flatten()

## What Was Broken
```hcl
[for svc in var.services : [for port in svc.ports : "..."]]
# Returns: [["web-80", "web-443"], ["api-8080"]]  — list of lists
```

`toset()` expects a flat list, not a list of lists.

## The Fix: flatten()
```hcl
flatten([for svc in var.services : [for port in svc.ports : "${svc.name}-${port}"]])
# Returns: ["web-80", "web-443", "api-8080"]  — flat list
```

## flatten() Function
`flatten(list_of_lists)` recursively flattens nested lists into a single list.

```hcl
flatten([[1, 2], [3, 4]])   # => [1, 2, 3, 4]
flatten([[1, [2, 3]], [4]]) # => [1, 2, 3, 4]
```

## Concepts
- Nested `for` expressions produce nested lists
- `flatten()` collapses nested lists to a single depth
- `toset(flatten([...]))` is a common pattern for cross-product for_each