variable "names" {
  type    = list(string)
  # Duplicate 'a' — toset() will silently deduplicate, resulting in only 2 files
  default = ["a", "b", "a"]
}

resource "local_file" "items" {
  for_each = toset(var.names)
  content  = "item: ${each.key}"
  filename = "${path.module}/item-${each.key}.txt"
}
