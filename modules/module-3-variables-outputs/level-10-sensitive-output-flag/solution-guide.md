# Walkthrough — Harbor Inn

1. **Diagnose.** `terraform plan` fails with
   `Error: Output refers to sensitive values ... To reduce the risk of accidentally exporting sensitive data that was intended to be only internal, Terraform requires that any root module output containing sensitive data be explicitly marked as sensitive`.
2. **Find the cause.** `portal_login_url` interpolates `var.portal_admin_password`, which is `sensitive = true`.
   Sensitivity is contagious: anything derived from a sensitive value is sensitive.
3. **Fix.** Add `sensitive = true` to the output. Keep the variable sensitive.
4. **Verify.** `terraform output` lists `portal_login_url = <sensitive>`; `terraform output -json portal_login_url`
   still gives the value to automation.
