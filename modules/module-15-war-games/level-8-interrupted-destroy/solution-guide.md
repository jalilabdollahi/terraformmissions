# Runbook — Halden Hall B Teardown

## 1. Triage
```bash
terraform plan                 # Error: Invalid index - module.hall_b[0] is empty tuple
terraform state list           # s2, s3 rigging remain; s3 pet and signage are missing
ls signage crates
cat crates/manifest.lock       # pid=4242 stand=s2 ...
```

## 2. Back up
`terraform state pull > before-teardown.tfstate`.

## 3. Fix the reference
The floor plan reads `module.hall_b[0]`, which cannot exist with `count = 0`. Use
`try(values(module.hall_b[0].stand_names), [])` (or `one(module.hall_b[*].stand_names)`).

## 4. Clear the stale lock - after proving it is stale
```bash
ps -p 4242 || echo "no such process"
```
The runner was killed, so the lock is orphaned. Remove `crates/manifest.lock`. Do NOT add
`on_failure = continue` to the provisioner: the venue desk would never get its bays back.

## 5. Let Terraform finish the destroy
`terraform apply` plans the removal of the s2 and s3 rigging and their dependents; the destroy-time provisioner
runs `unrig.sh` for each. Check `crates/unrig.log`: s1 (from last night), s2 and s3.

## 6. Clean the orphan
`signage/s3.txt` was left behind because its state entry was lost; Terraform will never delete it. Remove it
manually. Finally `terraform plan` -> No changes and `terraform output register` unchanged.
