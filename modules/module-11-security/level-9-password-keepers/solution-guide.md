# Walkthrough — Fiddlestick Locker Combination

1. Apply, then `terraform plan` again. The plan wants to replace `random_password.locker`:
   `keepers = { "stamp" = "..." } -> (known after apply) # forces replacement`.
2. `timestamp()` returns the current time every time Terraform evaluates it, so the keeper is different on every plan.
3. `keepers` is a map of arbitrary strings. When any value in the map changes, the random resource is replaced; otherwise
   the value is kept. Tie it to the deliberate knob:
   ```hcl
   keepers = {
     ticket = var.rotation_ticket
   }
   ```
4. Apply twice (no change on the second), then `terraform apply -var rotation_ticket=RIG-101` to see a deliberate rotation. Type `check`.
