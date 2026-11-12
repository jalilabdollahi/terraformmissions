# Solution guide

1. Run `terraform apply` and look at the file tree (`ls`, `ls out`). `shift-board.txt` appears next to `main.tf`
   while `out/pallet-labels.txt` is where it belongs. `terraform output shift_board_path` prints
   `./shift-board.txt`, which confirms where Terraform thinks the file is.
2. In `main.tf` the `local_file.shift_board` filename is `"${path.module}/shift-board.txt"`.
3. Change it to `"${path.module}/out/shift-board.txt"`.
4. `terraform apply`. Terraform sees the filename changed, which forces replacement: it removes the
   old root file and writes the new one. `local_file` creates parent directories automatically.
5. `terraform output shift_board_path` should now end in `/out/shift-board.txt`.
