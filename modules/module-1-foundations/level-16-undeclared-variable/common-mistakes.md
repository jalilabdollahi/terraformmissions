# Common mistakes

- **Replacing `var.x` with literals.** The files apply, but the validator re-applies with `-var` overrides
  and the sheet no longer follows them.
- **Declaring the variables without a `type = number` for the counts.** It may still apply, but the mission
  expects `runner_count` and `first_bib` to be numbers.
- **Putting `variables.tf` in a subfolder.** Terraform only reads `.tf` files in the module directory itself,
  not in subdirectories.
- **Declaring a variable twice** (once in `main.tf` too). Terraform reports a duplicate variable declaration.
