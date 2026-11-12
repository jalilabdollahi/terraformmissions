# Common mistakes

- **Renaming the block back to `keeper`.** The plan goes clean, but the mission (and your teammate's
  refactor) needs the new name.
- **Running `terraform apply` right away.** The old codename is destroyed and a new one generated.
  Badges reprinted, mission failed.
- **Swapping the arguments.** `terraform state mv <source> <destination>` — the old address comes first.
- **Editing `terraform.tfstate` by hand.** It works until you forget to bump `serial` or break the
  JSON. Use the CLI.
