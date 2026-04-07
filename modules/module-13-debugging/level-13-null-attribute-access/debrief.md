# Handling the Absent Value

## What Was Broken
`local.file_content = data.local_file.maybe.content` will error if the data source fails.
The error propagates and prevents planning.

## The Fix
```hcl
locals {
  file_content = try(data.local_file.maybe.content, "default content")
}
```

## try() Function
`try(expression1, expression2, ...)` evaluates expressions left to right and returns the first
one that does not produce an error. If all fail, it throws the last error.

Use cases:
- Optional data source attributes
- Accessing attributes that may not exist in older provider versions
- Providing fallbacks for computed values

## Why It Matters
Real infrastructure often has optional components. `try()` enables graceful handling of absent
resources or missing attributes without failing the entire configuration.