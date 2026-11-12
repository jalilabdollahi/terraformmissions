# Common mistakes

- **Fixing `lifecycle` but not `required_providers`.** The two errors appear in different files and different
  commands; `init` reports the first and `validate` the second.
- **Removing `ignore_changes` to make the error go away.** The config validates, but a new inspector name
  rewrites the label, which the mission forbids.
- **Quoting the keyword (`"lifecycle" {`).** Block types are bare words.
- **Removing the `=` from the arguments inside the block.** Only the block keyword drops the equals sign;
  `ignore_changes = [content]` is an attribute and keeps it.
