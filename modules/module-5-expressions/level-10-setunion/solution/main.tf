locals {
  combined = setunion(toset(["a", "b"]), toset(["c"]))
}

output "combined" {
  value = local.combined
}
