# Solution guide

1. `terraform apply`, then `terraform output`: the jack is something like `donkey-calm-otter`, the
   jenny is something like `Donkey _quiet_lark_mole` (capital D, a space, underscores, three words).
2. Compare the two resource blocks. The working one has `prefix = "donkey"`, `length = 2`,
   `separator = "-"`. The jenny differs in all three.
3. Give the jenny block the same settings. Remember that `length` counts the random words only; the
   prefix is added in front of them.
4. `terraform apply` replaces the jenny's pet and rewrites calendar/donkeys.txt.
