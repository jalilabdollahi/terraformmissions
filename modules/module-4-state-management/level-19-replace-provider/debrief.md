# Debrief — providers have addresses, and state remembers them

Before Terraform 0.13, a provider was just a short name such as `random`. Since 0.13 every provider is
identified by a full source address: `registry.terraform.io/<namespace>/<type>`, for example
`registry.terraform.io/hashicorp/random`. The state stores this address for every resource. Old states
used the placeholder namespace `-`, meaning "legacy, unknown", and modern Terraform will not guess.

`terraform state replace-provider FROM TO` rewrites that stored address for every resource that uses it.
It changes only the state file; no provider is called, no object is touched. The same command covers a
second real-world case: you move from a provider fork to the official one (or the other way round) and the
resources must follow.

Rules of thumb:

- Back up first (`terraform state pull > before.tfstate`), because the rewrite is not reversible except by
  restoring that copy.
- Make sure `required_providers` in your code already uses the **new** source, and run `terraform init`
  afterwards so the new provider is installed and locked.
- Never delete the state and re-import as a shortcut: many resources (random values, private keys) cannot be
  imported, and the ones that can need exact IDs.

The pattern generalises: when Terraform complains that it cannot read an old state, ask what the state
believes (`terraform providers`, the raw JSON) before touching the code.
