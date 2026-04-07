# ID Type Mismatch

## What Was Broken
`id = 12345` provides a number where a string is required. The `import` block's `id` argument
is always of type `string`.

## The Fix
```hcl
import {
  to = local_file.config
  id = "${path.module}/config.txt"
}
```

## Import ID Conventions
- `local_file`: the ID is the absolute file path
- `aws_instance`: the ID is the instance ID (e.g., `"i-1234567890abcdef0"`)
- Always consult the provider documentation for the correct ID format

## Why It Matters
Using the wrong ID type causes a validation error. Using the wrong ID value causes the import
to fail at plan/apply time with a "resource not found" error from the provider.