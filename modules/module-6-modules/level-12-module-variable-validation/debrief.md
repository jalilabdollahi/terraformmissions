# Overly Strict Validation

## What Was Broken
The condition `var.env == "valid"` only allows the literal string `"valid"`.
Passing any real environment name (like `"prod"`) causes a validation error.

## Better Validation with contains()
```hcl
validation {
  condition     = contains(["dev", "staging", "prod"], var.env)
  error_message = "env must be one of: dev, staging, prod."
}
```

## Validation Block Syntax
```hcl
variable "env" {
  type = string
  validation {
    condition     = <bool expression using var.env>
    error_message = "Human-readable message shown on failure."
  }
}
```

## Concepts
- `contains(list, value)` — returns true if `value` is in `list`
- Validation runs at plan time before any API calls
- `error_message` must be a static string (no interpolation of `var.env`)