# Empty Error Message

## What Was Broken
Terraform's `assert` block requires a non-empty `error_message`. An empty string `""` is rejected
because when the condition fails, the error message is the only context the operator receives.

## Good Error Messages
A useful `error_message` should:
1. Describe what the expected value or state should be.
2. Ideally include the actual value using expression interpolation.
3. Be actionable — tell the reader how to fix the issue.

```hcl
assert {
  condition     = output.count > 0
  error_message = "Instance count must be greater than zero. Got: ${output.count}."
}
```

## Why It Matters
Tests without meaningful error messages slow down debugging. When a CI pipeline reports a test
failure, the `error_message` is the first (and sometimes only) information available.