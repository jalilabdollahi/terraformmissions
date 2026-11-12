# Walkthrough — Waymark Pilgrim Trails

1. `terraform apply` succeeds, so look at the outputs: `Quiet Loop` shows count 1 and `Heron Way`
   shows a count of 6.
2. Experiment in `terraform console`:
   ```
   > split(",", "")                        # [""]  one empty element, not an empty list
   > split(",", "Oak Gate, Mill Ford,,")   # ["Oak Gate"," Mill Ford","",""]
   > compact(split(",", "a, ,b"))          # ["a"," ","b"]  compact only drops exact empty strings
   ```
   Pieces keep their spaces, and `compact()` does not remove a piece that is just a space.
3. Replace `split(",", csv)` in `locals.stops` with a `for` expression that trims and filters:
   `[for s in split(",", csv) : trimspace(s) if trimspace(s) != ""]`.
4. Apply, check `signs/heron-way.txt` and `signs/quiet-loop.txt`, then run `check`.
