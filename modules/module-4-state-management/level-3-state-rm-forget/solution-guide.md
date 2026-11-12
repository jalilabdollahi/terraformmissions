# Walkthrough — Stud Book Handover

1. **Check what is managed.**
   ```bash
   terraform state list
   # local_file.vet_log
   # local_file.stud_book
   # random_id.season_tag
   ```
2. **Forget the stud book, do not destroy it.**
   ```bash
   terraform state rm local_file.stud_book
   # Removed local_file.stud_book
   # Successfully removed 1 resource instance(s).
   ```
   The file `records/stud-book.txt` is still on disk.
3. **Remove the block from main.tf.** If you skip this, `terraform plan` says
   `local_file.stud_book will be created` and would overwrite the association's file.
4. **Confirm.** `terraform plan` prints "No changes". `ls records/` shows both files. Type `check`.
