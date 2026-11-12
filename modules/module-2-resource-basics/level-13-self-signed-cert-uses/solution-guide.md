# Solution guide

1. `terraform validate` prints two errors for `tls_self_signed_cert.scoreboard`:
   - `Missing required argument`: `"allowed_uses" is required`;
   - `Unsupported argument` / `Unsupported block type`: `subject` must be written as a block.
2. Add the list, `allowed_uses = ["digital_signature", "key_encipherment", "server_auth"]`; `server_auth`
   is what browsers check for HTTPS servers.
3. Replace `subject = { ... }` with `subject { ... }` (no equals sign).
4. `terraform apply`, then `openssl x509 -in pki/scoreboard.pem -noout -subject -dates` and
   `openssl x509 -in pki/scoreboard.pem -noout -text | grep -A1 "Extended Key"`.
