locals {
  allowed  = ["a", "b", "c"]
  is_valid = contains(local.allowed, "d")
}

output "is_valid" {
  value = local.is_valid
}
