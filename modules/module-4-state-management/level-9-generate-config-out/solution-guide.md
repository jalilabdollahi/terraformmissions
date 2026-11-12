# Walkthrough — Dome Controller Roster

1. **Generate a draft.**
   ```bash
   terraform plan -generate-config-out=generated.tf
   # Plan: 3 to import, 0 to add, 0 to change, 0 to destroy.
   ```
   The target file must not exist. Terraform writes three complete resource blocks into it.
2. **Read the draft.** It begins with `# __generated__ by Terraform` and lists every attribute, including
   `keepers = null`, `seed = null`, `override_special = null`.
3. **Merge and tidy.** Move the three blocks into `main.tf`, remove the lines that end in `= null` and the
   generator comments, then delete `generated.tf`. (Leaving explicit nulls in is harmless to Terraform, but
   it is noise that reviewers must read, which is why the team rule exists.)
4. **Import.** `terraform plan` shows `3 to import`; run `terraform apply`.
5. `terraform plan` is clean. Type `check`.
