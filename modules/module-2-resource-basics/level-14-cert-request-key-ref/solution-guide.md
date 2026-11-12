# Solution guide

1. `terraform plan` fails on `tls_cert_request.sensor` with a message that it failed to decode the PEM
   as a private key (the value is a `PUBLIC KEY` block).
2. `tls_private_key` exports both `private_key_pem` and `public_key_pem`, and the argument is named
   `private_key_pem` for a reason: a CSR is signed with the private key and embeds the public key.
3. Change the reference to `tls_private_key.sensor.private_key_pem`.
4. `terraform apply`, then verify with `openssl req -in pki/humidity-07.csr -noout -verify -subject`.
