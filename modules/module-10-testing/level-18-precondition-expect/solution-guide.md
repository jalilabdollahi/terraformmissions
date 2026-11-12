# Walkthrough - Fireworks Display Permit

1. `terraform test -verbose` fails `too_heavy` and skips `too_tall` (a failed run skips the rest); after fixing the
   first, `too_tall` fails as well.
   - `too_heavy`: `Error: Resource precondition failed ... Displays over 40 kg of explosive may not be licensed.` plus
     `Missing expected failure` for `var.shell_kg`. The run expects the variable to fail, but the
     variable has no validation. The precondition lives on `terraform_data.display_permit`.
   - `too_tall`: `Missing expected failure: The checkable object terraform_data.display_permit was expected to
     report an error but did not.` The run overrides nothing, so the default height 3.0 m passes the
     height limit.
2. Fix `too_heavy`: `expect_failures = [terraform_data.display_permit]`.
3. Fix `too_tall`: add `variables { rack_height_m = 5.2 }` (limit is 4.5 m).
4. `Success! 3 passed, 0 failed.`
5. Sanity check: a precondition error is raised at plan time, so `command = plan` is enough for these runs.
