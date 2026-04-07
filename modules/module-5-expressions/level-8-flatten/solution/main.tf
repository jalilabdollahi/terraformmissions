locals {
  items = flatten([["a", "b"], ["c"]])
}

output "items" {
  value = local.items
}
