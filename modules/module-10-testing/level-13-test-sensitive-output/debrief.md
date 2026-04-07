# Asserting a Sensitive Output Value

## What Was Broken
The `assert` condition used `output.password == "secret123"`, which requires Terraform to evaluate
a sensitive value and expose it in a comparison. Terraform blocks this to prevent sensitive data
from appearing in logs or plan output.

## Testing Sensitive Outputs Safely

Instead of testing the exact value, test structural properties:
```hcl
assert {
  condition     = output.password != ""
  error_message = "Password should not be empty."
}

assert {
  condition     = length(output.password) >= 16
  error_message = "Password should be at least 16 characters."
}
```

## Why Terraform Blocks It
Terraform's sensitive value system ensures secrets do not appear in:
- CLI output
- Plan files
- State file diffs shown in logs
- Test assertion output

## Why It Matters
Security-aware test design avoids accidentally printing secrets in CI/CD logs. Always test
sensitive outputs for structural correctness (non-empty, minimum length, format) rather than
exact value equality.