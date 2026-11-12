# Walkthrough: Four Paper Tickets

1. **Plan.** `Plan: 1 to import, 3 to add, 0 to change, 0 to destroy.` Three tickets get new random numbers.
2. **Look at the map.** Every value, such as `"7316,1000,9999"`, is already a complete import ID for
   `random_integer` (`result,min,max`), and the keys match the `for_each` keys of the resource.
3. **Use the same map twice.**
   ```hcl
   import {
     for_each = var.legacy_tickets
     to       = random_integer.ticket[each.key]
     id       = each.value
   }
   ```
4. **Plan again.** `Plan: 4 to import, 0 to add, 0 to change, 0 to destroy.` Apply, then `check`.
