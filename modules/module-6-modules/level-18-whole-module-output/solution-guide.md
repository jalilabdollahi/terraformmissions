# Walkthrough — Fish Market Stall Board

1. **Plan.**
   ```
   Error: Incorrect attribute value type
     on main.tf, in resource "local_file" "board": content = module.stall
     Inappropriate value for attribute "content": string required.

   Error: Invalid function argument ... Invalid value for "list" parameter: list of dynamic required.
   ```
2. **Understand the value.** `module.stall` is an object `{ catch = [...], owner = "...", pitch = 43 }`.
3. **Fix `content`:** `jsonencode(module.stall)`.
4. **Fix `fields`:** `sort(keys(module.stall))`. `keys()` works on objects and maps, and `sort()` makes the order stable.
5. Apply; change `-var owner=...` to see the JSON follow the module. Then `check`.
