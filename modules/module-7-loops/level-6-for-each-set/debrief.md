# Duplicate in toset()

## What Was Broken
`toset(["a", "b", "a"])` silently produces `{"a", "b"}` — the duplicate is dropped.
If you expect 3 files, you'll only get 2.

## How toset() Works
```hcl
toset(["a", "b", "a"])   # returns: {"a", "b"}  — deduplicated
toset(["a", "b", "c"])   # returns: {"a", "b", "c"}  — all unique
```

## Why It Matters
When building for_each maps from user-provided lists, silent deduplication can cause
fewer resources than expected. Always validate list inputs or use `type = set(string)`.

## Better Variable Type
```hcl
variable "names" {
  type = set(string)   # enforces uniqueness at input time
  default = ["a", "b"]
}
```

## Concepts
- `toset()` deduplicates; there is no error for duplicate values.
- `set(string)` as a variable type prevents duplicates from being passed at all.