resource "random_string" "protected_data" {
  length  = 16
  special = false
  upper   = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_string" "temp_resource" {
  length  = 8
  special = false
  upper   = false
}

output "protected_id" { value = random_string.protected_data.result }
output "temp_id"      { value = random_string.temp_resource.result }
