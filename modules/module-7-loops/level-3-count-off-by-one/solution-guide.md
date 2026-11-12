# Walkthrough - Bay Zero

1. `terraform apply`, then `ls signs/`: you get `bay-00.txt` ... `bay-05.txt`. Six files, but numbered
   from zero.
2. `count.index` is zero-based by design; it is also how Terraform addresses the instances
   (`local_file.bay_sign[0]`). Do not try to change that - change what you print.
3. Edit both places the number appears:
   ```hcl
   filename = "${path.module}/signs/${format("bay-%02d", count.index + 1)}.txt"
   content  = "BAY ${count.index + 1} of ${var.bays}\n"
   ```
4. Apply. Terraform replaces the files, deletes `bay-00.txt` and the plan is clean. Note that the last
   instance is still `local_file.bay_sign[5]` - the address and the label are different things.
