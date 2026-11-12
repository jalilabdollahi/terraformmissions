# Walkthrough — Brightwell Filament Shelf

1. **Run `terraform validate`.** Errors include:
   ```
   Error: Extraneous label for variable
   Error: Invalid resource name
     A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.
   ```
2. **List the bad names.** `"spool colour"` (space), `"3d_label"` (starts with a digit), `"spool.tag"` (a dot would look
   like an attribute access).
3. **Rename each one** to something valid, e.g. `spool_colour`, `label_3d`, `spool_tag`.
4. **Update every reference.** `var.spool colour` becomes `var.spool_colour` (twice), `local_file.3d_label.filename`
   becomes `local_file.label_3d.filename`, and so on. A rename that misses one reference gives "undeclared" errors.
5. **Apply.**
