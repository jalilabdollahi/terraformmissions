# Walkthrough - Lost Property Tags

1. `terraform plan` fails with `Attempt to get attribute from null value` on the `item.claim.holder` line.
2. Inspect the data in `terraform console`:
   ```
   > var.items["scarf"].claim
   null
   > var.items["keys"].claim.phone
   null
   ```
   `optional()` attributes that are not set become `null`, not "missing".
3. You can only read an attribute of a non-null object, and you cannot interpolate `null` into a string.
4. Guard each access with a fallback:
   - holder: `try(upper(item.claim.holder), "UNCLAIMED")`
   - phone: `try(coalesce(item.claim.phone), "n/a")`
5. `terraform apply`. The sheet has four lines. `check` (the validator also tries other items).
