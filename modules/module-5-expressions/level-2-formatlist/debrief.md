# Format List

## What Was Broken
`formatlist("%s-%s", ["a","b"])` provided two placeholders but only one list. Each `%s` needs
its own list argument — or you use a single list with one placeholder.

## The Fix
```hcl
locals {
  labels = formatlist("%s", ["a", "b"])
  # Produces: ["a", "b"]
}
```

## formatlist() vs format()
- `format()` produces a single string
- `formatlist()` maps a format string over one or more lists, producing a list of strings

```hcl
formatlist("%s-%d", ["web", "api"], [1, 2])
# → ["web-1", "api-2"]
```

## Why It Matters
`formatlist()` is useful for generating resource names, tags, or labels in bulk from lists of
values — a common pattern when combined with `for_each`.