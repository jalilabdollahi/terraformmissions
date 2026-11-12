# Walkthrough — Banquet Place Cards

1. **Diagnose.** `terraform plan` fails with `Unsupported attribute ... This object does not have an
   attribute named "diet"` (for Cedric, whose object has no `diet` key). Fixing that reveals the next
   one: Ambrose has no `table`.
2. **Guard against absent keys.** `try(expr, fallback)` returns the fallback when `expr` errors.
3. **Guard against explicit null.** Prudence has `"diet": null`; the key exists, so `try` alone
   returns null. Combine them: `coalesce(try(g.diet, null), "no restrictions")`, and likewise
   `coalesce(try(g.table, null), "TBA")` for the table.
4. **Count the special diets** with the same guard: `if try(g.diet, null) != null`.
5. `terraform apply` -> `special_diets = 2`. Type `check`.
