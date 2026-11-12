# Runbook - Alderwater Gauge Census

1. **Triage.** `terraform plan` says 17 to add. For a network that physically exists, "add" means Terraform is about to
   invent identities, so stop and read `register/gauges.json`.
2. **Back up.** `cp terraform.tfstate terraform.tfstate.pre-census`; it only holds the network key now.
3. **Scope the adoption.** `jq -r '.stations[] | "\(.station) \(.status) \(.serial)"' register/gauges.json` shows 15 active
   and 2 retired. Filter the `local.gauges` comprehension with `if g.status == "active"`.
4. **Match the schema.** Serials of 8 characters decode to 6 bytes and serials of 11 characters to 8 bytes. A fixed
   `byte_length = 6` would force replacement for the long ones. Use `floor(length(each.value.serial) * 3 / 4)`.
5. **Write one import block** with `for_each = local.gauges`, `to = random_id.gauge[each.key]`, `id = each.value.serial`.
6. **Dry run.** `terraform plan` must list 15 "will be imported" lines and a single create (the roster file); anything
   marked "must be replaced" is a byte_length mismatch.
7. **Apply and verify.** After the apply, `terraform state show 'random_id.gauge["lock-4"]'` shows the register serial, and
   a second plan is clean. Keep the import block for one release so other environments can adopt too.
