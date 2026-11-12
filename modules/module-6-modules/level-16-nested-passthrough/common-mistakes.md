# Common mistakes

- **Editing the bottler's default to "2023".** The default plan prints the right year, but `-var vintage=2019` is
  ignored.
- **Removing the default from the bottler.** Then Terraform reports a missing argument, which is helpful, but the
  fallback is the module's own business; the mission is to supply the value.
- **Passing `var.vintage` from the root directly to the bottler.** Modules can only be called from their parent; the
  press would have to be bypassed.
- **Declaring the variable twice in the press.** Terraform rejects duplicate variable names.
