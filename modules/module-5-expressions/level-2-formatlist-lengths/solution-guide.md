# Walkthrough — Ashdown Admission Board

1. `terraform plan` stops with: `argument 2 has length 2, which is inconsistent with argument 1 of
   length 3`. Argument 1 is `var.tiers`; argument 2 is the hand-typed currency list.
2. Probe the rule in `terraform console`:
   ```
   > formatlist("%s-%s", ["a","b","c"], ["x","y"])   # error
   > formatlist("%s-%s", ["a","b","c"], "x")         # ["a-x","b-x","c-x"]
   ```
   A plain value (not a list) is repeated for every row; lists must all be the same length.
3. Replace the typed list with `var.currency`. Do not repeat the code three times: the validator
   later uses five tiers and a different currency.
4. `terraform apply`, read `board/prices.txt`, run `check`.
