# Walkthrough — Tansy and Tin Pack Labels

1. `terraform plan` fails with `Invalid function argument ... arguments must be maps or objects` on
   `local.allergens`: `merge()` was given two lists.
2. Try both in `terraform console`:
   ```
   > merge({a=1,b=2}, {b=9})      # {a=1, b=9}   (last one wins)
   > merge(["x"], ["y"])          # error
   > concat(["x"], ["y"])         # ["x","y"]
   > distinct(concat(["x","y"], ["y","z"]))   # ["x","y","z"]
   ```
3. Use `concat()` (with `distinct()`) for the lists, and swap the `merge()` arguments so the blend
   comes last. This second defect is silent: `apply` would succeed and print grade OP.
4. Apply, read `labels/pack.txt`, and run `check`.
