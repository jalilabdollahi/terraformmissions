# Common mistakes

- **Renaming the local name instead of the source.** Changing `local = {` to `localfile = {` makes the
  `local_file` resource lose its provider, and `init` complains about a missing provider instead.
- **Adding a `provider "local" {}` block.** Provider blocks configure a provider; they do not tell
  Terraform where to download it from.
- **Deleting `terraform.tf` entirely.** Terraform then guesses `hashicorp/local` for `local_file` and may
  work, but the mission requires the explicit `required_providers` declaration.
- **Forgetting to re-run `terraform init`.** The error persists until init has installed the provider.
