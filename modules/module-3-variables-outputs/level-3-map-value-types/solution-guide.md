# Walkthrough — Fernwood Nursery

1. **Diagnose.** `terraform validate` reports `Invalid default value for variable ... element "tomato":
   string required.` The default is a map whose values are objects.
2. **Understand.** `map(string)` demands that every value is a string. Each seedling is an object
   `{ days = 7, tray = "A" }`, so the *value* type is wrong, not the data.
3. **Fix.** Describe the real shape:
   ```hcl
   type = map(object({
     days = number
     tray = string
   }))
   ```
4. **Verify.** `terraform apply` creates four label files; `terraform output slowest_days` is `14`.
