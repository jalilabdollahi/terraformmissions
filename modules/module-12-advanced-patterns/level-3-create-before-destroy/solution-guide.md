# Walkthrough: Billboard Never Goes Dark

1. **Plan.** `terraform plan` shows `local_file.billboard must be replaced` with the action order
   `+/-` (create replacement and then destroy deposed object). That is create_before_destroy at work.
2. **Apply and look.** After apply `billboard/current-ad.txt` does not exist. Terraform wrote the new
   file, then destroyed the old object, and the old object's destroy deletes `filename`. Both objects
   share the same path.
3. **Fix the collision, not the order.** Dropping `create_before_destroy` would hide the symptom
   but the sign would be blank during the swap. Instead give every board its own name:
   ```hcl
   filename = "${path.module}/billboard/current-ad-${local.slug}.txt"
   ```
4. Apply again. The plan shows create-then-delete of two different files. `billboard/` ends up with only
   `current-ad-return-of-the-giant-ant.txt`. Type `check`.
