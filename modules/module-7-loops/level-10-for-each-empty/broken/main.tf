variable "items" {
  type    = map(string)
  default = {}
}

resource "local_file" "items" {
  for_each = var.items
  content  = "item: ${each.value}"
  filename = "${path.module}/item-${each.key}.txt"
}

# Fails when items is empty — no "main" key exists
output "main_file" {
  value = local_file.items["main"].filename
}
