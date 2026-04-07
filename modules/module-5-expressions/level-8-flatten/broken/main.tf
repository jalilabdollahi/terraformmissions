locals {
  # BUG: flatten expects all elements to be lists (or scalars that become single-element lists),
  # but "c" is a bare string, not a list. This causes a type error.
  items = flatten([["a", "b"], "c"])
}

output "items" {
  value = local.items
}
