# Refresh-Only Mode

## What Was Broken
The resource lacked a `lifecycle { ignore_changes = [keepers] }` block. Without it, any change
to the `keepers` map — even an automated process bumping a version key — would cause Terraform
to destroy and recreate the resource. For secrets and tokens, this is catastrophic in production.

## The Fix
Add `lifecycle { ignore_changes = [keepers] }` to stabilize the resource against keeper changes.

## -refresh-only Explained
`terraform apply -refresh-only` updates the Terraform state file to match the current real-world
state WITHOUT making any infrastructure changes. Use it to:
- Reconcile state drift after manual out-of-band changes you want to accept
- Update state after infrastructure changes made directly (e.g. console changes)
- Prepare an accurate state snapshot before a follow-up convergence apply

The workflow: `apply -refresh-only` (accept drift) → review → `apply` (converge config).

**Difference from terraform refresh (deprecated):**
`terraform refresh` was a standalone command that did the same thing. It was deprecated in
Terraform 1.5 in favor of `apply -refresh-only`, which shows a preview before committing.

## Key Takeaway
`-refresh-only` is a safe way to accept reality into your state. Combined with careful
`lifecycle` rules, it gives you precise control over when resources are recreated.