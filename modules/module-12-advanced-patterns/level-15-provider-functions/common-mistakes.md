# Common mistakes

- **Dropping the `provider::terraform::` prefix.** `encode_tfvars(...)` is not a core function; the prefix
  tells Terraform which provider to ask.
- **Declaring `hashicorp/terraform` as the source.** The built-in provider's address is
  `terraform.io/builtin/terraform`; the registry one does not exist and init fails.
- **Replacing the calls with `join()`/`format()`.** The file may look similar, but ordering, quoting and
  nested objects would be your problem; the validator also looks for the function calls.
- **Using a version constraint on it.** The built-in provider has no versions and the constraint breaks init.
