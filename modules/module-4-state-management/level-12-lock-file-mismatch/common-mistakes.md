# Common mistakes

- **Changing the constraint back to `~> 3.5.0`.** The error disappears, but the module needed the newer provider; the mission keeps `~> 3.6`.
- **Deleting `.terraform.lock.hcl`.** It "works" but discards checksums, and the validator expects the lock file to be updated, not removed.
- **Editing the version number in the lock file by hand.** The hashes then belong to the old build and init fails the checksum verification.
- **Running `terraform init -reconfigure` or `-migrate-state`.** Those flags are about backends, not providers.
- **Running `terraform init -upgrade` and forgetting `apply`.** The mission also expects the generated catalog output.
