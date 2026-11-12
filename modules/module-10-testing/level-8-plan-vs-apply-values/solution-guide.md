# Walkthrough - Unmixed Paint Batch

1. `terraform test` output:
   ```
   run "batch_code_shape"... fail
   Error: Unknown condition value
   ... executed a `run` block with `command = plan` and one of the values your condition depended on
   is not known until after the plan has been applied.
   ```
   The same error appears for `tint_in_range`; `ratio_label` passes.
2. Why: `random_id.batch.hex` and `random_integer.tint.result` are computed attributes - unknown during
   plan. Only an apply creates them.
3. Change those two runs to `command = apply`. Terraform creates the random resources, evaluates the
   asserts against real values and destroys them at the end.
4. `ratio_label` reads only variables and a constant string; it must stay `command = plan`.
5. `Success! 3 passed, 0 failed.`
