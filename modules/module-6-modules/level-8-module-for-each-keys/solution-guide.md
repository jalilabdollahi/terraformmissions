# Walkthrough — Glassblowers' Kiln Board

1. **Plan, first error.**
   ```
   Error: Invalid for_each argument ... The given "for_each" argument value is unsuitable: the "for_each"
   argument must be a map, or set of strings, and you have provided a value of type list of string.
   ```
   Fix with `for_each = toset(var.pieces)`.
2. **Plan, second error.** `module.piece["Vase"]` — `Invalid index: the given key does not identify an element in this collection`.
   Keys are the set elements verbatim, so the key is `"vase"`.
3. Apply. State addresses read `module.piece["vase"].terraform_data.anneal`.
4. Confirm the schedule is sorted (sets iterate in lexical order) and `check`.
