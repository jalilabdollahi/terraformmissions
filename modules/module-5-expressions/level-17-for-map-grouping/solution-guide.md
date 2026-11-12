# Walkthrough — Port Selby Carousels

1. `terraform plan`: `Duplicate object key ... Two different items produced the key "C1" in this 'for'
   expression. If duplicates are expected, use the ellipsis (...) after the value expression to
   enable grouping by key.`
2. Try both forms in `terraform console`:
   ```
   > {for x in ["a1","b1","a2"] : substr(x,0,1) => x}       # error
   > {for x in ["a1","b1","a2"] : substr(x,0,1) => x...}    # {a=["a1","a2"], b=["b1"]}
   ```
3. Put `...` right after the value (`a.flight...`). Every value is now a list, which the downstream
   `join()` and `length()` already expect.
4. Apply: three files under `boards/`. Run `check`.
