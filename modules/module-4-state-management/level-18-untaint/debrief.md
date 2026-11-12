# Debrief — taint is a decision stored in state

`terraform taint` (or a failed provisioner) sets a flag on one resource instance in the state: "this
object is not trustworthy, replace it on the next apply". The plan shows `is tainted, so must be replaced` and the
flag survives until something removes it. Changing the code does not clear it.

`terraform untaint ADDRESS` clears the flag and nothing else: no provider call, no new key. Afterwards the plan
compares code and state like normal, and a resource that matches simply stays.

Why this matters more for keys than for most resources: a replaced private key gets a new fingerprint. Every
system that pinned the old public key (bootloaders, trusted CA lists, SSH `authorized_keys`) now rejects the new
signatures. The side effects of a replacement cannot always be undone, so read every plan for
`must be replaced` lines before you apply.

Also useful to know:

- Terraform marks a resource tainted automatically when a creation-time provisioner fails.
- `terraform taint` is deprecated in favour of `plan/apply -replace=ADDRESS`, which can be reviewed in a plan before
  anything is stored. `untaint` remains the correct tool to undo a mark that already exists.
- `terraform state show` and `terraform show` display `# tls_private_key.x: (tainted)` so you can spot marks
  without planning.
