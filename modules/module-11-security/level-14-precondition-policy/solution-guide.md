# Walkthrough — Halloway Shelf Policy

1. Probe: `terraform plan -var 'shelves={vault={retention_days=7,public=false}}'` succeeds, and so does a public shelf.
2. In `lifecycle { precondition { ... } }` the condition is `each.value.retention_days > 0`. It never mentions `public`, and 1 day counts as
   "valid". The error message describes a policy the condition does not implement.
3. Make the condition match the message: `each.value.retention_days >= 30 && !each.value.public`.
4. Run `terraform plan`: now the archive's own `ledger` (7 days) and `lobby` (public) shelves are refused with *Resource precondition failed*. That is the
   policy working: fix the data — set `ledger` to at least 30 days and `lobby` to `public = false`.
5. Apply and type `check`.
