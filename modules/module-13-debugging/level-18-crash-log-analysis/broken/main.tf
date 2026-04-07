# Bug: count = -1 is not valid — count must be a non-negative integer
resource "local_file" "items" {
  count    = -1
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
