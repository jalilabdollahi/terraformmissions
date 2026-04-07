# Always Failing Assertion

## What Was Broken
`local_file.config.id` may not be the right attribute to assert on. The `filename` attribute
is the canonical identifier for a `local_file` resource and will always be non-empty after creation.

## The Fix
```hcl
check "file_exists" {
  assert {
    condition     = local_file.config.filename != ""
    error_message = "Config file was not created properly."
  }
}
```

## check Block (Terraform 1.5+)
- `check` blocks run assertions after apply (non-blocking by default).
- They are ideal for post-deployment health checks.
- Unlike preconditions/postconditions, failed checks produce warnings, not errors.

## Why It Matters
Choosing the right attribute for assertions is critical. Asserting on a wrong attribute
either always passes (never catches real failures) or always fails (creates noise).