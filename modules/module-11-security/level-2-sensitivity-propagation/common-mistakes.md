# Common mistakes

- **Wrapping the map in `nonsensitive()`.** The error disappears, but every token is now printed in plans and stored
  unmasked in plan files. The mission forbids it for good reason.
- **Removing `sensitive = true` from the variable.** It silences both errors and leaks all seal tokens into the CLI output.
- **Using `toset(keys(var.seal_tokens))`.** `keys()` of a sensitive map is itself sensitive, so the for_each error remains.
- **Marking only the output sensitive.** That fixes one error; the for_each error comes from the variable.
- **Hard-coding the tokens into `default`.** Secrets in source control — see the tfvars levels in this module.
