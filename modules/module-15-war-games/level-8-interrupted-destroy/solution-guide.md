# Runbook — Halden Field B Teardown

## 1. Triage
```bash
terraform plan                 # Error: Invalid index - module.field_b[0] is empty tuple
terraform state list           # m2, m3 rigging remain; m3 pet and tags are missing
ls tags crates
cat crates/manifest.lock       # pid=4242 marquee=m2 ...
```

## 2. Back up
`terraform state pull > before-teardown.tfstate`.

## 3. Fix the reference
The site plan reads `module.field_b[0]`, which cannot exist with `count = 0`. Use
`try(values(module.field_b[0].marquee_names), [])` (or `one(module.field_b[*].marquee_names)`).

## 4. Clear the stale lock - after proving it is stale
```bash
ps -p 4242 || echo "no such process"
```
The runner was killed, so the lock is orphaned. Remove `crates/manifest.lock`. Do NOT add
`on_failure = continue` to the provisioner: the site desk would never get its rigs back.

## 5. Let Terraform finish the destroy
`terraform apply` plans the removal of the m2 and m3 rigging and their dependents; the destroy-time provisioner
runs `unrig.sh` for each. Check `crates/unrig.log`: m1 (from last night), m2 and m3.

## 6. Clean the orphan
`tags/m3.txt` was left behind because its state entry was lost; Terraform will never delete it. Remove it
manually. Finally `terraform plan` -> No changes and `terraform output register` unchanged.
