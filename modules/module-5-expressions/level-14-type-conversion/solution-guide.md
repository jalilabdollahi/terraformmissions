# Walkthrough — Brightside Cubing Results

1. `terraform plan`: `cannot convert "13,1" to number; given string must be a decimal representation
   of a number.` (After fixing that one, the next ones are `" 11.9"` and `"DNF"`.)
2. Probe in `terraform console`:
   ```
   > tonumber("13,1")                                   # error
   > tonumber(replace("13,1", ",", "."))                # 13.1
   > tonumber(" 11.9")                                  # error (whitespace)
   > tonumber(trimspace(" 11.9"))                       # 11.9
   > can(tonumber("DNF"))                               # false
   ```
3. Clean first (`replace(trimspace(t), ",", ".")`) and only convert strings that pass
   `can(tonumber(t))`. `try()` also works, but `can()` keeps the filter readable.
4. Apply, read `board/results.txt`, run `check`.
