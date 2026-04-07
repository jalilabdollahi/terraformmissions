resource "random_string" "suffix" {
  length  = 4
  special = false
  numeric = true
  upper   = false
}

# Fixed: count uses a static value known at plan time
resource "local_file" "items" {
  count    = 4
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
