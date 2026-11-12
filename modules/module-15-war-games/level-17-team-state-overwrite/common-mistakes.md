# Common mistakes

- **Pushing the copy with the highest serial.** `rescue-hotline-service.json` has serial 40, but it is another project's state; `state push` rejects the lineage and `-force` overwrites the rota with a hotline service.
- **Applying against the stale state.** The plan creates Cleo's badge, the owl slot and a new bay; badges already printed for the keepers are re-issued.
- **Restoring `terraform.tfstate.backup`.** It is the file Terraform wrote one step before the overwrite, and it is older still: serial 8.
- **Hand-repairing the truncated CI artifact.** Guessing the missing half of a JSON file under pressure invents state; the log already tells you what that run created.
- **Using `terraform state push -force` to get past a warning.** The lineage and serial checks are the safety net; a forced push removes them and the next teammate pushes over you.
- **Forgetting the object created after the good copy.** The restored state is correct but not complete; a plan will want a second quarantine bay unless the first is imported.
