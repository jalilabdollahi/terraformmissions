# Rustfield scrapyard: yard identity (its own state).

resource "random_pet" "yard_name" {
  length = 2
  prefix = "scrap"
}

resource "random_integer" "gate_count" {
  min = 6
  max = 24
}

output "yard_name" {
  value = random_pet.yard_name.id
}

output "gate_count" {
  value = random_integer.gate_count.result
}
