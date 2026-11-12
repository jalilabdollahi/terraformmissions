# Debrief: algorithm settings come as pairs

`tls_private_key` has one required argument, `algorithm` (`RSA`, `ECDSA` or `ED25519`), and then
settings that only make sense for a particular algorithm: `rsa_bits` for RSA (default 2048) and
`ecdsa_curve` for ECDSA (default `P224`; accepted `P224`, `P256`, `P384`, `P521`). Using a curve name
the provider does not know, such as the hyphenated form from documentation or openssl's
`prime256v1`, fails at plan time with the list of valid values, which is the first place to look.

The default curve is a trap of its own: if you leave `ecdsa_curve` out you silently get P224, a curve
many verifiers reject. If a consumer needs a specific curve, always state it.

Remember what you are creating, too. The private key is stored in **plaintext in the state file**,
even though the resource marks it sensitive in plan output. That is fine for lab work and for keys
you can rotate cheaply, not for long-lived production signing keys; those belong in a KMS or HSM and
are referenced, not generated, by Terraform.

Finally, only the public key is written to disk here. Publishing `public_key_openssh` is safe; the
`private_key_pem` should only ever flow into other resources that need it.
