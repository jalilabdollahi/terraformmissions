# Walkthrough — Longline Sample Sheets

1. **First error.** `no such file or directory: l07-kelp.txt`. `fileset("samples", "*.txt")` yields
   names relative to `samples/`; prepend the folder:
   `filename = "${path.module}/samples/${each.value}"`.
2. **Second error.** `Invalid splat expression` / unsupported attribute: with `for_each`, the data
   source is a map of instances, not a list. Use a `for` expression:
   `all_sheets = [for sheet in data.local_file.sample : sheet.content]`.
3. **Check the keys.** The `growth` output is keyed `l07-kelp.txt`, but the board should say `l07-kelp`.
   Use `trimsuffix(key, ".txt") => tonumber(...)` in the comprehension.
4. `terraform apply`; `terraform output growth`. Type `check`.
