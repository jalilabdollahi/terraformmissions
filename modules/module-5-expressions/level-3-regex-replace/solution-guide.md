# Walkthrough — Fenner Street Radio Tags

1. `terraform apply` works, which is the trap. Open `tags/bench-tag.txt`: nothing was cleaned.
2. Try the calls in `terraform console`:
   ```
   > replace("a-b", "[^a-z]", "")         # "a-b"   (literal text search, no match)
   > replace("a-b", "/[^a-z]/", "")       # "ab"
   > replace(" ", "/\\s+/", "x  y")       # " "    (arguments in the wrong order: the string is the 1st one)
   ```
   Only the slash-wrapped pattern is a regex. The inside of a HCL string needs `\\s` to produce `\s`.
3. Fix the three calls:
   - `replace(trimspace(var.serial_raw), "/[^A-Za-z0-9]/", "")`, then `upper()`
   - `replace(var.fault_note_raw, "/\\s+/", " ")`
   - `replace(var.intake_date, "/^(\\d{4})-(\\d{2})-(\\d{2})$/", "$3/$2/$1")`
4. Apply again and run `check`.
