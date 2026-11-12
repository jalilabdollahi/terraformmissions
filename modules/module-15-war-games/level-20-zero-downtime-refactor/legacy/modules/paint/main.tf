resource "random_integer" "coat" {
  for_each = toset(["gold", "crimson"])
  min      = 20
  max      = 90
}

output "coats" {
  value = { for k, v in random_integer.coat : k => v.result }
}
