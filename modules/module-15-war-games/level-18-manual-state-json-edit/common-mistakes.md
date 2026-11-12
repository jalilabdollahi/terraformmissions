# Common mistakes

- **Deleting `terraform.tfstate` and re-applying.** The state loads again, but every hound tag and harvest quota is regenerated; the inspector's certificates are void.
- **Fixing only `schema_version`.** Terraform loads the state, but the plan then wants to destroy `random_id.hound_tag[0]`... and create the named instances, i.e. re-roll everything; the positions are not names.
- **Assigning keys alphabetically "because that is the order".** Instances were renumbered by a script; only the values prove which one is which, and `out/inspection-log.txt` lists them. Swapped tags plan cleanly and are wrong.
- **Editing without a backup, or with a different lineage.** One bad `jq` expression truncates the file; a changed lineage makes every teammate's push fail.
- **Forgetting to bump `serial`.** Locally it works, and it silently breaks the next `state push` or remote-backend sync, which use the serial to decide which copy is newer.
- **Changing the provider constraint to chase the pre-release build.** It is withdrawn and not in the mirror; the right fix is in the state, not in the requirement.
