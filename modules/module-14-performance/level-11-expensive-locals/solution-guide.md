# Walkthrough — Piece Press Index Costs

1. **Count.** `grep -c 'jsondecode(' main.tf` reports 12 (one per resource and output) and `sha256(` 3.
2. **Hoist the expensive values** into one `locals` block:
   ```hcl
   locals {
     pieces    = jsondecode(file("${path.module}/data/pieces.json")).pieces
     checksum = sha256(jsonencode(local.pieces))
     piece_count = length(local.pieces)
     ids_by_quadrant = { for r in ["north","south","east","west"] : r => sort([for t in local.pieces : t.id if t.quadrant == r]) }
   }
   ```
3. **Replace the copies** with `local.pieces`, `local.checksum`, `local.piece_count` and
   `local.ids_by_quadrant["north"]`, etc. Do not change any output text.
4. **Verify.** `terraform plan` must report *No changes*: the files are byte-for-byte what they were,
   proving the refactor did not alter behaviour.
