resource "random_uuid" "licence" {}

resource "time_static" "first_spin" {}

output "licence" {
  value = random_uuid.licence.result
}

output "first_spin" {
  value = time_static.first_spin.rfc3339
}
