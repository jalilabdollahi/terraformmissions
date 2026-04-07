locals {
  allowed = ["a", "b", "c"]

  # BUG: index() errors if the value is not found in the list
  # "d" is not in the list, so this will fail at plan time
  position = index(local.allowed, "d")
}

output "position" {
  value = local.position
}
