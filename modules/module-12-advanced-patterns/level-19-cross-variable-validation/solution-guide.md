# Walkthrough: Stools For Every Student

1. **Probe the current behaviour.**
   `terraform plan -var students=99` fails with `Error: Resource precondition failed`: late, inside the resource.
   `terraform plan -var start_hour=18 -var end_hour=17` is accepted.
2. **Move the rule to the inputs.** Terraform 1.9+ lets validation reference other variables:
   ```hcl
   variable "students" {
     validation {
       condition     = var.students <= var.benches * var.stools_per_bench
       error_message = "There are not enough stools ..."
     }
   }
   variable "end_hour" {
     validation {
       condition     = var.end_hour > var.start_hour
       error_message = "The class must end after it starts."
     }
   }
   ```
3. **Remove the `lifecycle` precondition**, since the variable check now covers it.
4. **Re-run the probes.** Both bad inputs now give `Error: Invalid value for variable ... This was checked by the
   validation rule at ...`. A full house (`students=30`) is still accepted. Type `check`.
