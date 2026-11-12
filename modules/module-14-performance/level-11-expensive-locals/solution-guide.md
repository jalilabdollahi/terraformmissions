# Walkthrough — Shard Tray Index Costs

1. **Count.** `grep -c 'jsondecode(' main.tf` reports 12 (one per resource and output) and `sha256(` 3.
2. **Hoist the expensive values** into one `locals` block:
   ```hcl
   locals {
     shards    = jsondecode(file("${path.module}/data/shards.json")).shards
     checksum = sha256(jsonencode(local.shards))
     shard_count = length(local.shards)
     ids_by_quadrant = { for r in ["north","south","east","west"] : r => sort([for t in local.shards : t.id if t.quadrant == r]) }
   }
   ```
3. **Replace the copies** with `local.shards`, `local.checksum`, `local.shard_count` and
   `local.ids_by_quadrant["north"]`, etc. Do not change any output text.
4. **Verify.** `terraform plan` must report *No changes*: the files are byte-for-byte what they were,
   proving the refactor did not alter behaviour.
