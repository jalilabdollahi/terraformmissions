resource "random_integer" "strain" {
  for_each = toset(["bluemould", "brie"])
  min      = 20
  max      = 90
}

output "strains" {
  value = { for k, v in random_integer.strain : k => v.result }
}
