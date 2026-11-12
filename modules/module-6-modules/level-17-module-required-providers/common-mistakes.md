# Common mistakes

- **Downgrading the root to `~> 1.4`.** Init may succeed against an older provider, but the ship standardises on the 2.x
  provider and the validator requires it.
- **Deleting the module's `required_providers`.** Terraform then infers the provider but you lose the documented source
  address and range; reusable modules should declare what they need.
- **Running `terraform init -upgrade` and hoping.** It re-resolves with the same impossible constraints.
- **Using `>= 2.4, < 2.5`.** It excludes the version the root requires, so the conflict remains.
