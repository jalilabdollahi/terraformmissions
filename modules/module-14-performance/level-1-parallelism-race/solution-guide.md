# Walkthrough — Sugar-Glass Melt Order

1. **Reproduce.** `terraform apply` (default parallelism). The apply ends with
   `Error: local-exec provisioner error ... cat: ./workshop/syrup-ledger.txt: No such file or directory`
   (or `workshop/label-slip.txt: No such file or directory`, depending on timing).
2. **Look at the graph.** `terraform graph` shows `local_file.syrup_ledger -> time_sleep.stove_settle`
   but nothing connecting `terraform_data.label_slip` to the ledger. The slip's command mentions the
   ledger only inside a plain string, which Terraform cannot parse for dependencies.
3. **Fix the cause.** Make the dependency visible to Terraform. In `main.tf`:
   ```hcl
   resource "terraform_data" "label_slip" {
     depends_on = [local_file.syrup_ledger]
     provisioner "local-exec" {
       command = "cat ${local_file.syrup_ledger.filename} > ${path.module}/workshop/label-slip.txt"
     }
   }
   ```
   Referencing `local_file.syrup_ledger.filename` already creates the edge; `depends_on` documents it.
4. **Remove the crutch.** Delete `-parallelism=1` from `scripts/deploy.sh`.
5. **Verify.** `terraform destroy`, then `terraform apply` a few times. The graph now contains
   `"terraform_data.label_slip" -> "local_file.syrup_ledger"`.
