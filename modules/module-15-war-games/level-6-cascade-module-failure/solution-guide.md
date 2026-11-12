# Runbook — Tern Field Baggage Cascade

## 1. Triage
```bash
terraform validate
```
Error: `module.belts` argument `belts` has the wrong type: a list was supplied, `map(object({capacity=number}))`
is declared. Everything downstream is unevaluated, so absence of errors there means nothing yet.

## 2. Back up
`terraform state pull > before-release.tfstate`.

## 3. Walk down the chain
1. **Belts.** Build the map in the root: `{ for b, c in local.capacities : b => { capacity = c } }`. Validate again.
   Then `terraform plan` shows all four `random_id.belt` as replaced: the release bumped `byte_length` from 3 to 4.
   Restore 3. The serials are engraved on hardware.
2. **Sorters.** New errors: the output was renamed (`belt_ids` -> `belt_serials`) and the module requires a new
   `capacity` input. Wire both in the root.
3. **Dispatch.** It validates and plans, but is wrong: the total assumes equal sorters (2 x 80 = 160, should be 130)
   and `busiest` returns the first alphabetical key (`arrivals`, 50) instead of the peak (`transfer`, 80). Use
   `sum(values(...))` and select by `max`.

## 4. Verify
`terraform plan` has no replacements, apply, then `terraform output`: total 130, busiest `transfer`; check
`sortation/dispatch-board.txt`.
