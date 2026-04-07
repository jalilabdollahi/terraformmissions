locals {
  combined = concat(["a", "b"], ["c"])
}

output "combined" {
  value = local.combined
}
