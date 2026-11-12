# Walkthrough — Crumb And Kettle

1. **Reproduce.** Run `terraform validate`. The error is:
   ```
   Error: Unclosed configuration block
     on main.tf line 20, in resource "local_file" "oven_schedule":
     20: resource "local_file" "oven_schedule" {
   There is no closing brace for this block before the end of the file.
   ```
2. **Read the numbers.** Line 20 is where the block *opens*. Terraform only notices at the end of the
   file that it never closed, so it points you back at the opening line.
3. **Fix.** Add the missing `}` after the `content` line of `oven_schedule`.
4. **Confirm.** `terraform validate`, then `terraform apply`. `bakery/oven-schedule.txt` appears.
