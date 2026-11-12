# Common mistakes

- **Moving the resource blocks to core/ and running apply.** Core creates a new pet and gate count, and
  the root destroys the old ones; the yard name painted on the trucks changes.
- **Forgetting to apply core after moving state.** The moved resources have no outputs recorded yet, so
  the root's remote-state read fails with "Unsupported attribute".
- **Pointing `terraform_remote_state` at the wrong file.** `path.module` of the root plus
  `core/terraform.tfstate`; a path like `../core/...` or the root's own state reads the wrong thing.
- **Reading `random_pet.yard_name` directly from the root.** Resources in another root are invisible;
  only outputs cross the boundary.
