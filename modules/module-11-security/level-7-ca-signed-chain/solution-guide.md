# Walkthrough — Orbital Spur Track Root

1. Apply, then `openssl verify -CAfile pki/root-ca.pem pki/signals.pem`. You get an error such as
   *unable to get local issuer certificate* or *invalid CA certificate*.
2. Inspect the root: `openssl x509 -in pki/root-ca.pem -noout -text | grep -E 'CA:|Certificate Sign'`. `CA:TRUE` and
   *Certificate Sign* are missing: `is_ca_certificate` is false and `allowed_uses` only lists `digital_signature`.
3. Inspect the wiring of `tls_locally_signed_cert.signals`: `ca_private_key_pem` points at the controller's key. A certificate
   is signed with the *CA's* private key, so the signature cannot validate against the root's public key.
4. Fix: `is_ca_certificate = true`, `allowed_uses = ["cert_signing","crl_signing","digital_signature"]` on the root,
   and `ca_private_key_pem = tls_private_key.root.private_key_pem` on the signed cert. Apply and type `check`.
