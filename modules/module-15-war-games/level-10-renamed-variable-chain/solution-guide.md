# Runbook — Karst Peak Id Rename

## 1. Triage
```bash
terraform validate
# Error: Reference to undeclared input variable var.station_callsign  (root)
```
`grep -rn callsign .` and write the chain: root var -> region input -> post input.

| Layer | Old | New |
|---|---|---|
| root variable | `station_callsign` | `dispatch_id` |
| region input | `base_callsign` | `regional_id` |
| post input | `callsign` | `radio_id` |

## 2. Back up
`terraform state pull > before-rename.tfstate`.

## 3. Wire every hop
- root: `regional_id = var.dispatch_id`
- region: `radio_id = var.regional_id`
Validate after each fix; expect the next layer's error until all three match.

## 4. Do not apply yet - plan
After validate passes the plan wants to replace `random_integer.channel` and `random_id.beacon`. Reason: `terraform.tfvars`
still sets `station_callsign`, which no variable declares. Terraform only WARNS about that, so `var.dispatch_id` is
the default `UNSET`, which changes the `keepers` and the station sheet's filename.

## 5. Rename the tfvars entry
`dispatch_id = "MR-ALPINE-7"`. Plan again: no changes (the dispatch log and sheet keep their content).

## 6. Verify
`grep -rn "station_callsign\|base_callsign" .` returns nothing; `terraform apply` is a no-op; outputs unchanged.
