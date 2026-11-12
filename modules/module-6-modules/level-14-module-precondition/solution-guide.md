# Walkthrough — Balloon Basket Limits

1. **Plan with the defaults.**
   ```
   Error: Resource precondition failed
     on modules/booking/main.tf line 18, in resource "terraform_data" "basket":
     Basket overloaded: sunrise flights carry at most 8 passengers, standard flights at most 12.
   ```
   Ten passengers on a standard flight is legal, so the rule is wrong, not the caller.
2. **Read the condition.** `sunrise ? passengers <= 12 : passengers <= 8` has the limits swapped.
3. **Swap them:** `var.flight_class == "sunrise" ? var.passengers <= 8 : var.passengers <= 12`.
4. Try `-var flight_class=sunrise -var passengers=9`: now the module rightfully rejects it. Apply defaults, then `check`.
