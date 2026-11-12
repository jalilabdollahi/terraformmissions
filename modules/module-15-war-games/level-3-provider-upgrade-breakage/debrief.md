# Post-mortem — Indigo Row Provider Bump

**Timeline.** Tuesday 16:00 the platform team raised the tls constraint to `~> 4.0` in `terraform.tf`. 16:05 CI
failed in `init`; a quick local hack made `validate` appear to pass on another branch while the plan still
wanted to replace resources. Wednesday 05:30 on-call took over, upgraded the lock file, removed the dead
arguments, and reviewed the replacement list before applying.

**Root causes.**
1. A constraint bump without `terraform init -upgrade`, so the lock file kept an old, incompatible selection.
2. A major provider version removed configurable arguments that became computed (read-only).
3. Provider-side defaults changed. A state written by the old schema reads as "null" for the new arguments,
   and a new default value plus a force-new flag turns into a replacement.

**What matters during an upgrade incident.** Not every replacement is equal. Certificates and signing requests
are derived data: reissue them and nothing outside the system notices. Private keys are identity: the
scanners pin them, so a plan that touches `tls_private_key` is a stop sign. Reading the replace list resource
by resource is the whole skill.

**Prevention.**
- Upgrade providers in a dedicated PR that includes the regenerated lock file and a reviewed plan.
- Run `terraform plan` in CI for every constraint change, not just `validate`.
- Keep a state snapshot before the first apply with a new major version; the schema upgrade is one-way.
- Consider `lifecycle { prevent_destroy = true }` on key material so a bad upgrade fails loudly.
