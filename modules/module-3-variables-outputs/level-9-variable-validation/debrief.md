# The Condition Always Fails

## What Was Broken
The validation condition `var.env == "prod"` only accepts the single value `"prod"`. The default
`"dev"` fails this condition, so every `terraform plan` (without explicitly passing `-var`) fails.

## The Fix
Use `contains()` to check against a list of valid values:

```hcl
validation {
  condition     = contains(["dev", "staging", "prod"], var.env)
  error_message = "env must be one of: dev, staging, prod."
}
```

## Useful Validation Conditions

| Pattern | Example |
|--------|---------|
| Enum check | `contains(["a","b","c"], var.x)` |
| Length check | `length(var.x) >= 3` |
| Regex match | `can(regex("^[a-z]+$", var.x))` |
| Range check | `var.port >= 1024 && var.port <= 65535` |
| Non-empty | `length(var.x) > 0` |

## Why It Matters
A validation condition that rejects the default value is nearly always a bug — it means the module
cannot be used without explicitly overriding the variable every time.