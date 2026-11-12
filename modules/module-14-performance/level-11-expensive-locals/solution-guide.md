# Walkthrough — Tile Press Index Costs

1. **Count.** `grep -c 'jsondecode(' main.tf` reports 12 (one per resource and output) and `sha256(` 3.
2. **Hoist the expensive values** into one `locals` block:
   ```hcl
   locals {
     tiles    = jsondecode(file("${path.module}/data/tiles.json")).tiles
     checksum = sha256(jsonencode(local.tiles))
     tile_count = length(local.tiles)
     ids_by_region = { for r in ["north","south","east","west"] : r => sort([for t in local.tiles : t.id if t.region == r]) }
   }
   ```
3. **Replace the copies** with `local.tiles`, `local.checksum`, `local.tile_count` and
   `local.ids_by_region["north"]`, etc. Do not change any output text.
4. **Verify.** `terraform plan` must report *No changes*: the files are byte-for-byte what they were,
   proving the refactor did not alter behaviour.
