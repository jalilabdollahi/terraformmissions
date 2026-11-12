# Common mistakes

- **Running `terraform apply` to "get everything back".** It creates new random values, overwrites the backup and makes the original values unrecoverable (except by `reset`).
- **Using `terraform state push terraform.tfstate.backup` without `-force`.** Terraform refuses because the backup has a lower serial than the current state.
- **Running `terraform apply` again before restoring.** Every apply rewrites `terraform.tfstate.backup`, so the good copy is lost.
- **Importing the three objects one by one.** `random_pet` cannot be imported at all, and the other two would need exact IDs, which is far more work than a file copy.
- **Restoring the backup, then applying a "fix" to the plan.** If the plan is not clean after the restore, something else is wrong, so do not apply blindly.
