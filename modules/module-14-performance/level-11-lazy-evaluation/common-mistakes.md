# Common Mistakes

- **Wrong templatefile() path** — causes plan failure for ALL for_each iterations at once.
- **Using relative paths without ${path.module}** — breaks when Terraform is run from different directories.
- **Template variable name mismatches** — the vars map keys must match ${variable} names in the template exactly.
- **Not creating the output directory** — if the output directory doesn't exist, local_file will fail.