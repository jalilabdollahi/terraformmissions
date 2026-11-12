# Debrief — the lock file is a second source of truth

`terraform.tf` says which provider versions are *allowed* (`~> 3.6` means 3.6 or newer within 3.x).
`.terraform.lock.hcl` says which exact version is *chosen*, together with checksums that prove the
downloaded binary is the one everyone else got. Plain `terraform init` always honours the lock file:
if a locked version still satisfies the constraint it uses it, and if it does not, it stops with an error instead of
silently changing versions.

`terraform init -upgrade` is the explicit instruction "ignore the pins and select the newest versions
allowed by the constraints". It rewrites the lock file, so it creates a diff you must review and commit.

Good habits:

- **Commit the lock file.** It makes CI and every teammate use the same provider build.
- **Raise the constraint and the lock together,** in the same pull request, with `init -upgrade`.
- **Never "fix" the error by loosening the constraint** back to the old version unless you intend to keep
  the old provider.
- **Multi-platform teams** should also run `terraform providers lock -platform=linux_amd64 -platform=darwin_arm64`,
  so the lock holds checksums for every operating system that runs the config.

Deleting the lock file also silences the error, but it throws away the checksums that protect you
from a tampered provider package. Upgrade deliberately instead.
