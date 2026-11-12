# Common mistakes

- **Pointing `-generate-config-out` at an existing file.** Terraform refuses to overwrite it. Use a new name, or delete the old draft.
- **Leaving generated.tf next to main.tf.** The configuration works, but rule 1 says all resources live in main.tf, and duplicates cause "resource already declared" errors if both files hold them.
- **Deleting attributes that are not `null`.** Removing `length` or `min`/`max` changes the plan; only the `= null` lines are safe to strip.
- **Writing the resource blocks from scratch with guessed arguments.** A wrong `max` or `special` flag forces replacement of the live credential.
- **Skipping `terraform apply`.** Imports only enter the state on apply; plan alone proves nothing is recorded.
