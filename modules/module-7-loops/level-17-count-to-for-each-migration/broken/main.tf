# Migrated from count to for_each — but no moved blocks added.
resource "local_file" "items" {
  for_each = toset(["alpha", "beta"])
  content  = "item: ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
