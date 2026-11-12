# Common mistakes

- **Adding `ephemeral = true` but leaving the token in `input`.** Terraform rejects it with *Invalid use of ephemeral value* because `input` is persisted.
- **Replacing the token with `nonsensitive()` or `sha256()`.** The script needs the real token; and a hash in `input` still changes whenever the token does.
- **Relying on `sensitive = true` alone.** That only masks display; the state still holds the value.
- **Keeping the token in `triggers_replace`.** That argument is persisted to state as well.
- **Deleting the provisioner.** The validator requires the script to run and receive the token in its environment.
