# Syntax Smash

## What Was Broken
`~3.6` is not a valid Terraform version constraint. The pessimistic operator requires both characters: `~>`.

## The Pessimistic Constraint Operator `~>`
`~> 3.6` means: allow `3.6.x` and above, but not `4.0` or higher.
It's called "pessimistic" because it assumes breaking changes happen at the next major/minor version.

```hcl
version = "~> 3.6"   # OK: 3.6.0, 3.6.5, 3.7.0 — NOT 4.0.0
version = "~> 3.0"   # OK: 3.0.0, 3.6.0 — NOT 4.0.0
```