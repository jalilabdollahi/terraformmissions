# Walkthrough — Kiosk State Relocation

1. **Read the error.**
   ```bash
   terraform plan
   # Error: Backend initialization required, please run "terraform init"
   #   Reason: Backend configuration block has changed
   ```
2. **Find the old state.** `ls state/` shows `kiosks.tfstate`; `ls vault/` does not exist yet.
3. **Migrate, do not reconfigure.**
   ```bash
   terraform init -migrate-state
   # Do you want to copy existing state to the new backend?  Enter a value: yes
   ```
   Use `-force-copy` to answer yes automatically.
4. `terraform state list` shows the three resources, `ls vault/` shows the new file, and `terraform plan` is clean.
   Type `check`.
