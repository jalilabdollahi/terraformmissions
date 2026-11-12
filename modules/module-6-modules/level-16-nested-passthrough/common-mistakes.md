# Common mistakes

- **Editing the canner's default to "2023".** The default plan prints the right year, but `-var season=2019` is
  ignored.
- **Removing the default from the canner.** Then Terraform reports a missing argument, which is helpful, but the
  fallback is the module's own business; the mission is to supply the value.
- **Passing `var.season` from the root directly to the canner.** Modules can only be called from their parent; the
  evaporator would have to be bypassed.
- **Declaring the variable twice in the evaporator.** Terraform rejects duplicate variable names.
