# Walkthrough — Hollin Diet Whiteboard

1. `terraform plan` fails with `Invalid index` with the message "the given key does not identify an element in this collection
   value" for the `low_salt` key.
2. In `terraform console`:
   ```
   > var.batch_kg["low_salt"]                 # error
   > lookup(var.batch_kg, "low_salt")         # error, but a different message
   > lookup(var.batch_kg, "low_salt", 3)      # 3
   ```
3. Replace `var.batch_kg[diet]` with `lookup(var.batch_kg, diet, var.standard_batch_kg)`.
   Do not paste the literal `3`: the standard batch is a variable the head cook changes.
4. Apply and run `check`.
