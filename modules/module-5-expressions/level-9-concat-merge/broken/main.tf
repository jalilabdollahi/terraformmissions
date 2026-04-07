locals {
  # BUG: merge() is for maps, not lists
  combined = merge(["a", "b"], ["c"])
}

output "combined" {
  value = local.combined
}
