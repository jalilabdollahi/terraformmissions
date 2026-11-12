# Debrief - init is not a one-time command

`terraform init` prepares a working directory: it installs the providers (and modules) your configuration requires and records
the selected versions and checksums in `.terraform.lock.hcl`. It is easy to think of it as setup you do once, but any change to
*requirements* means the directory is out of date: a new provider, a new module source, a changed backend, a different version
constraint.

When that happens, Terraform refuses to run anything else, and the message is accurate even if it looks scary:
it names the provider by its **full source address** (`registry.terraform.io/hashicorp/tls`) and says it is required but has no
selected version. The fix is just `terraform init`. Nothing in your existing state is touched, which is why the boat name in this
level survived.

Things worth remembering:

- The source address matters. `hashicorp/tls` and `somevendor/tls` are different providers; the error shows exactly which one is meant.
- Commit `.terraform.lock.hcl` so teammates and CI install the same versions; do **not** commit `.terraform/`.
- In CI, run `terraform init` on every job (it is cheap with a plugin cache), so a merged branch never meets a stale checkout.
- `terraform init -upgrade` is for *changing* selected versions within constraints, not for adding a provider.

Reading the error before running anything is the habit: it tells you whether init is enough or whether the constraint itself is
unsatisfiable (the next levels cover that).
