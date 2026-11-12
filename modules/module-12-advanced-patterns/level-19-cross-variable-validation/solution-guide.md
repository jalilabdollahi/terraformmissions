# Walkthrough: Seats For Every Quilter

1. **Probe the current behaviour.**
   `terraform plan -var guests=99` fails with `Error: Resource precondition failed`: late, inside the resource.
   `terraform plan -var start_hour=18 -var end_hour=17` is accepted.
2. **Move the rule to the inputs.** Terraform 1.9+ lets validation reference other variables:
   ```hcl
   variable "guests" {
     validation {
       condition     = var.guests <= var.tables * var.seats_per_table
       error_message = "There are not enough seats ..."
     }
   }
   variable "end_hour" {
     validation {
       condition     = var.end_hour > var.start_hour
       error_message = "The session must end after it starts."
     }
   }
   ```
3. **Remove the `lifecycle` precondition**, since the variable check now covers it.
4. **Re-run the probes.** Both bad inputs now give `Error: Invalid value for variable ... This was checked by the
   validation rule at ...`. A full house (`guests=30`) is still accepted. Type `check`.
