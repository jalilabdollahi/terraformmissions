# Common Mistakes

- **Marking only the output, not the variable** — plan output can still show sensitive variable
  values in diffs if the variable itself is not marked sensitive.
- **Committing `terraform.tfvars` with real passwords** — use `.gitignore`.
- **Thinking `sensitive = true` on a variable removes the value from state** — it does not;
  state always contains the raw value.