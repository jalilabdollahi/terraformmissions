resource "random_string" "res_4" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "res_5" {
  length  = 8
  special = false
  upper   = false
}

output "res_4_id" { value = random_string.res_4.result }
output "res_5_id" { value = random_string.res_5.result }
