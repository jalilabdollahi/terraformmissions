# Walkthrough - Two Attendants One Card

1. `terraform apply`, then `ls cards/`: only `supervisor.txt`, `attendant.txt`, `mechanic.txt`. Open
   `supervisor.txt` - it reads `Name: supervisor`, `Role: mara`.
2. In `for_each = var.crew`, `each.key` is the *key* of the map entry (mara) and `each.value` is the
   *value* (supervisor). The config has them reversed in both the filename and the content.
3. Edit the resource:
   ```hcl
   filename = "${path.module}/cards/${each.key}.txt"
   content  = "Name: ${each.key}\nRole: ${each.value}\n"
   ```
4. Apply. Terraform replaces the old files, `attendant.txt` disappears and four operator cards remain.
