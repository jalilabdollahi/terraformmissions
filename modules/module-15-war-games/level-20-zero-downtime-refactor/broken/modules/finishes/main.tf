resource "random_integer" "coat_grams" {
  for_each = toset(["gold", "crimson"])
  min      = 20
  max      = 90
}

output "coats" {
  value = { for k, v in random_integer.coat_grams : k => v.result }
}
