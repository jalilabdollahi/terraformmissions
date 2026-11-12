# Runbook — Harrow Ironworks Drift

## 1. Triage
```bash
terraform plan
terraform state show random_id.heat_lot     # the header says: tainted
```
The plan shows `random_id.heat_lot is tainted, so must be replaced` and four `local_file` creates. For
`local_file`, an edited file and a deleted file both read as "will be created" - the provider notices the
content no longer matches. So you cannot tell intent from the plan alone; you must open the files.

## 2. Back up
```bash
terraform state pull > before-incident.tfstate
```

## 3. Decide each object
| Object | What happened | Right move |
|---|---|---|
| `random_id.heat_lot` | tainted "to be safe", stamps shipped | `terraform untaint random_id.heat_lot` |
| `local_file.furnace_a` | typo 40 -> 4 | do nothing, apply restores code |
| `local_file.furnace_b` | file deleted | do nothing, apply recreates it |
| `local_file.bronze_pour` | approved hot-fix (INC-4471) | change `pour_temp_c` to 1450 in code |
| `local_file.mold_c` | tooling scrapped | delete the block from `main.tf` |

Untaint FIRST. If you apply before untainting, the heat lot is replaced and every file is rewritten with
a new lot number.

## 4. Apply and verify
```bash
terraform apply
terraform plan   # No changes
terraform output heat_lot
```
The mold C state entry is destroyed (the file is already gone, so nothing is lost); the recipe file is
rewritten from code but its content is now identical to the approved value.
