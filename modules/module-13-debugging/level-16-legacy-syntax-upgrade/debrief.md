# Debrief - old code keeps working until it does not

Terraform 0.12 rewrote the language (first-class expressions, real types) and 0.13-0.15 removed the compatibility shims one by one.
Code written for 0.11 usually shows the same handful of symptoms in a modern version:

- **Quoted types**: `type = "list"` became `type = list(string)`. The quoted form is an error now.
- **`list()` and `map()` functions**: removed in 0.15, replaced by the literals `[...]` and `{...}` (or `tolist()`, `tomap()` for conversions).
- **Interpolation-only strings**: `"${var.x}"` still works but warns. In 0.11 it was necessary; today it can change types (a
  `"${var.list}"` used to be a string trick), so it is better to write the expression itself.
- **`depends_on` strings**: references, not names in quotes.
- Related leftovers: `lookup(map, key)` without a default, `${}` inside `count`, `terraform.env`, and `lifecycle.ignore_changes = ["*"]`.

Treat warnings as a to-do list. They are the only advance notice you get before a later release turns the deprecation into an error,
and a repo with 200 warnings hides the new one that matters. Many teams run `terraform validate -json | jq '.warning_count'` in CI and fail on
non-zero. Do the migration in a branch where *nothing else* changes: the outputs and files you diff before and after should be identical, which is
exactly what this level's validator compares.
