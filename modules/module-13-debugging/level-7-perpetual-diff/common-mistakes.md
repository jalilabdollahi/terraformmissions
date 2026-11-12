# Common mistakes

- **`lifecycle { ignore_changes = [content] }`.** The plan goes clean, but later card changes would never be written.
- **Fixing only the timestamp.** The card order still changes on some runs, so the plan is clean only part of the time.
  The validator plans four times.
- **Replacing `timestamp()` with a typed date.** The Generated line should be stamped by Terraform when the index is created.
- **Using `formatdate("...", timestamp())`.** It still calls `timestamp()` and changes every plan.
- **Sorting with `reverse()` or `distinct()` only.** Neither produces an alphabetical, repeatable order.
