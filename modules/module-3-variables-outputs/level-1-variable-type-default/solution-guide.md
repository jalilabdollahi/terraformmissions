# Walkthrough — Crumb & Ember

1. **Diagnose.** Run `terraform validate`. The error is:
   `Invalid default value for variable ... This default value is not compatible with the variable's type constraint: a number is required.`
   It points at `variable "oven_count"` in `main.tf`.
2. **Read the declaration.** `type = number` but `default = "three"`. A word cannot be converted to a number.
3. **Fix.** Make the default a numeric literal: `default = 3`. Do not change the type to `string` — the
   planner multiplies the value.
4. **Verify.** `terraform apply`, then `terraform output`. You should see `oven_count = 3` and `daily_loaves = 120`.
