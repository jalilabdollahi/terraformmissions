# Walkthrough - Same Card Four Times

1. `terraform apply`, then `ls cards/` - only `clue.txt` exists although `terraform state list` shows
   `local_file.clue_card[0]` to `[3]`.
2. The `filename` argument is a constant string, so every instance targets the same path. Terraform has
   no way to warn you: four writes to one file is legal.
3. Interpolate the instance number:
   ```hcl
   filename = "${path.module}/cards/clue-${count.index}.txt"
   ```
4. Apply again. `cards/` now has `clue-0.txt` ... `clue-3.txt`, the plan is clean, and the `card_files`
   output lists four different paths.
