variable "items" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
    c = "cherry"
  }
}

# BUG: var.items.nonexistent is not a valid reference — maps use lookup() or []
resource "local_file" "output" {
  count    = length(var.items.nonexistent)
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
