resource "random_string" "ids" {
  count   = 3
  length  = 8
  special = false
}

# Fixed: use predetermined static keys; random values are used only in content
resource "local_file" "items" {
  for_each = toset(["item-0", "item-1", "item-2"])

  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
