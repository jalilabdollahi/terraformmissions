locals {
  items = tolist(["a", "b", "c"])
}

resource "local_file" "type_test" {
  content  = join(", ", local.items)
  filename = "${path.module}/items.txt"
}
