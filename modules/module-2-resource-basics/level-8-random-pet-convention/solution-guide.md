# Solution guide

1. `terraform apply`, then `terraform output`: the reflector is something like `scope-calm-otter`, the
   refractor is something like `Scope _quiet_lark_mole` (capital S, a space, underscores, three words).
2. Compare the two resource blocks. The working one has `prefix = "scope"`, `length = 2`,
   `separator = "-"`. The refractor differs in all three.
3. Give the refractor the same settings. Remember that `length` counts the random words only; the
   prefix is added in front of them.
4. `terraform apply` replaces the refractor's pet and rewrites calendar/instruments.txt.
