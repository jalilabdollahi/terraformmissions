# Lock File Hash Conflict

## What Was Broken
The `.terraform.lock.hcl` contained fabricated hashes that do not match the real provider binary.
Terraform's hash verification detected the mismatch and aborted `init`.

## The Fix
```bash
rm -f .terraform.lock.hcl
terraform init
```

## Lock File Hash Verification
Terraform computes multiple hash types for downloaded providers:
- `h1:` — hash of the zip file
- `zh:` — hash of the extracted files

Both must match what the registry reported at lock time.

## Why It Matters
Hash verification is a supply chain security measure. Never manually edit the lock file.
If hashes mismatch, investigate whether the provider was tampered with before simply regenerating.