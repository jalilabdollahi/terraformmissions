variable "names" {
  type = set(string)
}

resource "random_integer" "shelves" {
  for_each = var.names
  min      = 500
  max      = 5000
}

output "shelves" {
  value = { for k, v in random_integer.shelves : k => v.result }
}
