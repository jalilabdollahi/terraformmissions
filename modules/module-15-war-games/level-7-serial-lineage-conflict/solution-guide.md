# Runbook — Pellham Docket Lineage Clash

## 1. Triage
```bash
terraform state list     # seal and courtroom c2 missing
terraform plan           # wants to create both with new random values
jq '{lineage, serial}' terraform.tfstate recovery/docket-snapshot.tfstate
terraform state push recovery/docket-snapshot.tfstate
# Failed to write state: cannot import state with lineage ... over unrelated state
```
The two files have different lineages, and the snapshot's serial is older.

## 2. Resist the force push
`terraform state push -force` would "work": it overwrites the live state with the snapshot. Compare the snapshot with
`docket/c3.txt` (written by the last real apply): c3's call-sign differs, and the snapshot still contains
`local_file.archive_index`, retired since. Forcing it turns the incident into a regression.

## 3. Back up
`cp terraform.tfstate live-before.tfstate`.

## 4. Merge only what is lost
Start from the live JSON. Append the snapshot's `random_id.docket_seal` resource and the `c2` instance of
`random_pet.courtroom`. Set `serial` to live serial + 1. Keep `lineage` untouched. Save as `merged.tfstate`.

## 5. Push and verify
```bash
terraform state push merged.tfstate     # accepted: same lineage, higher serial
terraform plan                          # No changes (or a pure no-op)
terraform apply
```
Check that `terraform output call_signs` matches the binders and `docket/*.txt`.

An alternative that also works: `terraform import` the two objects using the values printed in `docket/`. The merge
route keeps their exact attributes and is faster for many objects.
