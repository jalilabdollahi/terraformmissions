# Walkthrough — Basecamp Lock File

1. **Look at the lock file.** `.terraform.lock.hcl` has one `h1:` entry under `hashes` (this machine's
   platform). On any other OS, `terraform init` reports that the provider "does not match any of the
   checksums recorded in the dependency lock file".
2. **Ask Terraform for the other platforms.**
   ```bash
   terraform providers lock -fs-mirror=vendor/provider-mirror \
     -platform=linux_amd64 -platform=darwin_arm64 -platform=windows_amd64
   ```
   Normally you would omit `-fs-mirror` and let Terraform fetch from the registry; at base camp (offline) the
   vendored mirror is the source. Output: `Obtained hashicorp/null checksums for linux_amd64 ...`.
3. **Check the result.** The file now has four `h1:` lines. Existing hashes are kept; the command
   only adds. `terraform init` still passes.
4. **Commit the lock file.** It is part of the repository so every machine agrees.
