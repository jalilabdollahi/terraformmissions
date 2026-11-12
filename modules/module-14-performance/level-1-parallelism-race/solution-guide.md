# Walkthrough — Foundry Pour Order

1. **Reproduce.** `terraform apply` (default parallelism). The apply ends with
   `Error: local-exec provisioner error ... cat: ./foundry/alloy-ledger.txt: No such file or directory`
   (or `foundry/casting-slip.txt: No such file or directory`, depending on timing).
2. **Look at the graph.** `terraform graph` shows `local_file.alloy_ledger -> time_sleep.furnace_settle`
   but nothing connecting `terraform_data.casting_slip` to the ledger. The slip's command mentions the
   ledger only inside a plain string, which Terraform cannot parse for dependencies.
3. **Fix the cause.** Make the dependency visible to Terraform. In `main.tf`:
   ```hcl
   resource "terraform_data" "casting_slip" {
     depends_on = [local_file.alloy_ledger]
     provisioner "local-exec" {
       command = "cat ${local_file.alloy_ledger.filename} > ${path.module}/foundry/casting-slip.txt"
     }
   }
   ```
   Referencing `local_file.alloy_ledger.filename` already creates the edge; `depends_on` documents it.
4. **Remove the crutch.** Delete `-parallelism=1` from `scripts/deploy.sh`.
5. **Verify.** `terraform destroy`, then `terraform apply` a few times. The graph now contains
   `"terraform_data.casting_slip" -> "local_file.alloy_ledger"`.
