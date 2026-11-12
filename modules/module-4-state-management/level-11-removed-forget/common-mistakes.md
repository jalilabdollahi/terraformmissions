# Common mistakes

- **Deleting the resource block and applying.** Without a removed block (or a prior `state rm`), Terraform destroys the permit book.
- **Writing the removed block without `destroy = false`.** The block exists, but the apply deletes the file.
- **Keeping the resource block as well as the removed block.** Terraform reports a conflict: an address cannot both exist and be removed.
- **Putting `lifecycle` outside the block or as `prevent_destroy = true`.** `prevent_destroy` blocks the apply with an error instead of forgetting the object.
- **Running `terraform state rm` instead.** It works, but the mission is the declarative route.
