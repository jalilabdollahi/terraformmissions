# Common mistakes

- **Deleting `signing.tf` to make the error go away.** The mission needs the signing key and the signature card.
- **Running `terraform init -upgrade`.** It works here, but it also re-resolves every other provider; plain `init` is
  the right, minimal command.
- **Removing `.terraform.lock.hcl` or the whole `.terraform/` directory.** Not needed, and it throws away the recorded
  version selections.
- **Writing `hashicorp/tls` (without the host) in the answer.** The mission asks for the full source address exactly as
  Terraform prints it.
- **Running `terraform apply -refresh=false` or `-target`.** They do not install anything; the plugin is still missing.
