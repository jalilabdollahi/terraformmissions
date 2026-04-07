resource "random_uuid" "app_id" {}

output "app_id" {
  value = random_uuid.app_id.id
}
