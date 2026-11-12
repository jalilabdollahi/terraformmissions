# Walkthrough: Key That Never Lands

1. **Validate.**
   ```
   Error: Invalid use of ephemeral value
   Ephemeral values are not valid for "private_key_pem", because it is not a write-only attribute and must be persisted to state.
   ```
2. **Find the write-only twin.** `terraform providers schema -json` (or the provider docs) shows
   `private_key_pem_wo` and `private_key_pem_wo_version` on `tls_cert_request`.
3. **Swap the argument.**
   ```hcl
   private_key_pem_wo         = ephemeral.tls_private_key.scooter.private_key_pem
   private_key_pem_wo_version = 1
   ```
4. **Apply.** The log shows `ephemeral.tls_private_key.scooter: Opening...` and `Closing...`.
   Check `terraform state pull | grep -c "PRIVATE KEY"`: it prints 0. Type `check`.
