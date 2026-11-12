# Runbook — Calder Reach Annex Teardown

## 1. Triage
```bash
terraform plan
# Error: Instance cannot be destroyed ... module.annex[0].random_pet.berth_tag ... lifecycle.prevent_destroy
```
The retirement is correct; the guard is on the thing we are removing. Note the module is toggled with
`count`, so the block is still in the config and `prevent_destroy` is evaluated.

## 2. Back up
`terraform state pull > before-annex.tfstate` and write down `terraform output charter_serial`.

## 3. Put the guard on the right object
Delete the `lifecycle { prevent_destroy = true }` block from `modules/annex/main.tf`. Add the same block to
`random_id.yard_charter` in the root. Do this BEFORE the first apply: with protection on the charter, any
accidental replacement now fails loudly.

## 4. Read the next plan
The charter now fails: `keepers.annex` is `tostring(var.annex_enabled)`, which changes from "true" to "false", and
any keepers change forces a new random_id. Keepers are stored in state as `annex = "true"`; make the
configuration keep that literal (or drop the dependency with `ignore_changes = [keepers]` on this one attribute).
The charter must keep its ID.

## 5. Fix the manifest
`module.annex[0].berth_tag` does not exist when `count = 0`. Remove the annex line from `yard_manifest`
(or use `one(module.annex[*].berth_tag)` if the line should survive).

## 6. Apply and verify
Plan shows 3 destroys inside `module.annex[0]` and one in-place manifest update. Apply, then
`terraform plan` -> clean and `terraform output charter_serial` unchanged.
