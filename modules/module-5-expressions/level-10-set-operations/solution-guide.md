# Walkthrough — Caerwen Robe Roll

1. `terraform apply` succeeds. Run `terraform output` and compare with the sheets: `everyone` has
   repeats, `regulars` includes people who skipped rehearsal, `need_a_robe` names Elin, who is not
   even singing.
2. In `terraform console`:
   ```
   > setunion(["b","a","a"], ["c"])           # toset(["a","b","c"])
   > setintersection(["a","b"], ["b","c"])    # ["b"]
   > setsubtract(["a","b"], ["b"])            # ["a"]
   > setsubtract(["b"], ["a","b"])            # []   (reversed: nothing left)
   ```
   Results are sets: sorted, no duplicates.
3. Replace `concat()` with `setunion()`, `setunion()` (regulars) with `setintersection()`, and put
   `concert_singers` first in `setsubtract()`.
4. Apply and run `check`.
