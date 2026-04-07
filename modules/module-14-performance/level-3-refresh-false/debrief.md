# The Stale State Problem

## What Was Broken
`lifecycle { ignore_changes = all }` is a blunt instrument that tells Terraform to never modify
a resource regardless of what drifts. While useful in rare edge cases (e.g. externally managed
resources), it is almost always an anti-pattern because it prevents Terraform from enforcing
desired state and silently hides real configuration errors.

## The Fix
Replace `ignore_changes = all` with `ignore_changes = [keepers]` to only ignore the specific
attribute that is legitimately managed outside Terraform.

## -refresh=false Explained
`terraform plan -refresh=false` skips the state refresh step (reading real infrastructure state).
Use cases:
- **Speed**: skipping refresh on large configs with hundreds of resources
- **Offline/air-gapped environments**: no API access during planning
- **Using a known-good state snapshot**: avoid re-querying APIs when state is known accurate

**Risk:** If real infrastructure has drifted since last refresh, `-refresh=false` will miss it.
Always understand whether your state is trustworthy before using this flag.

## Key Takeaway
`ignore_changes = all` is a last resort. Always prefer `ignore_changes = [specific_attribute]`
to maintain Terraform's ability to detect and correct real drift.