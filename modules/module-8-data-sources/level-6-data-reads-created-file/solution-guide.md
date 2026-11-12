# Walkthrough — Formulator's Batch Sheet

1. **Reproduce.** On a clean workspace `terraform plan` fails in `data.local_file.batch_sheet` with
   "no such file or directory" for `bench/batch-sheet.txt`. The file is created by
   `local_file.batch_sheet`, but that has not run yet.
2. **Diagnose.** The data source and the resource use the same literal path string, so Terraform has
   no idea they are related. Data sources with no pending dependencies are read at plan time.
3. **Fix.** Create the dependency by referencing the resource:
   ```hcl
   data "local_file" "batch_sheet" {
     filename = local_file.batch_sheet.filename
   }
   ```
   (`depends_on = [local_file.batch_sheet]` also works.) Now the read is postponed to apply time,
   after the sheet is written.
4. `terraform apply` -> `fragrance_g = 14.4`. Then `terraform apply -var base_grams=500` ->
   `fragrance_g = 30`. Type `check`.
