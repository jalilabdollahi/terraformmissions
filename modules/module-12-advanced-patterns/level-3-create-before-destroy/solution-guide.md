# Walkthrough: Marquee Never Goes Dark

1. **Plan.** `terraform plan` shows `local_file.marquee must be replaced` with the action order
   `+/-` (create replacement and then destroy deposed object). That is create_before_destroy at work.
2. **Apply and look.** After apply `marquee/now-showing.txt` does not exist. Terraform wrote the new
   file, then destroyed the old object, and the old object's destroy deletes `filename`. Both objects
   share the same path.
3. **Fix the collision, not the order.** Dropping `create_before_destroy` would hide the symptom
   but the sign would be blank during the swap. Instead give every board its own name:
   ```hcl
   filename = "${path.module}/marquee/now-showing-${local.slug}.txt"
   ```
4. Apply again. The plan shows create-then-delete of two different files. `marquee/` ends up with only
   `now-showing-return-of-the-giant-ant.txt`. Type `check`.
