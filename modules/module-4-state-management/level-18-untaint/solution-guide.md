# Walkthrough — Tainted Signing Key

1. **Read the plan.**
   ```bash
   terraform plan
   # tls_private_key.firmware_signer is tainted, so must be replaced
   # -/+ resource "tls_private_key" "firmware_signer" { ... }
   ```
   The code has not changed; the state carries a "tainted" mark.
2. **Remove the mark.**
   ```bash
   terraform untaint tls_private_key.firmware_signer
   # Resource instance tls_private_key.firmware_signer has been successfully untainted.
   ```
3. **Verify.** `terraform plan` reports `No changes`, and the fingerprint is the one recorded when the key was created:
   ```bash
   terraform state show tls_private_key.firmware_signer | grep fingerprint_sha256
   ```
4. Type `check`.
