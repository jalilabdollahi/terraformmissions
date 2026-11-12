# Walkthrough - Concours Stand Cards

1. `terraform test` reports for `arrow_card`:
   ```
   Error: Invalid index
   An object only supports looking up attributes by name, not by numeric index.
   ```
   `local_file.stand_card[0]` is how you address a `count` instance. A `for_each` resource is keyed by strings.
2. The failure also marks the later runs as skipped. After fixing the first, `regent_card` reports an invalid
   index too: `stand_card["Regent"]` does not exist because the key in `var.entries` is lower case `regent`.
3. The instance address is the same as in `terraform state list`: `local_file.stand_card["arrow"]`.
   Fix both asserts.
4. `all_cards_issued` already uses `length(...)` and a `for` expression over the whole map - that style needs no
   keys.
5. `Success! 3 passed, 0 failed.`
