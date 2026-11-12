variable "names" {
  type = set(string)
}

resource "random_integer" "loads" {
  for_each = var.names
  min      = 500
  max      = 5000
}

output "loads" {
  value = { for k, v in random_integer.loads : k => v.result }
}
