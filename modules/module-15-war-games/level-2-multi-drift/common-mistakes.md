# Common mistakes

- **Running `terraform apply` straight away.** It replaces the tainted cocoa lot, reverts the approved 122 F
  hot-fix back to 118, and the new campaign starts with the wrong recipe and wrong wrappers.
- **Using `ignore_changes = all` on the recipe or the files.** The plan goes quiet while kettle A still runs a
  4-second chill.
- **Refresh-only apply as a cure-all.** `apply -refresh-only` records what the world looks like, including
  the typo, and tells you nothing about which side is right.
- **Deleting the kettle B block because its file is missing.** The PLC then has no control file at all.
- **Keeping mold C "just in case".** It keeps appearing as a pending create and will recreate a scrapped
  mold's config the moment someone applies.
