# Common mistakes

- **Deleting the second block.** The error goes away, but the anchor sheet is no longer produced.
- **Changing only the `filename` of the second block.** The address, not the file name, is duplicated; the error stays.
- **Renaming the original resource.** That works syntactically but makes Terraform destroy and recreate the existing
  object when state holds the old name; keep existing names stable.
- **Moving the second block into a subfolder.** Subdirectories are not part of the module; the flash sheet would never be created.
