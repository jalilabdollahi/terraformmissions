# Walkthrough — Pinewood Bib Cards

1. Run `terraform plan`. The error is:
   `unsupported value for "%d" at 2: an integer is required.` Argument 2 of the `format()` call is the
   distance, 21.1 km.
2. Experiment in `terraform console`:
   ```
   > format("%d", 21.1)        # error
   > format("%.1f", 21.1)      # "21.1"
   > format("%05.1f", 21.1)    # "021.1"
   > format("%5d", 7)          # "    7"  (spaces!)
   > format("%05d", 7)         # "00007"
   > format("%q", "Ines \"Flash\"")   # "\"Ines \\\"Flash\\\"\""
   ```
3. Fix the three verbs: `%05d` for the bib, `%q` for the name, `%05.1f` for the distance.
4. `terraform apply`, read `cards/bib-card.txt`, then run `check`.
