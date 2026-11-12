# Solution guide

1. `terraform plan` fails on `tls_private_key.telemetry`: `expected ecdsa_curve to be one of
   ["P224" "P256" "P384" "P521"], got P-256`.
2. The curve is the standard NIST P-256, but the provider spells it `P256`. (openssl calls it
   `prime256v1` and many docs call it `P-256`, so this is a real source of confusion.)
3. Change `ecdsa_curve = "P256"`.
4. `terraform apply`. Check `cat fleet-keys/telemetry.pub`: it begins with `ecdsa-sha2-nistp256`.
5. Remember the pairing rule: `ecdsa_curve` only applies with `algorithm = "ECDSA"`, and `rsa_bits`
   only with `"RSA"`.
