# Solution guide

**Diagnose.** `terraform apply` creates `out/terraform.workspace-crates.txt`. The first line inside is
`Harvest: {terraform.workspace}` and `terraform output crate_label` prints `terraform.workspace-3`.

Three spots:

1. `harvest = "terraform.workspace"` is a string literal. Change it to `harvest = terraform.workspace`.
2. `"Harvest: {terraform.workspace}"` lacks the `$`. Write `"Harvest: ${terraform.workspace}"`.
3. `format("%s-%d", "terraform.workspace", ...)` passes a string. Pass `terraform.workspace` unquoted.

After the fix, a workspace called `midsummer` yields `out/midsummer-crates.txt` and the label `midsummer-3`.
