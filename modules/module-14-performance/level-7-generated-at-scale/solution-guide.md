# Walkthrough — Stadium Seat Tags

1. **Spot the pattern.** Each block differs in `a-1-01`: block, row, seat. The filename and content are
   built from those three values.
2. **Write one resource.**
   ```hcl
   locals {
     seats = {
       for t in setproduct(["A","B","C","D","E","F"], range(1, 6), range(1, 11)) :
       "${lower(t[0])}-${t[1]}-${format("%02d", t[2])}" => { block = t[0], row = t[1], seat = format("%02d", t[2]) }
     }
   }
   resource "local_file" "seat" {
     for_each = local.seats
     filename = "${path.module}/seats/${each.key}.txt"
     content  = "Block ${each.value.block}, row ${each.value.row}, seat ${each.value.seat}\n"
   }
   ```
   Delete the 300 old blocks.
3. **Plan before you apply.** A plain plan shows `300 to add, 300 to destroy`. That is the cost of
   changing addresses without telling Terraform.
4. **Generate `moved` blocks** with a shell loop (see hint 3) into `moved.tf`: one per seat,
   `from = local_file.seat_a_1_01`, `to = local_file.seat["a-1-01"]`.
5. **Plan again.** `Plan: 0 to add, 0 to change, 0 to destroy` with 300 moves listed. Apply.
