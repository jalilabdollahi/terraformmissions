# Solution guide

1. `terraform apply` succeeds, which is the trap. `cat hoststand/slip.txt` prints
   `Your table: random_pet.table.id, seat random_integer.seat.result`, and
   `terraform output` shows the same strings in quotes.
2. In HCL a quoted string is literal text. Only `${...}` inside the quotes is evaluated, and an unquoted
   expression is evaluated as a reference.
3. Outputs: write `value = random_pet.table.id` and `value = random_integer.seat.result` without quotes.
4. File content: use interpolation, `"Your table: ${random_pet.table.id}, seat ${random_integer.seat.result}\n"`.
5. `terraform apply` rewrites the slip; the pet and integer are untouched (same values).
