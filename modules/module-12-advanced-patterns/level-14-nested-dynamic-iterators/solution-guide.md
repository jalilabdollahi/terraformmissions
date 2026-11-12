# Walkthrough: Two Loops One Tooling Kit

1. **Plan.** (`terraform validate` passes; the problem only shows when Terraform expands the block.)
   ```
   Error: Reference to undeclared resource
     on main.tf line 38, in data "archive_file" "kit":
     A managed resource "source" "value" has not been declared in the root module.
   ```
   Terraform read `source.value` as a resource address, because no iterator is called `source` any more.
   A `dynamic "source"` block normally names its iterator `source`. This one declares `iterator = sheet`,
   which *replaces* that name.
2. **First fix.** Use `sheet.value.path` and `sheet.value.content`.
3. **Apply and unzip** (`unzip -l kits/tooling-kit.zip`). The entries are `0/belt.txt`,
   `1/wallet.txt`, `0/satchel.txt`... The inner `for shop, piece in spec.pieces` introduced a new `shop`
   that shadows the outer one. For a list, the first symbol is the index.
4. **Second fix.** Give the inner loop its own names: `for _, piece in spec.pieces` (or `idx, piece`).
5. Apply again; the zip lists `north/...` and `east/...`. Type `check`.
