variable "names" {
  type    = list(string)
  default = ["a", "b"]
}

resource "local_file" "items" {
  for_each = toset(var.names)
  content  = "item: ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
