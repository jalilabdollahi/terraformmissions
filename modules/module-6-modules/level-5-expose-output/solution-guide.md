# Walkthrough — Town Crier Call Roster

1. **Plan.**
   ```
   Error: Unsupported attribute
     on main.tf line 12, in output "next_call":
     This object does not have an attribute named "next_call".
   ```
2. **Open the module.** `modules/crier/main.tf` has variables, a local and a resource, but no `output` block.
3. **Declare the outputs in the module.**
   ```hcl
   output "next_call" {
     value = local.next_call
   }

   output "roster_file" {
     value = local_file.roster.filename
   }
   ```
4. `terraform apply`, then `check`. Try `-var hour=23` to see the midnight wrap-around.
