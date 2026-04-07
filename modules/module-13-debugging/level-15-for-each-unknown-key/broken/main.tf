resource "random_string" "ids" {
  count   = 3
  length  = 8
  special = false
}

# Bug: for_each keys come from random_string.result which is unknown at plan time
resource "local_file" "items" {
  for_each = { for r in random_string.ids : r.result => r.result }

  content  = "item ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
