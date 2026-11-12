# Common mistakes

- **Renaming the resource back to `master`.** The error disappears, but the mission wants the new
  name, so the register and the rest of the code would be out of date.
- **Deleting the moved block.** Terraform then plans to destroy `master` and create `master_key`: a new
  private key and a different fingerprint.
- **Using `terraform state mv` on top of the moved block.** Once the state has moved, the moved block's
  `from` no longer exists and the block is just stale; the mission wants the code to describe the move.
- **Moving only the reference in the `local_file`.** The reference follows the resource name, so
  it changes together with the rename but does nothing for the state entry.
