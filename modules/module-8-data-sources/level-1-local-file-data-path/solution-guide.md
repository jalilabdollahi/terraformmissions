# Walkthrough — Steelpan Tuning Sheet

1. **Diagnose.** `terraform plan` stops with an error from `data.local_file.tuning_sheet`:
   `open .../tuning/tenor-lead.txt: no such file or directory`. Data sources are read at plan
   time, so a bad path fails before anything else is planned.
2. **Look at the disk.** `ls` shows the sheet lives at `sheets/tenor-lead.txt`; there is no
   `tuning/` folder.
3. **Fix the path.**
   ```hcl
   data "local_file" "tuning_sheet" {
     filename = "${path.module}/sheets/tenor-lead.txt"
   }
   ```
4. `terraform apply`, then `terraform output`. You should see `pan_name = "Tenor Lead"` and
   `note_count = 29`. Type `check`.
