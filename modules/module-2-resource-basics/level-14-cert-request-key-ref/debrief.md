# Debrief: a CSR proves you hold the key

A certificate signing request contains three things: a subject (who you claim to be), your **public**
key, and a signature over both made with your **private** key. The CA verifies that signature,
which proves the requester holds the private key, before signing a certificate for the public one.

That is why `tls_cert_request` takes `private_key_pem` as input: it needs to sign. Passing
`public_key_pem` looks plausible because both attributes live on the same resource and are named
alike, but the provider cannot sign with a public key, so it fails while decoding the PEM. The
type system of Terraform does not help here; both attributes are plain strings, so your only
safety net is the provider's error message and a quick `openssl req -verify`.

Notice how this config keeps the key and CSR in one state: the key is regenerated only when you
replace it, so the CSR stays stable between plans. If you ever re-create the key, you must request
a new certificate as well, because the old one no longer matches. Also, treat `humidity-07.key` as
a secret: the mode `0600` is set by `local_sensitive_file`, but the same key sits in plaintext in the
Terraform state file.
