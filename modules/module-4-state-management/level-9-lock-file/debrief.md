# Lock File Chaos

## What Was Broken
`.terraform.lock.hcl` contained fake hashes that don't match the actual provider binary.
Terraform verifies these hashes on every `init` to detect tampering or corruption.

## The Fix
Delete the broken lock file:
```bash
rm .terraform.lock.hcl
terraform init -upgrade
```

## .terraform.lock.hcl
The lock file:
- Records the exact provider versions and their cryptographic hashes
- Should be committed to version control
- Ensures all team members use the same provider version
- Is automatically updated by `terraform init -upgrade`

## Why It Matters
Provider lock files are a security and reproducibility feature. They prevent silent upgrades
or supply-chain attacks where a provider binary is swapped for a malicious one.