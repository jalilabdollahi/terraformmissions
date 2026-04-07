locals {
  # BUG: setunion expects sets, not lists — pass toset() to convert first
  combined = setunion(["a", "b"], ["c"])
}

output "combined" {
  value = local.combined
}
