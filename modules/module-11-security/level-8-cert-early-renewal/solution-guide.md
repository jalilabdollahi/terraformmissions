# Walkthrough — Kestrel Junction Charger Certificate

1. `openssl x509 -in pki/charger.pem -noout -dates` shows a certificate that is only 6 hours long.
2. In `tls_self_signed_cert.charger`, `validity_period_hours = 6` and `early_renewal_hours = 0`. Two arguments control rotation:
   - `validity_period_hours` is the lifetime of the next certificate. Changing it forces a replacement, i.e. immediate rotation.
   - `early_renewal_hours` makes the resource report *ready for renewal* during the last N hours of validity, so the next plan replaces it.
3. Set for example:
   ```hcl
   validity_period_hours = 2160   # 90 days
   early_renewal_hours   = 336    # start renewing 14 days before expiry
   ```
4. `terraform apply`, check the new `serial`/`notAfter` with `openssl x509`, run `terraform plan` (clean), then type `check`.
   If you set `early_renewal_hours` larger than the validity the cert counts as "ready for renewal" immediately and every plan wants a replacement.
