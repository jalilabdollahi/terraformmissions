# Common mistakes

- **Deleting the placeholders from the template and typing the values.** The telegram prints, but
  nothing is driven by the variables any more; the check renders a second telegram.
- **Renaming only some keys.** `recipient` fixed but `body` still missing means plan fails on the
  next placeholder.
- **Passing the whole `var` object.** `templatefile(..., var)` is not a map of these names; you get
  the same missing-key errors.
- **Using `file()` instead of `templatefile()`.** The placeholders are printed as literal text.
- **Referencing `var.body` inside the template.** Templates cannot see variables; use the vars map.
