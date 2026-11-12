# Common mistakes

- **`terraform init -reconfigure`.** It switches to the empty new path and leaves the real state behind; the plan wants to create new kiosks.
- **Reverting the backend path in terraform.tf.** The error goes away, but the new repository layout is the goal.
- **Copying the state file by hand and then running a plain `init`.** Works only if the cached backend and the file agree; usually you end up with a stale cache and confusing errors.
- **Running `terraform apply` on the error-free but huge plan.** If a plan wants to create everything, you looked at the wrong state.
- **Deleting state/kiosks.tfstate before migrating.** It is the only copy until the migration has succeeded.
