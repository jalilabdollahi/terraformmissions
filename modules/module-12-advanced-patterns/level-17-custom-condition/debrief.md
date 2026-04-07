# Backwards Logic

## What Was Broken
`condition = var.min_size > var.max_size` evaluates to `true` when `min_size > max_size`,
which is the *invalid* case. Terraform's `precondition` passes when `condition = true`,
so this passes on invalid input and fails on valid input.

## The Fix
```hcl
precondition {
  condition     = var.min_size < var.max_size
  error_message = "min_size must be less than max_size."
}
```

## Condition Semantics
- `condition = true` → constraint satisfied → proceed
- `condition = false` → constraint violated → fail with `error_message`

## Why It Matters
Inverted logic in preconditions blocks legitimate plans while allowing invalid configurations
through. This is especially dangerous in security or sizing constraints.