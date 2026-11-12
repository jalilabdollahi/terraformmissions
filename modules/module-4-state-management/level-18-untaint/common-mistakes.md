# Common mistakes

- **Running `terraform apply` to "see what happens".** The tainted key is destroyed and regenerated; the new fingerprint is not trusted by any device.
- **Editing the key's arguments** (a different curve, an added comment) hoping to clear the mark. The taint persists, and a changed algorithm would force replacement anyway.
- **Using `terraform state rm` and re-importing.** `tls_private_key` does not support import, so the key would be lost for good.
- **Untainting the wrong address.** `terraform untaint local_file.bootloader_pubkey` fails or does nothing; the taint is on the key.
- **Deleting the state file or running `terraform refresh`.** Refresh does not clear a taint.
