# Debrief: ephemeral values only flow into places that do not persist

Terraform state is a plain document. Anything that is part of a resource's attributes ends up in it, and secrets that were
generated, as with a `tls_private_key` resource or a `random_password`, are stored there in clear text. Terraform 1.10
introduced ephemeral values to avoid that: an `ephemeral` resource is opened during a run, its values can be used while the
run lasts, and everything is discarded afterwards, never written to state or plan files.

The safety comes with a rule. An ephemeral value may only be used in contexts that do not persist: other ephemeral
resources, provider and provisioner configuration, ephemeral outputs and variables in child modules, and write-only
arguments. Everywhere else you get the error here. Write-only arguments (`_wo`) were added in Terraform 1.11 for this: the provider
receives the value during apply, uses it, and does not record it. Since nothing is stored, Terraform cannot
see changes, which is why a `_wo_version` argument exists: change it to tell Terraform to send the value again.

The result in this level is a CSR on disk with the private key nowhere to be found afterwards. That is
the right shape for secrets that are only needed to produce something else.

Real-world takeaway: when a provider offers a `_wo` argument for a secret, prefer it together with an ephemeral
source. And always `grep` the state for the secret once, to be sure.
