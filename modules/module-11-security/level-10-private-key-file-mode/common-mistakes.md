# Common mistakes

- **Only changing `file_permission` to `0600` on the `local_file`.** The key is no longer world-readable but is still handled as ordinary content, and the validator expects `local_sensitive_file` plus the `0700` directory.
- **Fixing the mode with `chmod` after apply.** Terraform restores it on the next apply, and the validator checks what Terraform produces.
- **Making the public key `0600` as well.** It works but breaks tools that read the `.pub` file as another user.
- **Switching to `private_key_pem`.** `ssh-keygen` needs the OpenSSH format for an ED25519 key file in this layout.
