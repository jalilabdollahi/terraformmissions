# Debrief — one lock file, every platform

`.terraform.lock.hcl` records, per provider, the selected version and a set of **checksums** of the
packages Terraform considers legitimate. `terraform init` adds the checksum for the platform it
runs on. A teammate on a different OS or CPU needs a different package, whose checksum is not in the
file, and Terraform refuses it: that is the lock file doing its job as a supply-chain control.

For mixed teams the answer is to ask for the other platforms explicitly:

```
terraform providers lock -platform=linux_amd64 -platform=darwin_arm64 -platform=windows_amd64
```

By default the command downloads each package from the registry and records both the `h1:` hash and
the `zh:` hashes from the registry's signed checksum list. It never removes existing entries. In an
air-gapped place such as a pit garage you can point it at a local mirror with `-fs-mirror` (or a network
mirror with `-net-mirror`) and it hashes the packages found there.

Habits worth having:

- Commit the lock file; never `.gitignore` it.
- Run `providers lock` for every platform in your CI and developer fleet whenever a provider version
  changes, ideally in a CI job that opens the PR.
- Treat a changed hash for an unchanged version as suspicious, not as noise.
- Do not edit hashes by hand; you would be vouching for a package you never verified.

Real-world takeaway: "works on my laptop, init fails on CI" with a checksum error means the lock
file covers fewer platforms than your team uses.
