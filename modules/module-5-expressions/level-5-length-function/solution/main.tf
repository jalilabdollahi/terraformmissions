variable "items" {
  type = map(string)
  default = {
    a = "apple"
    b = "banana"
    c = "cherry"
  }
}

resource "local_file" "output" {
  count    = length(var.items)
  content  = "item ${count.index}"
  filename = "${path.module}/item-${count.index}.txt"
}
