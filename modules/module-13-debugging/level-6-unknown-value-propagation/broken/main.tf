resource "random_string" "suffix" {
  length  = 4
  special = false
  numeric = true
  upper   = false
}

# Bug: count uses a value that is unknown until apply
resource "local_file" "items" {
  count    = length(random_string.suffix.result)
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
