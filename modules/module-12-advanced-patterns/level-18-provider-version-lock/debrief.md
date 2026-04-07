# Corrupted Lock File

## What Was Broken
`.terraform.lock.hcl` contained invalid hashes for the `hashicorp/local` provider.
Terraform verifies provider hashes against the lock file to ensure integrity —
an invalid hash causes `init` to abort.

## The Fix
```bash
rm -f .terraform.lock.hcl
terraform init -upgrade
```
Terraform regenerates the lock file with correct hashes from the registry.

## Lock File Purpose
- Pins exact provider versions and their cryptographic hashes
- Ensures all team members use identical provider binaries
- Should be committed to version control

## When to Delete the Lock File
- When hashes are corrupted or manually edited incorrectly
- When upgrading to a new platform/architecture
- Never delete it casually — it protects supply chain integrity

## Why It Matters
The lock file is a security control. Tampering with it (accidentally or maliciously) can
allow different provider binaries to be used than intended.