# Common mistakes

- **Deleting the broken state and re-applying.** Terraform happily creates four brand-new random serials. Every
  trigger-board firmware now disagrees with the trigger system.
- **Restoring the backup and applying immediately.** The plan wants to create `random_id.trigger["west"]`; the
  fresh serial overwrites `station-west.cfg`, destroying the only record of the real one.
- **Running more state commands before copying `.backup` aside.** The next write rotates the backup; the good
  copy is replaced by whatever was just written.
- **Importing without quoting the key.** `random_id.trigger[west]` or unquoted double quotes are rejected or
  mangled by the shell, and people respond by renaming the resource.
- **Dropping the west station from the config to get a green plan.** The plan is clean, one station is dark.
