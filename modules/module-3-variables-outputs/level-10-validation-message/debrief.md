# An Error Message Must Have Words

## What Was Broken
`error_message = ""` (empty string) is not allowed. Terraform requires a non-empty, meaningful
error message to help users understand why their value was rejected.

## The Fix
```hcl
validation {
  condition     = var.port > 0
  error_message = "port must be a positive integer greater than 0."
}
```

## Writing Good Error Messages
A good `error_message` should:
1. State what is wrong with the provided value
2. Describe what a valid value looks like
3. Be a complete sentence ending with a period

## Examples

| Condition | Good error_message |
|----------|-------------------|
| `var.port > 0` | `"port must be a positive integer."` |
| `contains(["dev","prod"], var.env)` | `"env must be 'dev' or 'prod'."` |
| `length(var.name) >= 3` | `"name must be at least 3 characters long."` |

## Why It Matters
Error messages are part of your module's user interface. A clear message saves time for everyone
who uses the module — including your future self.