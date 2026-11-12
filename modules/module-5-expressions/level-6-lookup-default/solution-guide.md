# Walkthrough — Cobbold Feed Whiteboard

1. `terraform plan` fails with `Invalid index` with the message "the given key does not identify an element in this collection
   value" for the `okapi` key.
2. In `terraform console`:
   ```
   > var.rations_kg["okapi"]                 # error
   > lookup(var.rations_kg, "okapi")         # error, but a different message
   > lookup(var.rations_kg, "okapi", 3)      # 3
   ```
3. Replace `var.rations_kg[animal]` with `lookup(var.rations_kg, animal, var.standard_ration_kg)`.
   Do not paste the literal `3`: the standard ration is a variable the vet changes.
4. Apply and run `check`.
