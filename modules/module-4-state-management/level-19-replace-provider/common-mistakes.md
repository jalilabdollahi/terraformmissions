# Common mistakes

- **Deleting terraform.tfstate and re-applying.** Every crate tag and pallet count would be re-drawn, which the project is trying to avoid.
- **Changing `required_providers` to a legacy-looking source.** The error is in the state, not the code; the code already uses `hashicorp/random`.
- **Editing terraform.tfstate with a text editor.** It can work, but a typo breaks the JSON or checksums; `replace-provider` does it safely and keeps a backup.
- **Swapping FROM and TO.** The old (current-in-state) address comes first.
- **Skipping `terraform init` afterwards.** The provider plugin and the lock file still need to match the corrected address.
