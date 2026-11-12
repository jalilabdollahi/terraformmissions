# Common mistakes

- **Protecting only the key file.** Destroying the generated passphrase would still lose the secret; both objects need the setting.
- **Using a variable (`prevent_destroy = var.protect`).** Lifecycle arguments must be literal values; Terraform reports *Variables may not be used here*.
- **Adding `ignore_changes = all` instead.** That hides drift; it does nothing to stop a destroy.
- **Deleting the resources and recreating them.** That regenerates the master passphrase, which is exactly what the notary cannot afford.
