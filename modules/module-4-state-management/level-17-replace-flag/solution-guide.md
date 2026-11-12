# Walkthrough — Stage Door Codes

1. **Find the exact address.**
   ```bash
   terraform state list
   # random_integer.door_code["booth"]
   # random_integer.door_code["box-office"]
   # ...
   ```
2. **Preview the replacement.**
   ```bash
   terraform plan -replace='random_integer.door_code["booth"]'
   # random_integer.door_code["booth"] will be replaced, as requested
   # Plan: 1 to add, 1 to change, 1 to destroy.
   ```
   The one "change" is the crew card file, which lists all codes.
3. **Apply it.**
   ```bash
   terraform apply -replace='random_integer.door_code["booth"]'
   ```
4. `terraform plan` is clean again, `cards/crew.txt` shows a new booth code, the other three are unchanged. Type `check`.
