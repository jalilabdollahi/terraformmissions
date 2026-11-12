# Debrief - what "tainted" really means

Provisioners run only when an object is created (or destroyed). If a creation-time provisioner exits non-zero,
Terraform cannot know what state the real world is in, so it records the object *as tainted*: "it exists, but do not
trust it". The next plan proposes a replace (`-/+`) for it.

The important consequence is the one this level tests: **fixing the cause is not enough, and neither is clearing
the flag.** Terraform has to run the creation again, and for that the old object must be destroyed.

- `terraform untaint` tells Terraform to trust the object. Use it only when you have verified that the failure was
  harmless (for example the script did all its work and failed in a final notification step).
- `terraform apply -replace=ADDRESS` forces a replace on an object that is *not* tainted; that is the tool for
  re-running a provisioner on a healthy resource.
- `on_failure = continue` would have kept the apply "green" and hidden the broken flash, the subject of a later
  level in this module.

In real fleets this is the difference between a van with the old firmware and a van with a half-written image. Always
read the provisioner output of the *first* failure (it is in the apply log), and keep provisioner scripts idempotent
so that running them again on a replaced object is safe.
