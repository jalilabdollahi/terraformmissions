# Walkthrough - Every Room Every Day

1. `terraform plan` says *Invalid for_each argument ... must be a map, or set of strings, and you have
   provided a value of type list of tuple*. `setproduct()` yields `[["atrium","fri"],["atrium","sat"],...]`.
2. A `for_each` map needs a unique string key per instance and a value you can read. The natural key of a
   pair is its two parts joined:
   ```hcl
   room_days = {
     for pair in setproduct(var.rooms, var.days) :
     "${pair[0]}/${pair[1]}" => { room = pair[0], day = pair[1] }
   }
   ```
3. The resource then works unchanged: `each.value.room` and `each.value.day` are real attributes now.
4. Apply: six bookings keyed `atrium/fri` ... `loft/sat`. Planning with an extra day adds three more and
   changes nothing else.
