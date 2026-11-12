# Walkthrough — Midnight Kiln Tweak

1. **Detect the drift without changing anything.**
   ```bash
   terraform plan -refresh-only
   # Note: Objects have changed outside of Terraform
   #   # local_file.firing_schedule has been deleted
   ```
   For `local_file`, an edited file counts as "deleted": the provider compares a checksum of the file.
2. **Find out what changed.** The ordinary plan shows the content Terraform would write back:
   `peak_temp_c: 1260`, `hold_minutes: 25`. The file on disk says `1320` and `40`:
   ```bash
   cat kiln/firing-schedule.txt
   ```
3. **Reconcile.** The technician was right, so update the `locals` in main.tf: `peak_temp_c = 1320`,
   `hold_minutes = 40`.
4. **Apply.** The plan shows one resource to add (it rewrites identical content) and re-records it in
   state: `terraform apply`.
5. `terraform plan` now reports no changes. Type `check`.
