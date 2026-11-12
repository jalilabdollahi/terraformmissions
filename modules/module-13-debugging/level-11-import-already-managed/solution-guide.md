# Walkthrough - Pixel Palace Duplicate

1. `terraform plan` ends with
   `random_integer.cabinet_dup will be destroyed (because random_integer.cabinet_dup is not in configuration)`.
   Nobody added that address to `main.tf`.
2. Compare state with code:
   ```bash
   terraform state list
   terraform state show random_integer.cabinet_code
   terraform state show random_integer.cabinet_dup
   ```
   Both show the same `id` and `result`: one real cabinet, two addresses.
3. Terraform allows importing one object to several addresses; it never checks other addresses for the same ID.
   With real infrastructure, destroying "the extra one" would delete the object the real resource manages.
4. Remove only the surplus address from state:
   ```bash
   terraform state rm random_integer.cabinet_dup
   ```
   (A `removed { from = ... lifecycle { destroy = false } }` block is the declarative alternative.)
5. `terraform plan` -> no changes. `check`.
