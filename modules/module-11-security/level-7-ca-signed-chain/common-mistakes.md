# Common mistakes

- **Making the leaf `is_ca_certificate = true` as well.** Verification may pass, but the controller could now sign certificates for anything; the validator rejects it.
- **Copying the leaf certificate into `root-ca.pem`.** A leaf trusted as its own anchor verifies, but that is not a chain to the depot root.
- **Only fixing `is_ca_certificate`.** Without `cert_signing` in `allowed_uses` openssl still rejects the CA for certificate signing, and the wrong signing key remains.
- **Switching the root to a different algorithm.** Algorithms are not the problem here; the leaf and root already agree on ECDSA P-256.
