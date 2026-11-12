# Walkthrough — Hive Handover

1. **Check what is managed.**
   ```bash
   terraform state list
   # local_file.inspection_log
   # local_file.queen_registry
   # random_id.season_tag
   ```
2. **Forget the registry, do not destroy it.**
   ```bash
   terraform state rm local_file.queen_registry
   # Removed local_file.queen_registry
   # Successfully removed 1 resource instance(s).
   ```
   The file `records/queen-registry.txt` is still on disk.
3. **Remove the block from main.tf.** If you skip this, `terraform plan` says
   `local_file.queen_registry will be created` and would overwrite the association's file.
4. **Confirm.** `terraform plan` prints "No changes". `ls records/` shows both files. Type `check`.
