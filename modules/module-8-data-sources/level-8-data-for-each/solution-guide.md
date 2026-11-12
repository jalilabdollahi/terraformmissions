# Walkthrough — Barrel Sample Sheets

1. **First error.** `no such file or directory: b07-oak.txt`. `fileset("samples", "*.txt")` yields
   names relative to `samples/`; prepend the folder:
   `filename = "${path.module}/samples/${each.value}"`.
2. **Second error.** `Invalid splat expression` / unsupported attribute: with `for_each`, the data
   source is a map of instances, not a list. Use a `for` expression:
   `all_sheets = [for sheet in data.local_file.sample : sheet.content]`.
3. **Check the keys.** The `brix` output is keyed `b07-oak.txt`, but the board should say `b07-oak`.
   Use `trimsuffix(key, ".txt") => tonumber(...)` in the comprehension.
4. `terraform apply`; `terraform output brix`. Type `check`.
