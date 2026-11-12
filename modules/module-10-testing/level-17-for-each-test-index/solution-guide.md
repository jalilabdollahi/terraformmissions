# Walkthrough - Food Truck Rally Cards

1. `terraform test` reports for `tacotl_card`:
   ```
   Error: Invalid index
   An object only supports looking up attributes by name, not by numeric index.
   ```
   `local_file.board_card[0]` is how you address a `count` instance. A `for_each` resource is keyed by strings.
2. The failure also marks the later runs as skipped. After fixing the first, `pierogi_card` reports an invalid
   index too: `board_card["Pierogi"]` does not exist because the key in `var.trucks` is lower case `pierogi`.
3. The instance address is the same as in `terraform state list`: `local_file.board_card["tacotl"]`.
   Fix both asserts.
4. `all_cards_issued` already uses `length(...)` and a `for` expression over the whole map - that style needs no
   keys.
5. `Success! 3 passed, 0 failed.`
