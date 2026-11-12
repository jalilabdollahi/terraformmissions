# Walkthrough: Target Seven Stands Down

1. **Plan.** It says `local_file.target_7 will no longer be managed by Terraform, but will not be destroyed`
   (`destroy = false`). `targets/target-7.txt` stays and no receipt is written.
2. **Read the removed block.** `lifecycle { destroy = false }` is for handing an object to someone else
   without deleting it. This mission is the opposite: a real closure.
3. **Flip it.**
   ```hcl
   removed {
     from = local_file.target_7
     lifecycle { destroy = true }
     provisioner "local-exec" { when = destroy  ... }
   }
   ```
4. **Plan again.** `local_file.target_7 will be destroyed (because local_file.target_7 is not in configuration)`.
   Apply: the log shows `Provisioning with 'local-exec'...` and then the file disappears.
   `receipts/target-7.txt` now exists. Type `check`.
