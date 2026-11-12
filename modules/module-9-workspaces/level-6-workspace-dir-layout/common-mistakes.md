# Common mistakes

- **Running `terraform apply` to "fix" the empty plan.** It rebuilds files that already exist and mints a
  new state lineage. The original state is then orphaned.
- **Copying instead of moving.** `cp` leaves `winter.tfstate` lying in `terraform.tfstate.d/`. The
  validator rejects stray state files.
- **Putting it in `terraform.tfstate` at the project root.** That is the default workspace's state.
- **Deleting the winter directory and recreating the workspace.** You would get an empty state and the
  original lineage is lost.
- **Renaming the file to `winter.tfstate.json`.** The backend looks for `terraform.tfstate`, nothing else.
