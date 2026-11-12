# Common mistakes

- **Moving the import block into `modules/hut/main.tf`.** Import blocks are only valid in the root
  module; Terraform rejects them in a child.
- **Declaring a new `random_id.key` resource at the root.** Then the import has a target, but the module's
  key is still generated and the hut file prints a different number.
- **Changing the ID to the hex form.** For random_id the import ID is the base64-url value from the tag, `Rk9mPg`.
- **Running `terraform import` from the CLI with the short address.** It fails for the same reason: the
  address must include `module.hut.`.
