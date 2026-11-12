# Walkthrough — Busker Pitch Board

1. **Plan.**
   ```
   Error: Incorrect attribute value type
     on main.tf, in resource "local_file" "board": content = module.busker
     Inappropriate value for attribute "content": string required.

   Error: Invalid function argument ... Invalid value for "list" parameter: list of dynamic required.
   ```
2. **Understand the value.** `module.busker` is an object `{ setlist = [...], performer = "...", slot = 43 }`.
3. **Fix `content`:** `jsonencode(module.busker)`.
4. **Fix `fields`:** `sort(keys(module.busker))`. `keys()` works on objects and maps, and `sort()` makes the order stable.
5. Apply; change `-var performer=...` to see the JSON follow the module. Then `check`.
