# Common mistakes

- **Only renaming `triggers` and applying.** Terraform destroys the null_resource and creates a new
  terraform_data resource with a different ID.
- **Leaving the `null_resource` block in the code.** The moved block's source would then still be declared
  and Terraform reports that the moved object still exists.
- **Using `terraform state rm` followed by import.** `terraform_data` supports import, but the ID is
  generated; a moved block is the supported, reviewable way.
- **Switching `triggers` to `input`.** `input` does not force replacement and changes the stored
  attributes; the validator looks for `triggers_replace`.
