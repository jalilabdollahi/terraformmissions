# Common mistakes

- **Changing the variable type from a map to a list.** The cast is keyed by role on purpose and the
  second dataset in the check passes a map.
- **Using `var.cast.*.puppeteer`.** The legacy splat has the same limitation and gives the same error.
- **Fixing the puppeteer list and forgetting `total_strings`.** It is a second map splat further down.
- **Replacing the understudy splat with an `if`/`null` conditional that returns a string.** The output
  must be a list: empty without an understudy, one name with one.
- **Dropping `distinct()`.** Odile is credited twice.
