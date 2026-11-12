resource "random_uuid" "licence" {}

resource "time_static" "first_churn" {}

output "licence" {
  value = random_uuid.licence.result
}

output "first_churn" {
  value = time_static.first_churn.rfc3339
}
