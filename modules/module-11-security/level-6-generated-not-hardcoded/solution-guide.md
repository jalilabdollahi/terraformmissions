# Walkthrough — Pine Ridge Passphrase

1. `grep -n passphrase main.tf` shows `radio_admin_password = "demo-not-a-real-secret-lookout-1"` in `locals`.
   Anyone with repository access has the radio's admin passphrase.
2. Replace it with a generated value:
   ```hcl
   resource "random_password" "radio_admin" {
     length      = 24
     special     = false
     min_lower   = 2
     min_upper   = 2
     min_numeric = 2
   }
   ```
3. Reference `random_password.radio_admin.result` in the `local_sensitive_file` content and delete the `locals` block.
4. `terraform apply`, then run `terraform apply` again: no changes — the password is generated once and kept in state.
   Type `check`.
