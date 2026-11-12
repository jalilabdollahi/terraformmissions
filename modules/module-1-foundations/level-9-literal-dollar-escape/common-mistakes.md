# Common mistakes

- **Using a backslash (`\${HOME}`).** HCL does not use backslash for this; Terraform still tries to
  evaluate the expression.
- **Escaping `${var.bay}` too.** Then the script contains the literal text `${var.bay}` instead of the bay
  name, and the bay-name check fails.
- **Dropping the braces (`$HOME`).** That one is valid, but it cannot express `${PUMP_SECONDS:-30}`, which needs
  the braces for the default; the mission wants the exact script text.
- **Moving the script into a `file()` call.** The text is then not templated at all, so the bay
  name is no longer filled in by Terraform.
