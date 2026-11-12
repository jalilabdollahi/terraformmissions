# Common mistakes

- **Pinning `tls` back to 3.4.0.** The errors vanish, but the mission requires the 4.x provider (the validator checks the lock file).
- **Setting `key_algorithm = null`.** It leaves a dead argument behind and the validator rejects the name; the migration is to remove the line.
- **Deleting the certificate request or the certificate.** Both files are deliverables.
- **Changing `algorithm` on the private key** to match some expectation. The key was never the problem.
- **Ignoring the plan after validate passes.** Always read the plan after a provider upgrade; it is where changed defaults show up.
