# Walkthrough — Velvet Door Codes

1. **Find the exact address.**
   ```bash
   terraform state list
   # random_integer.door_code["dj"]
   # random_integer.door_code["cloakroom"]
   # ...
   ```
2. **Preview the replacement.**
   ```bash
   terraform plan -replace='random_integer.door_code["dj"]'
   # random_integer.door_code["dj"] will be replaced, as requested
   # Plan: 1 to add, 1 to change, 1 to destroy.
   ```
   The one "change" is the staff card file, which lists all codes.
3. **Apply it.**
   ```bash
   terraform apply -replace='random_integer.door_code["dj"]'
   ```
4. `terraform plan` is clean again, `cards/staff.txt` shows a new dj code, the other three are unchanged. Type `check`.
