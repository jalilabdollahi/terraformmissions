# Walkthrough — Kallavik Core Depths

1. `terraform plan` prints: `Invalid value for "numbers" parameter: number required, but have tuple.`
   The listed line is a `max(...)` or `min(...)` call.
2. In `terraform console`:
   ```
   > max(12.5, 48, 7)          # 48
   > max([12.5, 48, 7])        # error
   > max([12.5, 48, 7]...)     # 48  (expansion)
   ```
   `...` unpacks a list into separate arguments, but only inside a function call.
3. Add `...` to all three offenders: `max(local.all_depths...)`, `min(local.all_depths...)` and
   `max(depths...)` inside the `for` expression. Plan lists each error in turn, so you may need to fix
   them one at a time.
4. Apply and run `check`.
