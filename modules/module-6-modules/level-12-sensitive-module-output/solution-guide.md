# Walkthrough — Escape Room Door Code

1. **Plan, read the error.**
   ```
   Error: Output refers to sensitive values
     on main.tf line 17: output "door_code"
   To reduce the risk of accidentally exporting sensitive data that was intended to be only internal, Terraform
   requires that any root module output containing sensitive data be explicitly marked as sensitive...
   ```
   Terraform checks root outputs, and `module.room.code` carries the mark of `random_password`. Add `sensitive = true`
   to the root output.
2. **Fix the source of the secret too.** The module's `output "code"` exposes a password; declare it
   `sensitive = true` there so that every other caller of the module is protected and the interface says what it is.
3. `terraform apply`. `terraform output` shows `door_code = <sensitive>`; `terraform output -raw door_code` prints it.
4. Type `check`.
