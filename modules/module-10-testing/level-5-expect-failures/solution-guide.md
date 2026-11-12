# Walkthrough - Dispensary Label Guardrails

1. `terraform test -verbose` fails twice. Each failing run prints the real validation error (`Invalid value
   for variable`) *and* `Missing expected failure` for the object it was told to expect.
2. `dose_too_high` says `expect_failures = [variable.dose_mg]`. There is no checkable object called
   `variable.dose_mg`: variables are referenced as `var.<name>`, in tests as everywhere else. Fix:
   `[var.dose_mg]`.
3. `interval_too_short` passes `interval_hours = 1`, which breaks the `interval_hours` validation, but the
   run expects `var.dose_mg`. The failing object is not in the list, so the run fails. Fix:
   `[var.interval_hours]`.
4. Re-run: `Success! 3 passed, 0 failed.`
5. Remember that every failure that fires must be listed. If a run broke both variables you would write
   `[var.dose_mg, var.interval_hours]`.
