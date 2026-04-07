# Common Mistakes

- **Omitting `required_providers` entirely** — Terraform will try to install the provider using legacy naming.
- **Wrong `source`** — `source` must be `"registry/namespace/provider"` or `"namespace/provider"`. The full form is `"registry.terraform.io/hashicorp/local"` but the short form `"hashicorp/local"` is equivalent.