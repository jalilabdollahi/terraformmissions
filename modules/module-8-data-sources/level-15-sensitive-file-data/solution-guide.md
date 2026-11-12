# Walkthrough — Till Room Combination

1. **Diagnose.** `terraform apply` shows the combination in the plan for `local_file.door_card`
   and in `combination = "7-31-4-19"` under `Outputs:`. `ls -l tillroom/door-card.txt` shows
   `-rw-r--r--`, readable by everyone.
2. **Swap the data source.** `data "local_sensitive_file" "combination"` has the same arguments but
   marks `content` as sensitive. Update the `local.dial_code` reference to
   `data.local_sensitive_file.combination.content`.
3. **Mark the output.** Terraform now refuses (`Output refers to sensitive values`) until the output
   has `sensitive = true`.
4. **Tighten the file.** `file_permission = "0600"` on the door card.
5. `terraform apply` -> `combination = <sensitive>`; `terraform output -raw combination` still prints
   the value. Type `check`.
