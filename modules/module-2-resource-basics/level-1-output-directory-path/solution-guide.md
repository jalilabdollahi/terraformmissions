# Solution guide

1. Run `terraform apply` and look at the file tree (`ls`, `ls out`). `bake-sheet.txt` appears next to `main.tf`
   while `out/price-labels.txt` is where it belongs. `terraform output bake_sheet_path` prints
   `./bake-sheet.txt`, which confirms where Terraform thinks the file is.
2. In `main.tf` the `local_file.bake_sheet` filename is `"${path.module}/bake-sheet.txt"`.
3. Change it to `"${path.module}/out/bake-sheet.txt"`.
4. `terraform apply`. Terraform sees the filename changed, which forces replacement: it removes the
   old root file and writes the new one. `local_file` creates parent directories automatically.
5. `terraform output bake_sheet_path` should now end in `/out/bake-sheet.txt`.
